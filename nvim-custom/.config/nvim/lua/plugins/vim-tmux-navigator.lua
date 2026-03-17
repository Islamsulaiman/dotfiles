return {
  "christoomey/vim-tmux-navigator",
  commit = "791dacfcfc8ccb7f6eb1c853050883b03e5a22fe",
  config = function()
    vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<CR>', { noremap = true, silent = true })
  end,
}
