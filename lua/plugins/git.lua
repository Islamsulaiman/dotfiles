return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>lg", function() Snacks.lazygit() end, desc = "Open LazyGit" },
    },
  },
}
