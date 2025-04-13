return {
  "christoomey/vim-tmux-navigator",
  commit = "791dacfcfc8ccb7f6eb1c853050883b03e5a22fe",
  vim.keymap.set('n', 'C-h', ':TmuxNavigateLeft<CR>'),
  vim.keymap.set('n', 'C-j', ':TmuxNavigateDown<CR>'),
  vim.keymap.set('n', 'C-k', ':TmuxNavigateUp<CR>'),
  vim.keymap.set('n', 'C-l', ':TmuxNavigateRight<CR>'),

}
