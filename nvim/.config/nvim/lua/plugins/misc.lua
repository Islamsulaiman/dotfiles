-- Standalone plugins with less than 10 lines of config go here
return {
  {
    -- Tmux & split window navigation
    'christoomey/vim-tmux-navigator',
  },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
    event = "VeryLazy",
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
    event = "VeryLazy",
    config = function()
      local which_key = require("which-key")
      
      which_key.setup({
        preset = "modern",
        delay = function(ctx)
          return ctx.plugin and 0 or 500  -- PERFORMANCE: Increased delay from 200ms to 500ms
        end,
        -- Performance optimizations
        triggers = {
          { "<leader>", mode = { "n", "v" } },
        },
        sort = { "local", "order", "group", "alphanum", "mod" },
      })
      
      -- Register group names for leader key combinations
      which_key.add({
        -- { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code action, and rename files" },
        { "<leader>d", group = "Debug/Diagnostics" },
        { "<leader>f", group = "Find/File" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Help/Harpoon" },
        { "<leader>i", group = "Insert" },
        { "<leader>l", group = "LSP/Linting" },
        { "<leader>r", group = "Replace in buffer" },
        { "<leader>s", group = "Search/Session" },
        { "<leader>t", group = "Toggle Hints and Diagnostics" },
        { "<leader>u", group = "UI/Utils" },
        { "<leader>w", group = "Workspace" },
        { "<leader>x", group = "Close/Delete" },
        { "<leader>op", group = "Octo PR" },
        { "<leader>oi", group = "Octo issue" },
        { "<leader>or", group = "Octo review/reload" },
        { "<leader>oc", group = "Octo comment" },
      })
    end,
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    "tpope/vim-bundler", ft = { "ruby", "eruby" }
  },
  {
    "tpope/vim-endwise", ft = { "ruby", "eruby" }
  },
  {
    "tpope/vim-surround" -- to change wrapper characters
  },
  {
-- Hihglight colors
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
}
