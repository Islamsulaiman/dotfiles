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

    ----------------------------------------------------------------------
    -- Custom Functions & Wrappers
    ----------------------------------------------------------------------

    -- Command string for 'files_all_except_node_modules' behavior (<leader>fe base)
    local files_all_except_node_modules_cmd = "fd --type f --hidden --follow --no-ignore --exclude node_modules"

    -- Custom buffer line search with exact match (unchanged)
    local function blines_exact()
      fzf.blines({
        fzf_opts = { ["--exact"] = "" }, -- Enforce exact matching in fzf
        prompt = "Exact Buffer ❯ ",
      })
    end

    -- Generalized wrapper to prompt for temporary exclusions before searching files
    local function files_prompt_wrapper(base_search_config)
      vim.ui.input({
        prompt = "Exclude folders (comma-sep, optional - Enter for default): ",
        completion = "dir",
      }, function(input)
        if input == nil then return end -- User cancelled

        if input == "" then
          require("fzf-lua").files(base_search_config)
        else
          local exclusions_str = ""
          local folders = vim.split(input, ",")
          for _, folder in ipairs(folders) do
            local trimmed_folder = vim.trim(folder)
            if trimmed_folder ~= "" then
              -- fd uses --exclude FOLDER
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

    -- NEW: Generalized wrapper to prompt for temporary exclusions before live grep
    local function grep_prompt_wrapper(base_grep_config)
      vim.ui.input({
        prompt = "Exclude folders/globs (comma-sep, optional - Enter for default): ",
        -- No specific completion, user enters folder names or glob patterns
      }, function(input)
        if input == nil then return end -- Cancelled

        if input == "" then
          -- User pressed Enter, run the original grep
          require("fzf-lua").live_grep(base_grep_config)
        else
          -- User entered exclusions
          local exclusions_str = ""
          local patterns = vim.split(input, ",")
          for _, pattern in ipairs(patterns) do
            local trimmed_pattern = vim.trim(pattern)
            if trimmed_pattern ~= "" then
              -- rg uses -g '!PATTERN' (escape pattern for insertion into single quotes)
              exclusions_str = exclusions_str .. " -g '!" .. vim.fn.escape(trimmed_pattern, "'\\") .. "'"
            end
          end

          local final_opts = vim.deepcopy(base_grep_config)
          final_opts.prompt = (base_grep_config.prompt or "Grep ❯ "):gsub("❯", "(Temp Excl.) ❯ ")

          -- Append exclusions to existing rg_opts
          -- Ensure rg_opts exists, even if empty initially in base_grep_config
          final_opts.rg_opts = (final_opts.rg_opts or "") .. exclusions_str

          require("fzf-lua").live_grep(final_opts)
        end
      end)
    end

    ----------------------------------------------------------------------
    -- FZF-LUA SETUP
    ----------------------------------------------------------------------
    -- Define base rg options string here to use it in setup and base configs
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
        -- Use the variable defined above
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

    -- Base config for the default file search (<leader>ff)
    local ff_base_config = {
      fd_opts = "--type f --hidden --follow --exclude .git --exclude node_modules", -- Literal value from setup
      prompt = "Files ❯ ",                                                          -- Literal value from setup
    }

    -- Base config for the "all files except node_modules" search (<leader>fe)
    local fe_base_config = {
      cmd = files_all_except_node_modules_cmd, -- Use the custom command string defined earlier
      prompt = "Files (All) ❯ ",
    }

    -- Base config for the default fuzzy live grep search (<leader>gg)
    local gg_base_config = {
        rg_opts = rg_base_opts_from_setup, -- Use value defined before setup
        prompt = grep_prompt_from_setup,   -- Use value defined before setup
        -- fzf_opts = {}, -- Default fzf options are fine here
    }

    -- Base config for the exact live grep search (<leader>ge)
    local ge_base_config = {
        rg_opts = rg_base_opts_from_setup .. " --fixed-strings", -- Add fixed-strings for exact rg search
        fzf_opts = { ["--exact"] = "" },                         -- Add fzf exact flag
        prompt = "Exact Grep ❯ ",                                -- Specific prompt for exact grep
    }


    ----------------------------------------------------------------------
    -- Neovim Keymaps
    ----------------------------------------------------------------------
    local map = vim.keymap.set

    -- File/Buffer Search Keymaps (Using the file wrapper)
    map("n", "<leader>ff", function() files_prompt_wrapper(ff_base_config) end, { desc = "Find Files (Default, Prompt Excl?)" })
    map("n", "<leader>fe", function() files_prompt_wrapper(fe_base_config) end, { desc = "Find Files All (Prompt Excl?)" })
    map("n", "<leader>fb", fzf.buffers, { desc = "Find Buffers" })
    map("n", "<leader>fo", fzf.oldfiles, { desc = "Find Recently Opened Files (Oldfiles)" })

    -- Grep Keymaps (Using the NEW grep wrapper)
    map("n", "<leader>gg", function() grep_prompt_wrapper(gg_base_config) end, { desc = "Live Grep (Fuzzy, Prompt Excl?)" })
    map("n", "<leader>ge", function() grep_prompt_wrapper(ge_base_config) end, { desc = "Live Grep (Exact, Prompt Excl?)" })

    -- Other Search Keymaps
    map("n", "<leader>fh", fzf.help_tags, { desc = "Find Help Tags" })
    map("n", "<leader>/", fzf.blines, { desc = "Search Current Buffer Lines" })
    map("n", "<leader>//", blines_exact, { desc = "Search Current Buffer Lines (Exact)" })

    -- Git Related Keymaps
    map("n", "<leader>gs", fzf.git_status, { desc = "Git Status Files" })

  end, -- End of config function
} -- End of plugin specification
