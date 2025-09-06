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

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -10<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +10<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -15<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +15<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>xa', ':bufdo bd<CR>', { desc = "close all saved buffers" }) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', { desc = "Open new buffer" })

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', { desc = "Vertical split view" } )
vim.keymap.set('n', '<leader>bh', '<C-w>s', { desc = 'open horizontal pane' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'make split windows equal width & height' })
vim.keymap.set('n', '<leader>xs', ':close<CR>', { desc = 'close current split window' })

-- Synchronized scrolling for vertical splits
vim.keymap.set('n', '<leader>sv', function()
  -- Toggle scrollbind for all visible windows
  local windows = vim.api.nvim_list_wins()
  local current_win = vim.api.nvim_get_current_win()
  local scrollbind_enabled = vim.wo[current_win].scrollbind

  for _, win in ipairs(windows) do
    if vim.api.nvim_win_is_valid(win) then
      vim.wo[win].scrollbind = not scrollbind_enabled
      vim.wo[win].cursorbind = not scrollbind_enabled
    end
  end

  if scrollbind_enabled then
    print("Synchronized scrolling disabled")
  else
    print("Synchronized scrolling enabled")
  end
end, { desc = 'Toggle synchronized scrolling across all splits' })

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

vim.keymap.set("n", "<leader>rn", function()
  local word = vim.fn.expand("<cword>")
  local cmd = ":%s/" .. vim.fn.escape(word, "/") .. "//gc<left><left><left>"
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), 'n', false)
end, { desc = "Replace in Buffer (confirm)" })

vim.o.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions" -- No saved 1"folds" in sessions

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

local function get_pr_for_current_line()
  local line = vim.fn.line('.')
  local file = vim.fn.expand('%')

  if file == '' then
    vim.notify("No file open")
    return
  end

  -- Get commit hash for current line
  local blame_cmd = "git blame -L " .. line .. "," .. line .. " " .. file .. " | awk '{print $1}'"
  local commit_hash = vim.fn.system(blame_cmd)
  commit_hash = commit_hash:gsub('%s+', '')

  if commit_hash == "" then
    vim.notify("No commit found")
    return
  end

  -- Find PR with GitHub CLI
  local pr_cmd = "gh pr list --search " .. commit_hash .. " --state merged --json number,title,url --limit 1"
  local pr_result = vim.fn.system(pr_cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("GitHub CLI error")
    return
  end

  local pr_data = vim.fn.json_decode(pr_result)
  if not pr_data or #pr_data == 0 then
    vim.notify("No PR found for this line")
    return
  end

  -- Open PR in browser
  local pr = pr_data[1]
  vim.notify("Opening PR #" .. pr.number)

  if vim.fn.has('mac') == 1 then
    vim.fn.system("open '" .. pr.url .. "'")
  else
    vim.fn.system("xdg-open '" .. pr.url .. "'")
  end
end

-- Keybinding
vim.keymap.set('n', '<leader>gpr', get_pr_for_current_line, { desc = "Open PR for current line" })

