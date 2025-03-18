return {
  {
    'voldikss/vim-floaterm',
    config = function()
      vim.keymap.set('n', '<Leader>tf', ':FloatermNew<CR>', { desc = 'Open new floating terminal' })
      vim.keymap.set('n', '<Leader>tt', ':FloatermToggle<CR>', { desc = 'Toggle terminal on/off' })
      vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>:FloatermToggle<CR>', { desc = 'Toggle terminal on/off' })

      -- Switching terminals
      vim.keymap.set('t', '<Leader>tn', '<C-\\><C-n>:FloatermNext<CR>', { desc = 'Switch to next terminal' })
      vim.keymap.set('t', '<Leader>tp', '<C-\\><C-n>:FloatermPrev<CR>', { desc = 'Switch to previous terminal' })

      -- Kill terminal with Ctrl+q
      vim.keymap.set('t', '<C-q>', '<C-\\><C-n>:FloatermKill<CR>', { desc = 'Kill terminal' })
    end
  }
}
