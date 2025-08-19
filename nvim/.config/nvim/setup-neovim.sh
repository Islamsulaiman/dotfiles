#!/bin/bash

# =====================================================================
# NEOVIM KICKSTART 2025 - ONE-COMMAND SETUP SCRIPT
# Sets up complete Neovim configuration on any Linux machine
# =====================================================================



# Run `chmod +x nvim/.config/nvim/setup-neovim.sh` to gain write access
set -e  # Exit on any error

echo "🚀 Setting up Neovim Kickstart 2025..."

# =====================================================================
# 1. UPDATE PACKAGES
# =====================================================================
echo "📦 Updating package lists..."
sudo apt-get update

# =====================================================================
# 2. INSTALL NEOVIM
# =====================================================================
echo "📥 Installing Neovim..."
sudo apt-get install neovim -y

# Also install some useful dependencies
echo "📥 Installing useful dependencies..."
sudo apt-get install git curl build-essential -y

# =====================================================================
# 3. CREATE NEOVIM CONFIG DIRECTORY
# =====================================================================
echo "📁 Creating Neovim config directory..."
mkdir -p ~/.config/nvim

# =====================================================================
# 4. CREATE INIT.LUA WITH COMPLETE CONFIGURATION
# =====================================================================
echo "⚙️  Creating init.lua with complete configuration..."

cat > ~/.config/nvim/init.lua << 'EOF'
-- =====================================================================
-- NEOVIM KICKSTART 2025 - CONSOLIDATED SINGLE FILE CONFIGURATION
-- All core settings, keymaps, and plugin configurations in one file
-- =====================================================================

-- =====================================================================
-- CORE OPTIONS & SETTINGS
-- =====================================================================
vim.wo.number = true
vim.o.clipboard = 'unnamedplus'
vim.o.wrap = false
vim.o.linebreak = true
vim.o.mouse = 'a'
vim.o.autoindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.scrolloff = 4
vim.o.sidescrolloff = 8
vim.o.cursorline = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.hlsearch = false
vim.o.showmode = false
vim.opt.termguicolors = true
vim.o.whichwrap = 'bs<>[]hl'
vim.o.numberwidth = 4
vim.o.swapfile = false
vim.o.smartindent = true
vim.o.showtabline = 2
vim.o.backspace = 'indent,eol,start'
vim.o.pumheight = 10
vim.o.conceallevel = 0
vim.wo.signcolumn = 'yes'
vim.o.fileencoding = 'utf-8'
vim.o.cmdheight = 1
vim.o.breakindent = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.completeopt = 'menuone,noselect'
vim.opt.shortmess:append 'c'
vim.opt.iskeyword:append '-'
vim.opt.formatoptions:remove { 'c', 'r', 'o' }
vim.opt.runtimepath:remove '/usr/share/vim/vimfiles'
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.spelllang='en_us'
vim.opt.spell=true

-- =====================================================================
-- LEADER KEY & KEYMAPS
-- =====================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable spacebar default behavior
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local opts = { noremap = true, silent = true }

-- File operations
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', { desc = 'save while in normal mode' })
vim.keymap.set('i', '<C-s>', '<Esc><cmd> w <CR>', { desc = 'save while in normal mode' })
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- Navigation
vim.keymap.set('n', 'x', '"_x', opts)
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Window resizing
vim.keymap.set('n', '<Up>', ':resize -10<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +10<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -15<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +15<CR>', opts)

-- Buffer management
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts)
vim.keymap.set('n', '<leader>xa', ':bufdo bd<CR>', { desc = "close all saved buffers" })
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', { desc = "Open new buffer" })

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts)
vim.keymap.set('n', '<leader>bh', '<C-w>s', { desc = 'open horizontal pane' })
vim.keymap.set('n', '<leader>se', '<C-w>=', opts)
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts)

-- Text manipulation
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>ll', function()
  vim.diagnostic.open_float()
  vim.diagnostic.open_float()
end, { desc = 'Open linting violations in floating mode' })

-- Utilities
vim.keymap.set('n', '<leader>cp', function()
  local relative_path = vim.fn.expand('%')
  vim.fn.setreg('+', relative_path)
  print("Copied: " .. relative_path)
end, { desc = 'Copy relative path of the current buffer from project root' })

vim.keymap.set('n', '<C-M-h>', ':BufferLineMovePrev<CR>', { desc = 'Move buffer to the previous position' })
vim.keymap.set('n', '<C-M-l>', ':BufferLineMoveNext<CR>', { desc = 'Move buffer to the next position' })

vim.keymap.set("n", "<leader>rn", function()
  local word = vim.fn.expand("<cword>")
  local cmd = ":%s/" .. vim.fn.escape(word, "/") .. "//gc<left><left><left>"
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), 'n', false)
end, { desc = "Replace in Buffer (confirm)" })

