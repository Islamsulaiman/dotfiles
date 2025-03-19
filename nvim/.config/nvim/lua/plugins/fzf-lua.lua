return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      winopts = {
        height = 0.85,
        width = 0.85,
        row = 0.5, -- Centered
        col = 0.5, -- Centered
        preview = {
          default = "bat", -- Fallback to "cat" if bat isn’t installed
          border = "single", -- Visible divider
          layout = "horizontal",
          horizontal = "right:60%", -- Preview on right
          wrap = true, -- Line wrapping in preview pane
          scrollbar = "float", -- Bolder scrollbar for preview pane
          scrolloff = 2, -- Small margin from right edge for visibility
          winopts = {
            border = { "", "│", "", "", "", "│", "", "│" }, -- Custom border with margin effect
          },
        },
        wrap = true, -- Suggests wrapping, but fzf_opts enforces it
      },
      fzf_opts = {
        ["--layout"] = "reverse",
        ["--info"] = "inline",
        ["--wrap"] = "", -- Enable wrapping for results pane
        ["--scrollbar"] = "▊", -- Bolder scrollbar for files pane
        ["--border"] = "none", -- Remove default fzf border to avoid overlap
        ["--padding"] = "0,1", -- Add 1 column padding on left/right for margin
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
          ["<C-p>"] = "results-prev", -- Go up in file pane
        },
        fzf = {
          ["ctrl-u"] = "preview-page-up", -- Go up in preview pane
          ["ctrl-d"] = "preview-page-down", -- Go down in preview pane
          ["ctrl-o"] = "toggle-preview", -- Toggle preview visibility
        },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
    vim.keymap.set("n", "<space><space>", fzf.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find Buffers" })
    vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Find Help" })
    vim.keymap.set("n", "<leader>/", fzf.blines, { desc = "Search current buffer lines" })
    vim.keymap.set("n", "<leader>fo", fzf.oldfiles, { desc = "Find Recently Opened Files" })
    vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git Status Files" })
  end,
}
