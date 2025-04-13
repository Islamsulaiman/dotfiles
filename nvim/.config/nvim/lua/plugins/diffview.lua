return {
  "sindrets/diffview.nvim",
  commit = "4516612fe98ff56ae0415a259ff6361a89419b0a",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  config = function()
    local function set_diff_highlights()
      vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#1e601c", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#601e1e", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "none", fg = "none" })
      vim.api.nvim_set_hl(0, "DiffText", { bg = "#1e3560", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = "#601e1e", fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { fg = "#555555" })
    end

    require("diffview").setup({
      enhanced_diff_hl = true,
      diff_algorithm = "patience",
      show_untracked = true,
      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_vertical",
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.number = false
        end,
        view_opened = function()
          set_diff_highlights()
        end,
      },
    })
  end,
  keys = {
    {
      "<leader>do",
      function()
        -- Toggle main Diffview
        local is_open = false
        for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
          local tab_wins = vim.api.nvim_tabpage_list_wins(tabpage)
          for _, win in ipairs(tab_wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "DiffviewFiles" or vim.bo[buf].filetype == "DiffviewFileHistory" then
              is_open = true
              break
            end
          end
          if is_open then break end
        end

        if is_open then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "Toggle Diffview",
    },
    {
      "<leader>dh",
      function()
        -- Toggle DiffviewFileHistory
        local is_history_open = false
        for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
          local tab_wins = vim.api.nvim_tabpage_list_wins(tabpage)
          for _, win in ipairs(tab_wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "DiffviewFileHistory" then
              is_history_open = true
              break
            end
          end
          if is_history_open then break end
        end

        if is_history_open then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewFileHistory")
        end
      end,
      desc = "Toggle file history",
    },
    {
      "<leader>dr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh Diffview",
    },
  },
}