-- Toggle untracked file highlighting
vim.keymap.set('n', '<leader>tu', function()
  local current_ns = vim.api.nvim_create_namespace('untracked_file')
  local has_highlights = false
  
  -- Check if there are any highlights in the namespace
  local marks = vim.api.nvim_buf_get_extmarks(0, current_ns, 0, -1, {})
  has_highlights = #marks > 0
  
  if has_highlights then
    -- Clear highlights
    vim.api.nvim_buf_clear_namespace(0, current_ns, 0, -1)
    vim.wo.winhl = ''
    print("Untracked file highlighting disabled")
  else
    -- Re-apply highlights
    apply_untracked_highlighting()
    print("Untracked file highlighting enabled")
  end
end, { desc = "Toggle untracked file highlighting" })

-- =====================================================================
-- CORE SNIPPETS & AUTOCMDS
-- =====================================================================
vim.highlight.priorities.semantic_tokens = 95

vim.diagnostic.config {
  virtual_text = {
    prefix = '●',
    format = function(diagnostic)
      local code = diagnostic.code and string.format('[%s]', diagnostic.code) or ''
      return string.format('%s %s', code, diagnostic.message)
    end,
  },
  underline = false,
  update_in_insert = true,
  float = {
    source = 'always',
  },
  on_ready = function()
    vim.cmd 'highlight DiagnosticVirtualText guibg=NONE'
  end,
}

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Core macros
vim.fn.setreg("c", "gg_vG$y")

-- Untracked file highlighting autocmds
local untracked_group = vim.api.nvim_create_augroup('UntrackedFileHighlight', { clear = true })

-- Define highlight groups for untracked files
vim.api.nvim_create_autocmd('ColorScheme', {
  group = untracked_group,
  callback = function()
    vim.api.nvim_set_hl(0, 'UntrackedFile', { fg = '#ff9e64', bg = '#2d3748' })
    vim.api.nvim_set_hl(0, 'UntrackedFileLineNr', { fg = '#ff9e64', bold = true })
  end,
  pattern = '*',
})

-- Set initial highlight groups
vim.api.nvim_set_hl(0, 'UntrackedFile', { fg = '#ff9e64', bg = '#2d3748' })
vim.api.nvim_set_hl(0, 'UntrackedFileLineNr', { fg = '#ff9e64', bold = true })

-- Function to check if file is untracked
local function is_file_untracked(filepath)
  if not filepath or filepath == '' then return false end
  
  -- Check if we're in a git repo
  local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  
  if not result or result:match("true") == nil then
    return false
  end
  
  -- Check git status
  local handle2 = io.popen("git status --porcelain " .. vim.fn.shellescape(filepath) .. " 2>/dev/null")
  local git_result = handle2:read("*a")
  handle2:close()
  
  if git_result == "" then
    -- Check if file is tracked
    local handle3 = io.popen("git ls-files " .. vim.fn.shellescape(filepath) .. " 2>/dev/null")
    local tracked = handle3:read("*a")
    handle3:close()
    
    return tracked == "" and vim.fn.filereadable(filepath) == 1
  else
    return git_result:sub(1, 1) == "?"
  end
end

-- Function to apply untracked file highlighting
local function apply_untracked_highlighting()
  local filepath = vim.fn.expand('%:p')
  if is_file_untracked(filepath) then
    -- Change line number color for untracked files
    vim.wo.winhl = 'LineNr:UntrackedFileLineNr,CursorLineNr:UntrackedFileLineNr'
    
    -- Add a subtle background highlight
    vim.api.nvim_buf_set_var(0, 'is_untracked', true)
    
    -- Create a namespace for untracked file highlighting
    local ns_id = vim.api.nvim_create_namespace('untracked_file')
    
    -- Add a subtle highlight to the entire buffer (just first few lines as indicator)
    for i = 1, math.min(5, vim.api.nvim_buf_line_count(0)) do
      vim.api.nvim_buf_add_highlight(0, ns_id, 'UntrackedFile', i - 1, 0, -1)
    end
  else
    -- Reset highlighting for tracked files
    vim.wo.winhl = ''
    vim.api.nvim_buf_set_var(0, 'is_untracked', false)
    
    -- Clear untracked highlights
    local ns_id = vim.api.nvim_create_namespace('untracked_file')
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end
end

-- Apply highlighting when entering a buffer
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
  group = untracked_group,
  callback = apply_untracked_highlighting,
  pattern = '*',
})

-- Update highlighting when git status changes
vim.api.nvim_create_autocmd('User', {
  group = untracked_group,
  pattern = 'GitSignsUpdate',
  callback = apply_untracked_highlighting,
})

