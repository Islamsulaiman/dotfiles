return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy", -- Load only when needed
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function() return vim.fn.executable("make") == 1 end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg", "--color=never", "--no-heading", "--with-filename",
          "--line-number", "--column", "--smart-case",
          "--hidden", "--glob=!.git/*",
        },
        file_ignore_patterns = { "node_modules", ".git", ".venv", "*.log", "tmp/*", "coverage/*" },
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { width = 0.9, preview_width = 0.4 },
        },
        preview = {
          treesitter = false, -- Disable Treesitter in previews for speed
          filesize_limit = 1, -- Disable preview for files >1MB
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-l>"] = actions.select_default,
            ["<C-u>"] = false,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--follow", "--exclude", ".git" },
          hidden = true,
          follow = true,
          previewer = false, -- Disable preview for file searches
        },
        live_grep = {
          additional_args = function(_) return { "--hidden", "--glob", "!.git/*" } end,
        },
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
      },
    })

    -- Load extensions
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "live_grep_args")

    -- Keymaps
    local keymap = vim.keymap.set
    keymap("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles (fastest)" })
    keymap("n", "<leader>sg", function()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end, { desc = "[S]earch [G]rep with Args" })
    keymap("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch [W]ord" })
    keymap("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    keymap("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
    keymap("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })

    -- **Fuzzy search in current buffer**
    keymap("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false, -- No preview for buffer search
        layout_config = { width = 0.8, height = 0.7 },
      }))
    end, { desc = "[/] Fuzzy search in buffer" })
  end,
}
