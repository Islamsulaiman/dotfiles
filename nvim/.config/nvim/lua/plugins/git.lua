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
      {
        "<leader>gH",
        function()
          if vim.fn.executable("gh") == 0 then
            vim.notify("`gh` CLI is not installed", vim.log.levels.ERROR)
            return
          end
          Snacks.terminal("gh dash", { cwd = LazyVim.root.git() })
        end,
        desc = "Open GitHub Dash",
      },
    },
  },
}
