-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  commit = "fcfa7a989cd6fed10abf02d9880dc76d7a38167d",
  config = function()
    require('gitsigns').setup {
      current_line_blame = true, -- Toggle with <leader>gb
    }

    vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', {})
    vim.keymap.set('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', {})
    vim.keymap.set('n', '<leader>gr', ':Gitsigns reset_hunk<CR>', {})
  end,
}
