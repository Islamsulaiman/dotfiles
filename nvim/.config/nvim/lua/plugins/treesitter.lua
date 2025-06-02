return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  commit = "0e21ee8df6235511c02bab4a5b391d18e165a58d",
  build = ':TSUpdate',
  { 'airblade/vim-rooter' },
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      'lua',
      'python',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'regex',
      'terraform',
      'sql',
      'dockerfile',
      'toml',
      'json',
      'java',
      'gitignore',
      'graphql',
      'yaml',
      'make',
      'cmake',
      'markdown',
      'markdown_inline',
      'bash',
      'tsx',
      'css',
      'html',
      'ruby',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    -- Keep Ruby disabled for treesitter indent as originally intended
    indent = { enable = true, disable = { 'ruby' } },
  },

  -- To prevent dot `.` from indenting the code due to a conflict
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
    -- Fix Ruby dot key indentation issue
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "ruby",
      callback = function()
        -- Remove the dot from indentkeys to prevent auto-indentation on dot
        vim.bo.indentkeys = vim.bo.indentkeys:gsub(",?%.","")
        -- Use Vim's built-in Ruby indentation instead of treesitter
        vim.bo.indentexpr = "GetRubyIndent()"
      end,
    })
  end,
}
