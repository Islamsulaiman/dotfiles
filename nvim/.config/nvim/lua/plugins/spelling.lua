return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters = opts.linters or {}

      local global_linters = opts.linters_by_ft["*"] or {}
      if not vim.tbl_contains(global_linters, "cspell") then
        table.insert(global_linters, "cspell")
      end
      opts.linters_by_ft["*"] = global_linters

      local lint = require("lint")
      local util = require("lint.util")
      local base = lint.linters.cspell

      if base then
        local wrapped = util.wrap(base, function(diagnostic)
          diagnostic.severity = vim.diagnostic.severity.HINT
          return diagnostic
        end)

        wrapped.condition = function()
          return vim.fn.executable("cspell") == 1
        end

        opts.linters.cspell = wrapped
      end
    end,
  },
}
