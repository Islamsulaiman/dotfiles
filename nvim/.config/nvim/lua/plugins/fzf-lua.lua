return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")

    -- Custom live_grep with optional exact match
    local function live_grep_exact(opts)
      opts = opts or {}
      local exact = opts.exact or false -- Default to fuzzy unless specified
      fzf.live_grep({
        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git' -g '!node_modules'" ..
                  (exact and " --fixed-strings" or ""), -- Add --fixed-strings for exact match
        fzf_opts = exact and { ["--exact"] = "" } or {}, -- Disable fuzzy matching in fzf
        prompt = exact and "Exact Grep ❯ " or "Fuzzy Grep ❯ ", -- Visual cue
      })
    end

    fzf.setup({
      winopts = {
        height = 0.85,
        width = 0.85,
        row = 0.5,
        col = 0.5,
        preview = {
          default = "bat",
          border = "single",
          layout = "horizontal",
          horizontal = "right:58%",
          wrap = true,
          scrollbar = "float",
          scrolloff = 2,
          winopts = {
            border = { "", "│", "", "", "", "│", "", "│" },
            col = 0.42,
          },
        },
        wrap = true,
      },
      fzf_opts = {
        ["--layout"] = "reverse",
        ["--info"] = "inline",
        ["--wrap"] = "",
        ["--scrollbar"] = "▊",
        ["--border"] = "none",
        ["--padding"] = "0,0",
      },
      files = {
        fd_opts = "--type f --hidden --follow --exclude .git --exclude node_modules",
        prompt = "Files ❯ ",
      },
      grep = {
        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git' -g '!node_modules'",
        prompt = "Grep ❯ ",
      },
      keymap = {
        builtin = {
          ["<C-f>"] = "toggle-fullscreen",
          ["<C-p>"] = "results-prev",
        },
        fzf = {
          ["ctrl-u"] = "preview-page-up",
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-o"] = "toggle-preview",
        },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>gg", fzf.live_grep, { desc = "Live Grep (Fuzzy)" })
    vim.keymap.set("n", "<leader>ge", function() live_grep_exact({ exact = true }) end, { desc = "Live Grep (Exact)" })
    vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find Buffers" })
    vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Find Help" })
    vim.keymap.set("n", "<leader>/", fzf.blines, { desc = "Search current buffer lines" })
    vim.keymap.set("n", "<leader>fo", fzf.oldfiles, { desc = "Find Recently Opened Files" })
    vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git Status Files" })
  end,
}
