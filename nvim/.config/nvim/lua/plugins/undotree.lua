return {
  "mbbill/undotree",
  commit = "b951b87b46c34356d44aa71886aecf9dd7f5788a",
  opts = {},
  config = function()
    local opts = { noremap = true, silent = true }
    -- Keybinding to toggle undotree
    vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", opts)
    -- Optional: Additional undotree settings
    vim.g.undotree_WindowLayout = 2 -- Change window layout (1-4)
    vim.g.undotree_ShortIndicators = 1 -- Use shorter indicators
    vim.g.undotree_SetFocusWhenToggle = 1 -- Focus undotree when toggled
  end,
}
