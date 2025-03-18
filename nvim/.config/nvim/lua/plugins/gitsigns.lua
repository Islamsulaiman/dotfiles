-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup()

    vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', {})
    vim.keymap.set('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', {})
    vim.keymap.set('n', '<leader>gr', ':Gitsigns reset_hunk<CR>', {})
  end,
}
