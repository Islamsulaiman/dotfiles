return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle = false, -- Prevent menu from closing automatically
          save_on_change = true,  -- Save list changes
          key = function() return vim.loop.cwd() end, -- Project-specific lists
        },
      })

      local keymap = vim.keymap.set

      -- Custom function for circular navigation
      local function navigate_circular(direction)
        return function()
          local list = harpoon:list()
          local length = #list.items
          if length == 0 then
            vim.notify("Harpoon: List is empty", vim.log.levels.WARN)
            return
          end

          -- Get current buffer and find its index
          local current_buf = vim.api.nvim_get_current_buf()
          local current_idx = nil
          for i, item in ipairs(list.items) do
            if item.value == vim.api.nvim_buf_get_name(current_buf) then
              current_idx = i
              break
            end
          end

          -- Calculate next/previous index
          local target_idx
          if direction == "next" then
            target_idx = current_idx and (current_idx % length) + 1 or 1
          elseif direction == "prev" then
            target_idx = current_idx and (current_idx - 1 > 0 and current_idx - 1 or length) or length
          end

          -- Select the target item
          list:select(target_idx)
        end
      end

      -- Custom function to show Harpoon list with fzf-lua
      local function harpoon_fzf()
        local list = harpoon:list()
        local items = list.items
        
        if #items == 0 then
          vim.notify("Harpoon list is empty", vim.log.levels.WARN)
          return
        end

        local entries = {}
        for i, item in ipairs(items) do
          -- Ensure item.value is a valid path
          local filepath = item.value
          if not filepath or filepath == "" then
            vim.notify("Invalid filepath for item " .. i .. ": " .. vim.inspect(item), vim.log.levels.ERROR)
            filepath = "<invalid>"
          end
          local display = string.format("%d: %s", i, filepath)
          table.insert(entries, display)
        end

        require("fzf-lua").fzf_exec(entries, {
          prompt = "Harpoon ❯ ",
          winopts = {
            height = 0.5,
            width = 0.6,
            row = 0.5,
            col = 0.5,
          },
          actions = {
            ["default"] = function(selected)
              if selected and #selected > 0 then
                local index = tonumber(selected[1]:match("^(%d+):"))
                if index and list.items[index] then
                  list:select(index)
                else
                  vim.notify("Invalid Harpoon index: " .. selected[1], vim.log.levels.ERROR)
                end
              end
            end,
            ["ctrl-d"] = function(selected)
              if selected and #selected > 0 then
                local index = tonumber(selected[1]:match("^(%d+):"))
                if index and list.items[index] then
                  list:remove_at(index)
                  vim.notify("Buffer removed from Harpoon", vim.log.levels.INFO)
                else
                  vim.notify("Invalid Harpoon index for deletion: " .. selected[1], vim.log.levels.ERROR)
                end
              end
            end,
          },
          fzf_opts = {
            ["--header"] = "Enter: select, Ctrl-d: delete",
            ["--layout"] = "reverse",
            ["--info"] = "inline",
          },
        })
      end

      -- Keybindings
      keymap("n", "<leader>hm", function()
        local list = harpoon:list()
        local filepath = vim.api.nvim_buf_get_name(0)
        if filepath == "" then
          vim.notify("No valid file to mark", vim.log.levels.WARN)
          return
        end
        list:add()
        vim.notify("File marked: " .. filepath, vim.log.levels.INFO)
      end, { desc = "Harpoon: Mark file" })
      keymap("n", "<leader>hl", harpoon_fzf, { desc = "Harpoon: Toggle menu" })
      keymap("n", "<leader>hn", navigate_circular("next"), { desc = "Harpoon: Next buffer (circular)" })
      keymap("n", "<leader>hp", navigate_circular("prev"), { desc = "Harpoon: Previous buffer (circular)" })
      keymap("n", "<leader>hd", function()
        local list = harpoon:list()
        local current_buf = vim.api.nvim_buf_get_name(0)
        for _, item in ipairs(list.items) do
          if item.value == current_buf then
            list:remove()
            vim.notify("Buffer removed from Harpoon", vim.log.levels.INFO)
            return
          end
        end
        vim.notify("Buffer not in Harpoon list", vim.log.levels.WARN)
      end, { desc = "Harpoon: Delete current buffer from list" })
      keymap("n", "<leader>hc", function() harpoon:list():clear() end, { desc = "Harpoon: Clear all buffers" })
      keymap("n", "<leader>ht", function()
        local list = harpoon:list()
        for i, item in ipairs(list.items) do
          print(string.format("%d: %s", i, item.value))
        end
      end, { desc = "Harpoon: Debug list" })
    end,
  },
}
