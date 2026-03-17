-- Brings gh-dash to Neovim

return {
  'johnseth97/gh-dash.nvim',
  lazy = true,
  keys = {
    {
      '<leader>cc',
      function() 
        require('gh_dash').toggle()
        vim.defer_fn(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
              local buf = vim.api.nvim_win_get_buf(win)
              vim.api.nvim_set_current_win(win)
              
              -- Remap 'q' to close window instead of quitting gh-dash
              vim.api.nvim_buf_set_keymap(buf, 't', 'q', 
                '<C-\\><C-n><cmd>close<CR>', 
                { noremap = true, silent = true })
              
              -- Add escape mapping too for good measure  
              vim.api.nvim_buf_set_keymap(buf, 't', '<Esc><Esc>', 
                '<C-\\><C-n><cmd>close<CR>', 
                { noremap = true, silent = true })
              
              vim.cmd("startinsert")
              break
            end
          end
        end, 50)
      end,
      desc = 'Toggle gh-dash popup',
    },
  },
  opts = {
    keymaps = {},
    border = 'rounded', 
    width = 0.9,
    height = 0.9,
    autoinstall = true,
  },
}
