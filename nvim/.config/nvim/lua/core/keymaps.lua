-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', { desc = 'save while in normal mode' })
vim.keymap.set('i', '<C-s>', '<Esc><cmd> w <CR>', { desc = 'save while in normal mode' })

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', { desc = "Open new buffer" })

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>bh', '<C-w>s', { desc = 'open horizontal pane' }) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Make the linting error messages selectable in a floating window
vim.keymap.set('n', '<leader>ll', function()
  vim.diagnostic.open_float()
  vim.diagnostic.open_float()
end, { desc = 'Open linting violations in floating mode' })

-- copy the current buffer relative path
vim.keymap.set('n', '<leader>cp', function()
  -- Get the relative path from the project root (current working directory)
  local relative_path = vim.fn.expand('%')
  vim.fn.setreg('+', relative_path)
  print("Copied: " .. relative_path)
end, { desc = 'Copy relative path of the current buffer from project root' })

-- Enable reordring tabs
vim.keymap.set('n', '<C-M-h>', ':BufferLineMovePrev<CR>', { desc = 'Move buffer to the previous position' })
vim.keymap.set('n', '<C-M-l>', ':BufferLineMoveNext<CR>', { desc = 'Move buffer to the next position' })

-- Reordring opened tabs
vim.keymap.set('n', '<C-M-h>', ':BufferLineMovePrev<CR>', { desc = 'Move buffer to the previous position' })
vim.keymap.set('n', '<C-M-l>', ':BufferLineMoveNext<CR>', { desc = 'Move buffer to the next position' })

vim.keymap.set("n", "<leader>rn", function()
  local word = vim.fn.expand("<cword>")
  local cmd = ":%s/" .. vim.fn.escape(word, "/") .. "//gc<left><left><left>"
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), 'n', false)
end, { desc = "Replace in Buffer (confirm)" })

vim.o.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions" -- No saved 1"folds" in sessions
