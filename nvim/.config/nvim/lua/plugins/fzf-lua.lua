-- Example file path: lua/plugins/fzf-lua.lua

return {
  "ibhagwan/fzf-lua",
  -- Load very lazily
  event = "VeryLazy",
  -- Ensure web devicons are loaded for nice icons
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    -- Make fzf-lua functions available
    local fzf = require("fzf-lua")
    local actions = require("fzf-lua").actions -- Keep this if you plan to add qf/ll later

    ----------------------------------------------------------------------
    -- Custom Functions & Wrappers
    ----------------------------------------------------------------------

    local files_all_except_node_modules_cmd = "fd --type f --hidden --follow --no-ignore --exclude node_modules"

    local function blines_exact()
      fzf.blines({
        fzf_opts = { ["--exact"] = "" },
        prompt = "Exact Buffer ❯ ",
      })
    end

    local function files_prompt_wrapper(base_search_config)
      vim.ui.input({
        prompt = "Exclude folders (comma-sep, optional - Enter for default): ",
        completion = "dir",
      }, function(input)
        if input == nil then return end

        if input == "" then
          require("fzf-lua").files(base_search_config)
        else
          local exclusions_str = ""
          local folders = vim.split(input, ",")
          for _, folder in ipairs(folders) do
            local trimmed_folder = vim.trim(folder)
            if trimmed_folder ~= "" then
              exclusions_str = exclusions_str .. " --exclude " .. vim.fn.shellescape(trimmed_folder)
            end
          end
          local final_opts = vim.deepcopy(base_search_config)
          local original_prompt = base_search_config.prompt or "Files ❯ "
          final_opts.prompt = original_prompt:gsub("❯", "(Temp Excl.) ❯ ")
          if final_opts.cmd then
            final_opts.cmd = final_opts.cmd .. exclusions_str
          elseif final_opts.fd_opts then
            final_opts.fd_opts = final_opts.fd_opts .. exclusions_str
          else
            local default_fd_opts = "--type f --hidden --follow --exclude .git --exclude node_modules"
            final_opts.fd_opts = (base_search_config.fd_opts or default_fd_opts) .. exclusions_str
            final_opts.cmd = nil
          end
          require("fzf-lua").files(final_opts)
        end
      end)
    end

    local function grep_prompt_wrapper(base_grep_config)
      vim.ui.input({
        prompt = "Exclude folders/globs (comma-sep, optional - Enter for default): ",
      }, function(input)
        if input == nil then return end

        if input == "" then
          require("fzf-lua").live_grep(base_grep_config)
        else
          local exclusions_str = ""
          local patterns = vim.split(input, ",")
          for _, pattern in ipairs(patterns) do
            local trimmed_pattern = vim.trim(pattern)
            if trimmed_pattern ~= "" then
              exclusions_str = exclusions_str .. " -g '!" .. vim.fn.escape(trimmed_pattern, "'\\") .. "'"
            end
          end
          local final_opts = vim.deepcopy(base_grep_config)
          final_opts.prompt = (base_grep_config.prompt or "Grep ❯ "):gsub("❯", "(Temp Excl.) ❯ ")
          final_opts.rg_opts = (final_opts.rg_opts or "") .. exclusions_str
          require("fzf-lua").live_grep(final_opts)
        end
      end)
    end

    -- Grep for the word currently under the cursor using passed base config
    local function grep_word_under_cursor(base_grep_config_arg) -- Accept base config as argument
        local word = vim.fn.expand("<cword>")
        if word == "" then
            vim.notify("No word under cursor", vim.log.levels.WARN)
            return
        end
        local base_config = vim.deepcopy(base_grep_config_arg or {})
        base_config.search = word
        base_config.prompt = "Grep Word '" .. word .. "' ❯ "
        if base_config.fzf_opts and base_config.fzf_opts["--exact"] then
           base_config.prompt = "Grep Word Exact '" .. word .. "' ❯ "
        end
        require("fzf-lua").live_grep(base_config)
    end

    -- Find files matching specific extensions provided by the user
    local function find_by_filetype_prompt()
        vim.ui.input({ prompt = "Search file extensions (comma-separated): " }, function(input)
            if input == nil or vim.trim(input) == "" then
                vim.notify("No extensions provided.", vim.log.levels.WARN)
                return
            end

            local extensions_str = ""
            local clean_ext_list = {}
            local extensions = vim.split(input, ",")
            for _, ext in ipairs(extensions) do
                local trimmed_ext = vim.trim(ext):gsub("^%s*%.", "")
                if trimmed_ext ~= "" then
                    extensions_str = extensions_str .. " -e " .. vim.fn.shellescape(trimmed_ext)
                    table.insert(clean_ext_list, trimmed_ext)
                end
            end

            if extensions_str == "" then
                vim.notify("No valid extensions provided.", vim.log.levels.WARN)
                return
            end

            -- *** MODIFIED HERE: Use literal string to avoid scope issue ***
            local fd_base_opts = "--type f --hidden --follow --exclude .git --exclude node_modules"
            -- Construct command with base options, extension filters, and search from CWD (.)
            local cmd = "fd " .. fd_base_opts .. extensions_str .. " ."

            require("fzf-lua").files({
                cmd = cmd, -- Use the custom command
                prompt = "Files by Ext (" .. table.concat(clean_ext_list, ",") .. ") ❯ " -- Show searched extensions
            })
        end)
    end

    ----------------------------------------------------------------------
    -- FZF-LUA SETUP
    ----------------------------------------------------------------------
    local rg_base_opts_from_setup = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git' -g '!node_modules'"
    local grep_prompt_from_setup = "Grep ❯ "

    fzf.setup({
      winopts = {
        height = 0.85, width = 0.85, row = 0.5, col = 0.5,
        preview = {
          default = "bat", border = "single", layout = "horizontal", horizontal = "right:58%",
          wrap = true, scrollbar = "float", scrolloff = 2,
          winopts = { border = { "", "│", "", "", "", "│", "", "│" }, col = 0.42, },
        },
        wrap = true,
      },
      fzf_opts = {
        ["--layout"] = "reverse", ["--info"] = "inline", ["--wrap"] = "",
        ["--scrollbar"] = "▊", ["--border"] = "none", ["--padding"] = "0,0",
      },
      files = {
        fd_opts = "--type f --hidden --follow --exclude .git --exclude node_modules",
        prompt = "Files ❯ ",
      },
      grep = {
        rg_opts = rg_base_opts_from_setup,
        prompt = grep_prompt_from_setup,
      },
      keymap = {
        builtin = { ["<C-f>"] = "toggle-fullscreen", ["<C-p>"] = "results-prev", ["<C-g>"] = "toggle-preview-wrap", },
        fzf = { ["ctrl-u"] = "preview-page-up", ["ctrl-d"] = "preview-page-down", ["ctrl-o"] = "toggle-preview", },
      },
    })

    ----------------------------------------------------------------------
    -- Base Configurations for Searches (used by wrappers)
    ----------------------------------------------------------------------
    local ff_base_config = {
      fd_opts = "--type f --hidden --follow --exclude .git --exclude node_modules",
      prompt = "Files ❯ ",
    }
    local fe_base_config = {
      cmd = files_all_except_node_modules_cmd,
      prompt = "Files (All) ❯ ",
    }
    local gg_base_config = {
        rg_opts = rg_base_opts_from_setup,
        prompt = grep_prompt_from_setup,
    }
    local ge_base_config = {
        rg_opts = rg_base_opts_from_setup .. " --fixed-strings",
        fzf_opts = { ["--exact"] = "" },
        prompt = "Exact Grep ❯ ",
    }

    ----------------------------------------------------------------------
    -- Neovim Keymaps
    ----------------------------------------------------------------------
    local map = vim.keymap.set

    map("n", "<leader>ff", function() files_prompt_wrapper(ff_base_config) end, { desc = "Find Files (Default, Prompt Excl?)" })
    map("n", "<leader>fe", function() files_prompt_wrapper(fe_base_config) end, { desc = "Find Files All (Prompt Excl?)" })
    map("n", "<leader>ft", find_by_filetype_prompt, { desc = "[F]ind Files by File[T]ype" }) -- Maps to new function
    map("n", "<leader>fb", fzf.buffers, { desc = "Find Buffers" })
    map("n", "<leader>fo", fzf.oldfiles, { desc = "Find Recently Opened Files (Oldfiles)" })

    map("n", "<leader>gg", function() grep_prompt_wrapper(gg_base_config) end, { desc = "Live Grep (Fuzzy, Prompt Excl?)" })
    map("n", "<leader>ge", function() grep_prompt_wrapper(ge_base_config) end, { desc = "Live Grep (Exact, Prompt Excl?)" })
    map("n", "<leader>gw", function() grep_word_under_cursor(ge_base_config) end, { desc = "Live [G]rep for [W]ord under cursor (Exact)" })

    map("n", "<leader>fh", fzf.help_tags, { desc = "Find Help Tags" })
    map("n", "<leader>/", fzf.blines, { desc = "Search Current Buffer Lines" })
    map("n", "<leader>//", blines_exact, { desc = "Search Current Buffer Lines (Exact)" })

    map("n", "<leader>gs", fzf.git_status, { desc = "Git Status Files" })

  end,
}
