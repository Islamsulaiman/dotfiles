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
    -- Custom Functions
    ----------------------------------------------------------------------

    -- Custom live_grep with optional exact match (--fixed-strings)
    local function live_grep_exact(opts)
      opts = opts or {}
      local exact = opts.exact or false
      local rg_base_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git' -g '!node_modules'"
      fzf.live_grep({
        rg_opts = rg_base_opts .. (exact and " --fixed-strings" or ""),
        fzf_opts = exact and { ["--exact"] = "" } or {},
        prompt = exact and "Exact Grep ❯ " or "Fuzzy Grep ❯ ",
      })
    end

    -- Command string for 'files_all_except_node_modules' behavior (<leader>fe base)
    local files_all_except_node_modules_cmd = "fd --type f --hidden --follow --no-ignore --exclude node_modules"

    -- Custom buffer line search with exact match
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

    ----------------------------------------------------------------------
    -- FZF-LUA SETUP
    ----------------------------------------------------------------------
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
      -- Default command options for specific fzf-lua actions
      files = {
        -- Base command options for 'fd' when running fzf.files() (used by <leader>ff base)
        fd_opts = "--type f --hidden --follow --exclude .git --exclude node_modules",
        prompt = "Files ❯ ",
      },
      grep = {
        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git' -g '!node_modules'",
        prompt = "Grep ❯ ",
      },
      keymap = {
        builtin = { ["<C-f>"] = "toggle-fullscreen", ["<C-p>"] = "results-prev", ["<C-g>"] = "toggle-preview-wrap", },
        fzf = { ["ctrl-u"] = "preview-page-up", ["ctrl-d"] = "preview-page-down", ["ctrl-o"] = "toggle-preview", },
      },
    })

    ----------------------------------------------------------------------
    -- Base Configurations for File Searches (used by wrapper)
    ----------------------------------------------------------------------

    -- Base config for the default file search (<leader>ff)
    -- ***** MODIFIED HERE TO USE LITERAL VALUES *****
    local ff_base_config = {
      fd_opts = "--type f --hidden --follow --exclude .git --exclude node_modules", -- Use literal value from setup
      prompt = "Files ❯ ",                                                    -- Use literal value from setup
    }

    -- Base config for the "all files except node_modules" search (<leader>fe)
    local fe_base_config = {
      cmd = files_all_except_node_modules_cmd, -- Use the custom command string defined earlier
      prompt = "Files (All) ❯ ",
    }

    ----------------------------------------------------------------------
    -- Neovim Keymaps
    ----------------------------------------------------------------------
    local map = vim.keymap.set

    -- File/Buffer Search Keymaps (Using the wrapper for ff/fe)
    map("n", "<leader>ff", function() files_prompt_wrapper(ff_base_config) end, { desc = "Find Files (Default, Prompt Excl?)" })
    map("n", "<leader>fe", function() files_prompt_wrapper(fe_base_config) end, { desc = "Find Files All (Prompt Excl?)" })
    map("n", "<leader>fb", fzf.buffers, { desc = "Find Buffers" })
    map("n", "<leader>fo", fzf.oldfiles, { desc = "Find Recently Opened Files (Oldfiles)" })

    -- Grep Keymaps
    map("n", "<leader>gg", fzf.live_grep, { desc = "Live Grep (Fuzzy)" })
    map("n", "<leader>ge", function() live_grep_exact({ exact = true }) end, { desc = "Live Grep (Exact)" })

    -- Other Search Keymaps
    map("n", "<leader>fh", fzf.help_tags, { desc = "Find Help Tags" })
    map("n", "<leader>/", fzf.blines, { desc = "Search Current Buffer Lines" })
    map("n", "<leader>//", blines_exact, { desc = "Search Current Buffer Lines (Exact)" })

    -- Git Related Keymaps
    map("n", "<leader>gs", fzf.git_status, { desc = "Git Status Files" })

  end, -- End of config function
} -- End of plugin specification
