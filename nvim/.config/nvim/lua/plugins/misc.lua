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
    config = function()
      -- Keymap to open the remote PR/commit URL for the current line
      vim.keymap.set("n", "<leader>gn", ":GBrowse<CR>", { desc = "Open line in remote PR" })
    end,
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
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
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    version = "0.0.11",
    keys = {
      { "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
    },
    opts = {
      save_path = "~/Pictures",
      has_breadcrumbs = true,
      bg_theme = "bamboo",
    },
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
