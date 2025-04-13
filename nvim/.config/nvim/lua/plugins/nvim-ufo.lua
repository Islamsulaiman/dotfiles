-- This package is for enable folding code blocks efficintaly
return {
  "kevinhwang91/nvim-ufo",
  commit = "a026364df62e88037b26d37c9f14c17c006fd577",
  dependencies = {
    "kevinhwang91/promise-async"
  },
  event = "VeryLazy",
  config = function()
    vim.o.foldcolumn = "1" -- Show fold column
    vim.o.foldlevel = 99   -- Start unfolded
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local ufo = require("ufo")

    -- Keybindings
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

    -- Define a fold handler
    local function customize_fold_text()
      local line = vim.fn.getline(vim.v.foldstart)
      local num_lines = vim.v.foldend - vim.v.foldstart + 1
      return "  " .. line .. " 󰁂 " .. num_lines .. " lines "
    end

    -- Setup nvim-ufo
    ufo.setup({
      fold_virt_text_handler = customize_fold_text,
      provider_selector = function(bufnr, filetype, buftype)
        return { "lsp", "indent" }
      end,
    })
  end,
}
