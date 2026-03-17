-- lua/plugins/gitsigns.lua
return {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = true, -- Toggle with <leader>gb

    -- This function runs when gitsigns attaches to a buffer.
    on_attach = function(bufnr)
      -- We no longer define 'gs' here.

      -- Navigation
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then return ']c' end
        -- Use require('gitsigns') directly inside the scheduled function
        vim.schedule(function() require('gitsigns').next_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = "Next Git Hunk" })

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then return '[c' end
        -- Use require('gitsigns') directly inside the scheduled function
        vim.schedule(function() require('gitsigns').prev_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = "Previous Git Hunk" })

      -- Actions
      -- It's good practice to get the module here too for consistency.
      local gs = require('gitsigns')
      vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = "Preview Git Hunk" })
      vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle Git Blame" })
      vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = "Reset Git Hunk" })
    end,
  },
}