-- =====================================================================
-- LAZY PLUGIN MANAGER SETUP
-- =====================================================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- =====================================================================
-- ALL PLUGIN CONFIGURATIONS IN ONE TABLE
-- =====================================================================
require('lazy').setup({
  -- NEO-TREE FILE EXPLORER
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      '3rd/image.nvim',
      {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        config = function()
          require('window-picker').setup {
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              bo = {
                filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                buftype = { 'terminal', 'quickfix' },
              },
            },
          }
        end,
      },
    },
    event = "VimEnter",
    config = function()
      -- Configure diagnostic signs using modern API
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
            [vim.diagnostic.severity.HINT] = '󰌵',
          }
        }
      })

      -- Custom highlight groups for neo-tree git status
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          vim.api.nvim_set_hl(0, 'NeoTreeGitUntracked', { fg = '#ff9e64', bold = true })
          vim.api.nvim_set_hl(0, 'NeoTreeGitAdded', { fg = '#9ece6a', bold = true })
          vim.api.nvim_set_hl(0, 'NeoTreeGitModified', { fg = '#7aa2f7', bold = true })
        end,
      })
      
      -- Set initial highlight groups
      vim.api.nvim_set_hl(0, 'NeoTreeGitUntracked', { fg = '#ff9e64', bold = true })
      vim.api.nvim_set_hl(0, 'NeoTreeGitAdded', { fg = '#9ece6a', bold = true })
      vim.api.nvim_set_hl(0, 'NeoTreeGitModified', { fg = '#7aa2f7', bold = true })

      require('neo-tree').setup {
        close_if_last_window = false,
        popup_border_style = 'rounded',
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
        sort_case_insensitive = false,
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              vim.cmd("silent! setlocal bufhidden=wipe")
            end,
          },
          {
            event = "vim_after_session_load",
            handler = function()
              vim.cmd("Neotree show")
            end,
          },
        },
        default_component_configs = {
          container = { enable_character_fade = true },
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = '│',
            last_indent_marker = '└',
            highlight = 'NeoTreeIndentMarker',
            with_expanders = true,
            expander_collapsed = '',
            expander_expanded = '',
            expander_highlight = 'NeoTreeExpander',
          },
          icon = {
            folder_closed = '',
            folder_open = '',
            folder_empty = '󰜌',
            default = '*',
            highlight = 'NeoTreeFileIcon',
          },
          modified = { symbol = '[+]', highlight = 'NeoTreeModified' },
          name = { trailing_slash = false, use_git_status_colors = true, highlight = 'NeoTreeFileName' },
          git_status = {
            symbols = {
              added = '',
              modified = '',
              deleted = '✖',
              renamed = '󰁕',
              untracked = ' ',
              ignored = '',
              unstaged = '󰄱',
              staged = '',
              conflict = '',
            },
          },
          file_size = { enabled = true, required_width = 64 },
          type = { enabled = true, required_width = 122 },
          last_modified = { enabled = true, required_width = 88 },
          created = { enabled = true, required_width = 110 },
          symlink_target = { enabled = false },
        },
        window = {
          position = 'left',
          width = 40,
          mapping_options = { noremap = true, nowait = true },
          mappings = {
            ['<space>'] = { 'toggle_node', nowait = false },
            ['<2-LeftMouse>'] = 'open',
            ['<cr>'] = 'open',
            ['<esc>'] = 'cancel',
            ['P'] = { 'toggle_preview', config = { use_float = true } },
            ['l'] = 'open',
            ['S'] = 'open_split',
            ['s'] = 'open_vsplit',
            ['t'] = 'open_tabnew',
            ['w'] = 'open_with_window_picker',
            ['C'] = 'close_node',
            ['z'] = 'close_all_nodes',
            ['a'] = { 'add', config = { show_path = 'none' } },
            ['A'] = 'add_directory',
            ['d'] = 'delete',
            ['r'] = 'rename',
            ['y'] = 'copy_to_clipboard',
            ['x'] = 'cut_to_clipboard',
            ['p'] = 'paste_from_clipboard',
            ['c'] = 'copy',
            ['m'] = 'move',
            ['q'] = 'close_window',
            ['R'] = 'refresh',
            ['?'] = 'show_help',
            ['<'] = 'prev_source',
            ['>'] = 'next_source',
            ['i'] = 'show_file_details',
          },
        },
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
            hide_by_name = { '.DS_Store', 'thumbs.db', 'node_modules', '__pycache__', '.virtual_documents', '.git', '.python-version', '.venv' },
            hide_by_pattern = {},
            always_show = {},
            never_show = {},
            never_show_by_pattern = {},
          },
          follow_current_file = { enabled = true, leave_dirs_open = false },
          group_empty_dirs = false,
          hijack_netrw_behavior = 'disabled',
          use_libuv_file_watcher = true,
          window = {
            mappings = {
              ['<bs>'] = 'navigate_up',
              ['.'] = 'set_root',
              ['H'] = 'toggle_hidden',
              ['/'] = 'fuzzy_finder',
              ['D'] = 'fuzzy_finder_directory',
              ['#'] = 'fuzzy_sorter',
              ['f'] = 'filter_on_submit',
              ['<c-x>'] = 'clear_filter',
              ['[g'] = 'prev_git_modified',
              [']g'] = 'next_git_modified',
              ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
              ['oc'] = { 'order_by_created', nowait = false },
              ['od'] = { 'order_by_diagnostics', nowait = false },
              ['og'] = { 'order_by_git_status', nowait = false },
              ['om'] = { 'order_by_modified', nowait = false },
              ['on'] = { 'order_by_name', nowait = false },
              ['os'] = { 'order_by_size', nowait = false },
              ['ot'] = { 'order_by_type', nowait = false },
            },
            fuzzy_finder_mappings = {
              ['<down>'] = 'move_cursor_down',
              ['<C-n>'] = 'move_cursor_down',
              ['<up>'] = 'move_cursor_up',
              ['<C-p>'] = 'move_cursor_up',
            },
          },
        },
        buffers = {
          follow_current_file = { enabled = true, leave_dirs_open = false },
          group_empty_dirs = true,
          show_unloaded = true,
          window = {
            mappings = {
              ['bd'] = 'buffer_delete',
              ['<bs>'] = 'navigate_up',
              ['.'] = 'set_root',
              ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
              ['oc'] = { 'order_by_created', nowait = false },
              ['od'] = { 'order_by_diagnostics', nowait = false },
              ['om'] = { 'order_by_modified', nowait = false },
              ['on'] = { 'order_by_name', nowait = false },
              ['os'] = { 'order_by_size', nowait = false },
              ['ot'] = { 'order_by_type', nowait = false },
            },
          },
        },
        git_status = {
          window = {
            position = 'float',
            mappings = {
              ['A'] = 'git_add_all',
              ['gu'] = 'git_unstage_file',
              ['ga'] = 'git_add_file',
              ['gr'] = 'git_revert_file',
              ['gc'] = 'git_commit',
              ['gp'] = 'git_push',
              ['gg'] = 'git_commit_and_push',
              ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
              ['oc'] = { 'order_by_created', nowait = false },
              ['od'] = { 'order_by_diagnostics', nowait = false },
              ['om'] = { 'order_by_modified', nowait = false },
              ['on'] = { 'order_by_name', nowait = false },
              ['os'] = { 'order_by_size', nowait = false },
              ['ot'] = { 'order_by_type', nowait = false },
            },
          },
        },
        -- Custom renderers for better git status visibility
        renderers = {
          file = {
            { "icon" },
            { "name", use_git_status_colors = true },
            { "git_status", highlight = function(state, node)
              local git_status = node:get_git_status()
              if git_status == "??" then
                return "NeoTreeGitUntracked"
              elseif git_status == "A " then
                return "NeoTreeGitAdded"
              elseif git_status == " M" or git_status == "M " then
                return "NeoTreeGitModified"
              end
              return "NeoTreeGitStatus"
            end },
            { "diagnostics" },
          },
        },
      }

      -- Keymaps
      vim.cmd [[nnoremap \ :Neotree reveal<cr>]]
      vim.keymap.set('n', '<leader>e', ':Neotree toggle position=left<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>fe', ':Neotree toggle position=float<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>ngs', ':Neotree float git_status<CR>', { noremap = true, silent = true })
    end,
  },

  -- BUFFERLINE
  {
    'akinsho/bufferline.nvim',
    dependencies = {
      'moll/vim-bbye',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      -- Custom function to get git status for bufferline
      local function get_git_status_for_buffer(buf_name)
        if not buf_name or buf_name == '' then return '' end
        
        local handle = io.popen("git status --porcelain " .. vim.fn.shellescape(buf_name) .. " 2>/dev/null")
        local result = handle:read("*a")
        handle:close()
        
        if result == "" then
          local handle2 = io.popen("git ls-files " .. vim.fn.shellescape(buf_name) .. " 2>/dev/null")
          local tracked = handle2:read("*a")
          handle2:close()
          
          if tracked == "" and vim.fn.filereadable(buf_name) == 1 then
            return ' '  -- Untracked icon
          end
        else
          local status_char = result:sub(1, 1)
          if status_char == "?" then
            return ' '  -- Untracked icon
          elseif status_char == "A" then
            return ' '  -- Added icon
          elseif status_char == "M" then
            return ' '  -- Modified icon
          end
        end
        
        return ''
      end

      require('bufferline').setup {
        options = {
          mode = 'buffers',
          themable = true,
          numbers = 'none',
          close_command = 'Bdelete! %d',
          buffer_close_icon = '✗',
          close_icon = '✗',
          path_components = 1,
          modified_icon = '●',
          left_trunc_marker = '',
          right_trunc_marker = '',
          max_name_length = 30,
          max_prefix_length = 30,
          tab_size = 21,
          diagnostics = false,
          diagnostics_update_in_insert = false,
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          persist_buffer_sort = true,
          separator_style = { '│', '│' },
          enforce_regular_tabs = true,
          always_show_bufferline = true,
          show_tab_indicators = false,
          indicator = {
            style = 'none',
          },
          icon_pinned = '󰐃',
          minimum_padding = 1,
          maximum_padding = 5,
          maximum_length = 15,
          sort_by = 'insert_at_end',
          name_formatter = function(buf)
            local git_status = get_git_status_for_buffer(buf.name)
            return buf.name .. git_status
          end,
        },
        highlights = {
          separator = {
            fg = '#434C5E',
          },
          buffer_selected = {
            bold = true,
            italic = false,
          },
          -- Highlight untracked files with orange color
          untracked = {
            fg = '#ff9e64',
            bg = '#2d3748',
            bold = true,
          },
        },
      }
    end,
  },

  -- LUALINE STATUS LINE
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      local mode = {
        'mode',
        fmt = function(str)
          return ' ' .. str
        end,
      }

      local filename = {
        'filename',
        file_status = true,
        path = 0,
        symbols = {
          modified = '[+]',
          readonly = '[RO]',
          unnamed = '[No Name]',
          newfile = '[New]',
        },
      }

      -- Git status component for untracked files
      local git_status = {
        function()
          local function is_git_repo()
            vim.fn.system("git rev-parse --is-inside-work-tree")
            return vim.v.shell_error == 0
          end

          local function get_git_status()
            if not is_git_repo() then
              return ""
            end
            
            local file = vim.fn.expand('%')
            if file == '' then return "" end
            
            local handle = io.popen("git status --porcelain " .. vim.fn.shellescape(file) .. " 2>/dev/null")
            local result = handle:read("*a")
            handle:close()
            
            if result == "" then
              -- Check if file exists and is tracked
              local handle2 = io.popen("git ls-files " .. vim.fn.shellescape(file) .. " 2>/dev/null")
              local tracked = handle2:read("*a")
              handle2:close()
              
              if tracked == "" and vim.fn.filereadable(file) == 1 then
                return "  UNTRACKED"
              end
            else
              local status_char = result:sub(1, 1)
              if status_char == "?" then
                return "  UNTRACKED"
              elseif status_char == "A" then
                return "  ADDED"
              elseif status_char == "M" then
                return "  MODIFIED"
              elseif status_char == "D" then
                return "  DELETED"
              end
            end
            
            return ""
          end
          
          return get_git_status()
        end,
        color = function()
          local file = vim.fn.expand('%')
          if file == '' then return nil end
          
          local handle = io.popen("git status --porcelain " .. vim.fn.shellescape(file) .. " 2>/dev/null")
          local result = handle:read("*a")
          handle:close()
          
          if result == "" then
            local handle2 = io.popen("git ls-files " .. vim.fn.shellescape(file) .. " 2>/dev/null")
            local tracked = handle2:read("*a")
            handle2:close()
            
            if tracked == "" and vim.fn.filereadable(file) == 1 then
              return { fg = '#ff9e64', bg = '#2d3748', gui = 'bold' } -- Orange for untracked
            end
          else
            local status_char = result:sub(1, 1)
            if status_char == "?" then
              return { fg = '#ff9e64', bg = '#2d3748', gui = 'bold' } -- Orange for untracked
            elseif status_char == "A" then
              return { fg = '#9ece6a', gui = 'bold' } -- Green for added
            elseif status_char == "M" then
              return { fg = '#7aa2f7', gui = 'bold' } -- Blue for modified
            end
          end
          
          return nil
        end,
        cond = function()
          return vim.fn.expand('%') ~= ''
        end,
      }

      local hide_in_width = function()
        return vim.fn.winwidth(0) > 100
      end

      local diagnostics = {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        sections = { 'error', 'warn' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        colored = false,
        update_in_insert = false,
        always_visible = false,
        cond = hide_in_width,
      }

      local diff = {
        'diff',
        colored = false,
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        cond = hide_in_width,
      }

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'nord',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          disabled_filetypes = { 'alpha', 'neo-tree' },
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { mode },
          lualine_b = { 'branch' },
          lualine_c = { filename, git_status },
          lualine_x = { diagnostics, diff, { 'encoding', cond = hide_in_width }, { 'filetype', cond = hide_in_width } },
          lualine_y = { 'location' },
          lualine_z = { 'progress' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { { 'location', padding = 0 } },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { 'fugitive' },
      }
    end,
  },

  -- TREESITTER
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'lua', 'python', 'javascript', 'typescript', 'vimdoc', 'vim', 'regex',
        'terraform', 'sql', 'dockerfile', 'toml', 'json', 'java', 'gitignore',
        'graphql', 'yaml', 'make', 'cmake', 'markdown', 'markdown_inline',
        'bash', 'tsx', 'css', 'html', 'ruby',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ruby",
        callback = function()
          vim.bo.indentkeys = vim.bo.indentkeys:gsub(",?%.","")
          vim.bo.indentexpr = "GetRubyIndent()"
        end,
      })
    end,
  },

  -- TREESITTER CONTEXT
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true,
      trim_scope = 'outer',
      patterns = {
        default = {
          'class', 'function', 'method', 'for', 'while', 'if', 'switch', 'case',
        },
        lua = {
          'function', 'if_statement', 'for_statement',
        },
        ruby = {
          'module', 'class', 'method', 'do_block', 'if', 'method_call',
          exclude_patterns = { 'comment' },
        },
        rails = {
          'class', 'method', 'do_block',
          exclude_patterns = { 'comment' },
        },
      },
      exclude_patterns = {
        'comment', 'line_comment', 'block_comment',
      },
    },
    config = function(_, opts)
      require('treesitter-context').setup(opts)
    end,
  },

  -- LSP CONFIGURATION
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('fzf-lua').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('fzf-lua').lsp_references, '[G]oto [R]eferences')
          map('gI', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('fzf-lua').lsp_typedefs, 'Type [D]efinition')
          map('<leader>ds', require('fzf-lua').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('fzf-lua').lsp_workspace_symbols, '[W]orkspace [S]ymbols')

          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('<leader>td', function()
            local current_config = vim.diagnostic.config()
            local new_virtual_text = not (current_config.virtual_text and current_config.virtual_text ~= false)
            vim.diagnostic.config({ virtual_text = new_virtual_text })
            print("Diagnostic virtual text " .. (new_virtual_text and "enabled" or "disabled"))
          end, '[T]oggle [D]iagnostic Virtual Text')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        ts_ls = {},
        ruby_lsp = {},
        html = { filetypes = { 'html', 'twig', 'hbs' } },
        cssls = {},
        tailwindcss = {},
        dockerls = {},
        sqlls = {},
        terraformls = {},
        jsonls = {},
        yamlls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
              },
              diagnostics = { disable = { 'missing-fields' } },
              format = { enable = false },
            },
          },
        },
      }

      require('mason').setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- AUTOCOMPLETION
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      local kind_icons = {
        Text = '󰉿', Method = 'm', Function = '󰊕', Constructor = '',
        Field = '', Variable = '󰆧', Class = '󰌗', Interface = '',
        Module = '', Property = '', Unit = '', Value = '󰎠',
        Enum = '', Keyword = '󰌋', Snippet = '', Color = '󰏘',
        File = '󰈙', Reference = '', Folder = '󰉋', EnumMember = '',
        Constant = '󰇽', Struct = '', Event = '', Operator = '󰆕',
        TypeParameter = '󰊄',
      }

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
          ['<Tab>'] = cmp.mapping(function(fallback)
             if cmp.visible() then
               cmp.select_next_item()
             elseif luasnip.expand_or_locally_jumpable() then
               luasnip.expand_or_jump()
             else
               fallback()
             end
           end, { 'i', 's' }),
           ['<S-Tab>'] = cmp.mapping(function(fallback)
             if cmp.visible() then
               cmp.select_prev_item()
             elseif luasnip.locally_jumpable(-1) then
               luasnip.jump(-1)
             else
               fallback()
             end
           end, { 'i', 's' }),
        },
        sources = {
          { name = 'lazydev', group_index = 0 },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              luasnip = '[Snippet]',
              buffer = '[Buffer]',
              path = '[Path]',
              lazydev = '[LazyDev]'
            })[entry.source.name]
            return vim_item
          end,
        },
      }

      -- Command line completion
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },

  -- NONE-LS (LINTING & FORMATTING)
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
      'jayp0521/mason-null-ls.nvim',
    },
    config = function()
      local null_ls = require 'null-ls'
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      require('mason-null-ls').setup {
        ensure_installed = {
          'prettier', 'stylua', 'eslint_d', 'shfmt', 'checkmake', 'rubocop',
        },
        automatic_installation = true,
      }

      local sources = {
        diagnostics.checkmake,
        formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
        formatting.stylua,
        formatting.shfmt.with { args = { '-i', '4' } },
        formatting.terraform_fmt,
        diagnostics.rubocop,
        formatting.rubocop,
      }

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        sources = sources,
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
          end
        end,
      }
    end,
  },

  -- GITSIGNS
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        current_line_blame = true,
      }
      vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', {})
      vim.keymap.set('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', {})
      vim.keymap.set('n', '<leader>gr', ':Gitsigns reset_hunk<CR>', {})
    end,
  },

  -- ALPHA DASHBOARD
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.startify'

      dashboard.section.header.val = {
        [[                                                    ]],
        [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
        [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
        [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
        [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
        [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
        [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
        [[                                                    ]],
      }

      alpha.setup(dashboard.opts)
    end,
  },

  -- INDENT BLANKLINE
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = { char = '▏' },
      scope = {
        show_start = false,
        show_end = false,
        show_exact_scope = false,
      },
      exclude = {
        filetypes = {
          'help', 'startify', 'dashboard', 'packer', 'neogitstatus', 'NvimTree', 'Trouble',
        },
      },
    },
  },

  -- COMMENT
  {
    'numToStr/Comment.nvim',
    opts = {},
    config = function()
      local comment_opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<C-_>', require('Comment.api').toggle.linewise.current, comment_opts)
      vim.keymap.set('n', '<C-c>', require('Comment.api').toggle.linewise.current, comment_opts)
      vim.keymap.set('n', '<C-/>', require('Comment.api').toggle.linewise.current, comment_opts)
      vim.keymap.set('v', '<C-_>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", comment_opts)
      vim.keymap.set('v', '<C-c>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", comment_opts)
      vim.keymap.set('v', '<C-/>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", comment_opts)
    end,
  },

  -- LAZYGIT
  {
    "kdheepak/lazygit.nvim",
   cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
   dependencies = { "nvim-lua/plenary.nvim" },
   keys = {
    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
   },
  },

  -- TODO COMMENTS
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- VIM-TMUX-NAVIGATOR
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<CR>', { noremap = true, silent = true })
    end,
  },

  -- AUTO-SAVE
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      condition = nil,
      write_all_buffers = false,
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 1000,
      debug = false,
    },
  },

  -- AUTO-SESSION
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      enabled = true,
      root_dir = vim.fn.stdpath "data" .. "/sessions/",
      auto_save = true,
      auto_restore = true,
      auto_create = true,
      suppressed_dirs = nil,
      allowed_dirs = nil,
      auto_restore_last_session = false,
      use_git_branch = false,
      lazy_support = true,
      bypass_save_filetypes = nil,
      close_unsupported_windows = true,
      args_allow_single_directory = true,
      args_allow_files_auto_save = false,
      continue_restore_on_error = true,
      show_auto_restore_notif = false,
      cwd_change_handling = false,
      lsp_stop_on_restore = false,
      log_level = "error",
      post_restore_cmds = {
        "silent! NeoTreeClose",
        function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.api.nvim_buf_get_name(buf)
            if name:match("neo%-tree") then
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
          end
        end,
      },
      restore_error_handler = function(err)
        if string.match(err, "Vim(fold):E16: Invalid range") then
          vim.notify("Ignoring fold error: " .. err, vim.log.levels.WARN)
          return true
        end
        vim.notify("Session restore error: " .. err, vim.log.levels.ERROR)
        return false
      end,
      session_lens = {
        load_on_setup = true,
        theme_conf = {},
        previewer = false,
        mappings = {
          delete_session = { "i", "<C-D>" },
          alternate_session = { "i", "<C-S>" },
          copy_session = { "i", "<C-Y>" },
        },
        session_control = {
          control_dir = vim.fn.stdpath "data" .. "/auto_session/",
          control_filename = "session_control.json",
        },
      },
    },
  },

  -- NVIM-UFO (FOLDING)
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local ufo = require("ufo")

      vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open folds selectively" })
      vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "Close folds selectively" })
      vim.keymap.set('n', 'zk', function()
        local winid = require( 'ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek Fold" })

      local function customize_fold_text()
        local line = vim.fn.getline(vim.v.foldstart)
        local num_lines = vim.v.foldend - vim.v.foldstart + 1
        return "  " .. line .. " 󰁂 " .. num_lines .. " lines "
      end

      ufo.setup({
        fold_virt_text_handler = customize_fold_text,
        provider_selector = function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end,
      })
    end,
  },

  -- FZF-LUA
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")

      fzf.setup({
        winopts = {
          height = 0.85, width = 0.85, row = 0.5, col = 0.5,
          preview = {
            default = "bat", border = "single", layout = "horizontal", horizontal = "right:58%",
            wrap = true, scrollbar = "float", scrolloff = 2,
          },
          wrap = true,
        },
        fzf_opts = {
          ["--layout"] = "reverse", ["--info"] = "inline", ["--wrap"] = "",
          ["--scrollbar"] = "▊", ["--border"] = "none", ["--padding"] = "0,0",
        },
        files = {
          fd_opts = "--type f --hidden --follow --exclude .git --exclude node_modules",
          prompt = "Files ❯ ",
        },
        grep = {
          rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git' -g '!node_modules'",
          prompt = "Grep ❯ ",
        },
      })

      vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find Buffers" })
      vim.keymap.set("n", "<leader>fo", fzf.oldfiles, { desc = "Find Recently Opened Files" })
      vim.keymap.set("n", "<leader>gg", fzf.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>gw", fzf.grep_cword, { desc = "Grep Word Under Cursor" })
      vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Find Help Tags" })
      vim.keymap.set("n", "<leader>/", fzf.blines, { desc = "Search Current Buffer Lines" })
      vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git Status Files" })
    end,
  },

  -- AVANTE AI ASSISTANT
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",
    opts = {
      provider = "gemini",
      gemini = {
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        model = "gemini-2.5-pro-preview-05-06",
        api_key_name = "GEMINI_API_KEY",
        timeout = 30000,
        temperature = 0,
        max_tokens = 8192,
      },
      behaviour = { auto_suggestions = false },
      selector = { provider = "fzf_lua" },
      web_search = {
        confirm_before_search = true,
        max_searches_per_session = 10,
        tavily = {
          api_key_name = "TAVILY_API_KEY",
          confirm_each_search = true,
        }
      },
    },
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = "dark"
      local avante = require('avante')
      avante.setup(opts)
      if not avante.windows then
        avante.windows = {}
      end

      require('dressing').setup({
        input = { border = "rounded", win_options = { winblend = 10 } },
        select = { backend = { "fzf_lua", "mini.pick", "builtin" } },
      })

      vim.keymap.set("n", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Avante: Ask" })
      vim.keymap.set("v", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "Avante: Edit" })
    end,
    dependencies = {
      { "stevearc/dressing.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "MunifTanjim/nui.nvim", version = "0.3.0" },
      {
        "nvim-treesitter/nvim-treesitter",
        config = function()
          require('nvim-treesitter.configs').setup({
            ensure_installed = { "lua", "python", "javascript", "markdown", "markdown_inline" },
            highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
            indent = { enable = true },
          })
        end,
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
          heading = {
            enabled = true,
            icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
            separator = true,
            separator_chars = "━",
            width = "full",
            highlight = "AvanteSeparator",
            sign = true,
            sign_hl = "AvanteSeparatorSign",
          },
          code = {
            enabled = true,
            style = "full",
            highlight = "CodeBlock",
            sign = true,
            left_pad = 2,
            right_pad = 2,
          },
          bold = { enabled = true, highlight = "Bold" },
          italic = { enabled = true, highlight = "Italic" },
          link = { enabled = true, highlight = "Underlined" },
        },
        ft = { "markdown", "Avante" },
      },
      { "echasnovski/mini.pick" },
      { "ibhagwan/fzf-lua" },
      { "hrsh7th/nvim-cmp" },
      { "nvim-tree/nvim-web-devicons" },
      {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
          vim.cmd('colorscheme catppuccin')
        end,
      },
    },
  },

  -- MARKDOWN PREVIEW
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.keymap.set("n", "<leader>md", "<Cmd>MarkdownPreviewToggle<CR>", {
        noremap = true, silent = true, desc = "Open Markdown Preview",
      })
    end,
  },

  -- UNDOTREE
  {
    "mbbill/undotree",
    opts = {},
    config = function()
      vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true, silent = true })
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },

  -- DIFFVIEW
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        diff_algorithm = "patience",
        show_untracked = true,
        view = {
          default = { layout = "diff2_horizontal", winbar_info = true },
          file_history = { layout = "diff2_vertical" },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = { flatten_dirs = true, folder_statuses = "only_folded" },
          win_config = { position = "left", width = 35 },
        },
      })
    end,
    keys = {
      { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History" },
      { "<leader>dr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh Diffview" },
    },
  },

  -- DROPBAR
  {
      "Bekaboo/dropbar.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
          bar = {
              enable = function(buf, win)
                  return vim.fn.win_gettype(win) == ""
                      and vim.bo[buf].buftype == ""
                      and vim.api.nvim_buf_get_name(buf) ~= ""
                      and vim.bo[buf].filetype ~= "toggleterm"
              end,
              sources = function()
                  local sources = require("dropbar.sources")
                  return { sources.path, sources.lsp }
              end,
              separator = " ➤ ",
          },
      },
      config = function(_, opts)
          require("dropbar").setup(opts)
          vim.keymap.set("n", "<leader>;", require("dropbar.api").pick, { desc = "Pick symbols in winbar" })
      end,
  },

  -- NEOSCROLL
  { "karb94/neoscroll.nvim", opts = {} },

  -- COPILOT CHAT
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {},
  },

  -- MISCELLANEOUS PLUGINS
  { 'tpope/vim-sleuth' },
  {
    'tpope/vim-fugitive',
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>gn", ":GBrowse<CR>", { desc = "Open line in remote PR" })
    end,
  },
  { 'tpope/vim-rhubarb' },
  { 'folke/which-key.nvim' },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true, opts = {} },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end },
  { "tpope/vim-bundler", ft = { "ruby", "eruby" } },
  { "tpope/vim-endwise", ft = { "ruby", "eruby" } },
  { "tpope/vim-surround" },
  { "echasnovski/mini.hipatterns", event = "BufReadPre", opts = {} },
  {
    'github/copilot.vim',
    config = function()
      vim.cmd('Copilot disable')
      local function toggle_copilot()
        local status = vim.fn['copilot#Enabled']()
        if status == 0 then
          vim.cmd('Copilot enable')
          print('Copilot enabled')
        else
          vim.cmd('Copilot disable')
          print('Copilot disabled')
        end
      end
      vim.api.nvim_create_user_command('ToggleCopilot', function() toggle_copilot() end, {})
      vim.api.nvim_set_keymap('n', 'ct', ':ToggleCopilot<CR>', { noremap = true, silent = true })
    end
  },
  { "LunarVim/bigfile.nvim", event = "BufReadPre", opts = { filesize = 2 }, config = function (_, opts) require('bigfile').setup(opts) end },

}, {})

