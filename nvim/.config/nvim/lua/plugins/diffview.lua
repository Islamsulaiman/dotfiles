return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true,
      diff_algorithm = "patience",
      show_untracked = true,
      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_vertical",
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
        },
      },
    })
  end,
  keys = {
    {
      "<leader>do",
      function()
        -- Toggle main Diffview
        local is_open = false
        for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
          local tab_wins = vim.api.nvim_tabpage_list_wins(tabpage)
          for _, win in ipairs(tab_wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "DiffviewFiles" or vim.bo[buf].filetype == "DiffviewFileHistory" then
              is_open = true
              break
            end
          end
          if is_open then break end
        end

        if is_open then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "Toggle Diffview",
    },
    {
      "<leader>dh",
      function()
        -- Toggle DiffviewFileHistory
        local is_history_open = false
        for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
          local tab_wins = vim.api.nvim_tabpage_list_wins(tabpage)
          for _, win in ipairs(tab_wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "DiffviewFileHistory" then
              is_history_open = true
              break
            end
          end
          if is_history_open then break end
        end

        if is_history_open then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewFileHistory")
        end
      end,
      desc = "Toggle file history",
    },
    {
      "<leader>dr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh Diffview",
    },
  },
}
