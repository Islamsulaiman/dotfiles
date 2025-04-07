return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" }, -- Load only for markdown files
    build = function() vim.fn["mkdp#util#install"]() end, -- Install dependencies
    config = function()
      -- Optional: Customize settings if you want
      vim.g.mkdp_auto_start = 0 -- Don't auto-start preview
      vim.g.mkdp_open_to_the_world = 0 -- Only local access

      -- Keymap for <leader>md
      vim.keymap.set("n", "<leader>md", "<Cmd>MarkdownPreviewToggle<CR>", {
        noremap = true,
        silent = true,
        desc = "Open Markdown Preview",
      })
    end,
  },
}
