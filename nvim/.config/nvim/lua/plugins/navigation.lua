return {
  {
    "christoomey/vim-tmux-navigator",
    -- This plugin already exists in LazyVim's ecosystem; we only override mappings.
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Go to left split/tmux pane", silent = true },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Go to lower split/tmux pane", silent = true },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Go to upper split/tmux pane", silent = true },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Go to right split/tmux pane", silent = true },
    },
  },
}
