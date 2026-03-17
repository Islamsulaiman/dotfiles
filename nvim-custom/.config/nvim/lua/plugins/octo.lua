-- Plugin to review PRs from neovim

return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'ibhagwan/fzf-lua',
    -- OR 'folke/snacks.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function ()
    require("octo").setup({
      picker = "fzf-lua",
    })
  end,
  keys = {
    -- PR Actions: <leader>op...
    { "<leader>opl", "<cmd>Octo pr list<cr>", desc = "Octo PR List" },
    { "<leader>opd", "<cmd>Octo pr diff<cr>", desc = "Octo PR Diff" },
    { "<leader>opf", "<cmd>Octo pr files<cr>", desc = "Octo PR Files" },
    { "<leader>opc", "<cmd>Octo pr commits<cr>", desc = "Octo PR Commits" },
    { "<leader>opo", "<cmd>Octo pr checkout<cr>", desc = "Octo PR Checkout" },
    { "<leader>opm", "<cmd>Octo pr merge<cr>", desc = "Octo PR Merge" },

    -- Issue Actions: <leader>oi...
    { "<leader>oil", "<cmd>Octo issue list<cr>", desc = "Octo Issue List" },

    -- Review Actions: <leader>or...
    { "<leader>ors", "<cmd>Octo review start<cr>", desc = "Octo Review Start" },
    { "<leader>orS", "<cmd>Octo review submit<cr>", desc = "Octo Review Submit" },
    { "<leader>oca", "<cmd>Octo comment add<cr>", desc = "Octo Review Add Comment" },

    -- General Octo Actions: <leader>o...
    { "<leader>orl", "<cmd>Octo reload<cr>", desc = "Octo Reload" },

    -- Comment Navigation (standard Vim-style bindings)
    { "<leader>]", "<cmd>Octo next_comment<cr>", desc = "Octo Next Comment", buffer = true },
    { "<leader>[", "<cmd>Octo prev_comment<cr>", desc = "Octo Previous Comment", buffer = true },
  }
}
