return {
  'akinsho/bufferline.nvim',
  commit = "655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3",
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    -- Function to check if current buffer file is untracked
    local function is_buffer_untracked(buf_id)
      local filepath = vim.api.nvim_buf_get_name(buf_id)
      if not filepath or filepath == '' then return false end
      
      -- Check if we're in a git repo
      local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
      local result = handle:read("*a")
      handle:close()
      
      if not result or result:match("true") == nil then
        return false
      end
      
      -- Check if file is tracked
      local handle2 = io.popen("git ls-files " .. vim.fn.shellescape(filepath) .. " 2>/dev/null")
      local tracked = handle2:read("*a")
      handle2:close()
      
      return tracked == "" and vim.fn.filereadable(filepath) == 1
    end

    require('bufferline').setup {
      options = {
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
        themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
        numbers = 'none',
        close_command = 'Bdelete! %d', -- can be a string | function, see "Mouse actions"
        buffer_close_icon = '✗',
        close_icon = '✗',
        path_components = 1, -- Show only the file name without the directory
        modified_icon = '●',
        show_buffer_close_icons = true,

        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 30,
        max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
        tab_size = 21,
        diagnostics = false,
        diagnostics_update_in_insert = false,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = { '│', '│' }, -- | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        show_tab_indicators = false,
        indicator = {
          -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'none', -- Options: 'icon', 'underline', 'none'
        },
        icon_pinned = '󰐃',
        minimum_padding = 1,
        maximum_padding = 5,
        maximum_length = 15,
        sort_by = 'insert_at_end',
        name_formatter = function(buf)
          -- Get the filename without path
          local filename = vim.fn.fnamemodify(buf.name, ':t')
          
          -- Check if this buffer is untracked and add dot marker
          if is_buffer_untracked(buf.bufnr) then
            return filename .. ' ●'
          end
          
          return filename
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



        -- separator_selected = {},
        -- tab_selected = {},
        -- background = {},
        -- indicator_selected = {},
        -- fill = {},
      },
    }

    -- Simple approach: override buffer highlighting for current buffer if untracked
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
      callback = function()
        local current_buf = vim.api.nvim_get_current_buf()
        if is_buffer_untracked(current_buf) then
          -- Set orange color for the active/selected buffer
          vim.api.nvim_set_hl(0, 'BufferLineBufferSelected', { fg = '#ff9e64', bold = true })
          vim.api.nvim_set_hl(0, 'BufferLineTabSelected', { fg = '#ff9e64', bold = true })
        else
          -- Reset to normal colors
          vim.api.nvim_set_hl(0, 'BufferLineBufferSelected', {})
          vim.api.nvim_set_hl(0, 'BufferLineTabSelected', {})
        end
        
        -- Trigger bufferline refresh
        vim.schedule(function()
          pcall(function()
            require('bufferline').refresh()
          end)
        end)
      end,
    })
  end,
}
