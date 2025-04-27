return {
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
        model = "gemini-1.5-pro",
        api_key_name = "GEMINI_API_KEY",
        timeout = 30000,
        temperature = 0,
        max_tokens = 8192,
      },
      behaviour = { auto_suggestions = false },
      selector = { provider = "fzf_lua" },
    },
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = "dark"

      -- Workaround for windows nil error
      local avante = require('avante')
      avante.setup(opts)
      if not avante.windows then
        avante.windows = {}
      end

      require('dressing').setup({
        input = { border = "rounded", win_options = { winblend = 10 } },
        select = { backend = { "fzf_lua", "mini.pick", "builtin" } },
      })
      require('nvim-web-devicons').setup({
        override = {
          Avante = { icon = "🤖", color = "#ff9900", name = "Avante" },
        },
      })
      -- Highlight groups
      vim.api.nvim_set_hl(0, "Bold", { bold = true, fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "Italic", { italic = true, fg = "#cccccc" })
      vim.api.nvim_set_hl(0, "Underlined", { underline = true, fg = "#88ccff" })
      vim.api.nvim_set_hl(0, "AvanteSeparator", { fg = "#61afef", bold = true })
      vim.api.nvim_set_hl(0, "AvanteSeparatorSign", { fg = "#ff9900", bold = true })
      -- Define custom sign for separators
      vim.fn.sign_define("AvanteSeparator", { text = "◆", texthl = "AvanteSeparatorSign", linehl = "AvanteSeparator" })
      -- Keybindings
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
}