-- =====================================================================
-- END OF CONFIGURATION
-- =====================================================================
-- vim: ts=2 sts=2 sw=2 et
EOF

# =====================================================================
# 5. MAKE SCRIPT EXECUTABLE AND FINISH
# =====================================================================
echo "🔧 Making Neovim executable..."
sudo chmod +x ~/.config/nvim/init.lua

echo ""
echo "✅ SUCCESS! Neovim Kickstart 2025 has been installed!"
echo ""
echo "🎯 Next steps:"
echo "   1. Run 'nvim' to start Neovim"
echo "   2. Wait for plugins to install automatically"
echo "   3. Restart Neovim after initial setup"
echo ""
echo "🔧 Key Features Installed:"
echo "   • 40+ plugins with complete configuration"
echo "   • LSP support with Mason auto-installer"
echo "   • File explorer (Neo-tree) - <leader>e"
echo "   • Fuzzy finder (FZF-lua) - <leader>ff"
echo "   • Git integration (Gitsigns, Lazygit, Diffview)"
echo "   • AI assistance (Avante, Copilot)"
echo "   • Auto-completion, formatting, and linting"
echo "   • Session management and much more!"
echo ""
echo "📚 Leader key is <Space> - try <leader>e to open file explorer!"
echo ""
echo "🎉 Happy coding!"
