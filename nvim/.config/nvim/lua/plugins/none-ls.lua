return {
  'nvimtools/none-ls.nvim',
  commit = "8d99472fcccffd73d7501e54e9018bab5cb0c4ad",
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- Formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier', -- ts/js formatter
        'stylua', -- lua formatter
        'eslint_d', -- ts/js linter
        'shfmt', -- Shell formatter
        'checkmake', -- linter for Makefiles
        'rubocop', -- linter for Rails files
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
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here

      -- on_attach method is a method that runs rigth before a user close a buffer, so anything we want to run like a callback.
      on_attach = function(client, bufnr)  -- this line checks for the

        -- the follwoing code block is for trigring autocomplete for the linters like rubocop.
        --
        if client.supports_method 'textDocument/formatting' then
        --   vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        --   vim.api.nvim_create_autocmd('BufWritePre', {
        --     group = augroup,
        --     buffer = bufnr,
        --     callback = function()
        --       vim.lsp.buf.format { async = false }
        --     end,
        --   })
        end
      end,
    }
  end,
}
