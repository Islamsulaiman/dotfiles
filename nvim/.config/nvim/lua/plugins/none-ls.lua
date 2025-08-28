return {
  'nvimtools/none-ls.nvim',
  version = "*", -- Use the latest stable release instead of a pinned commit
  dependencies = {
    -- Define cSpell.nvim directly as a dependency table
    {
      "davidmh/cspell.nvim",
      config = function() end, -- Prevent lazy.nvim from calling a non-existent .setup()
    },
  },
  config = function()
    local nls = require('null-ls')
    local cspell = require('cspell')
    local formatting = nls.builtins.formatting
    local diagnostics = nls.builtins.diagnostics

    local sources = {
      -- cSpell (for code-aware spell checking)
      cspell.diagnostics.with({
        diagnostics_postprocess = function(diagnostic)
          diagnostic.severity = vim.diagnostic.severity.HINT
        end,
      }),
      cspell.code_actions,

      -- Your original sources
      diagnostics.checkmake,
      formatting.prettier.with({ filetypes = { 'html', 'json', 'yaml', 'markdown' } }),
      formatting.stylua,
      formatting.shfmt.with({ args = { '-i', '4' } }),
      formatting.terraform_fmt,
      diagnostics.rubocop,
      formatting.rubocop,
    }

    nls.setup({
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method('textDocument/formatting') then
          -- Your format-on-save logic can go here
        end
      end,
    })
  end,
}
