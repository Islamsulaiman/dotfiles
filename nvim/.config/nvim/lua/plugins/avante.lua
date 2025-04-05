return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy", -- Load the plugin lazily when needed
    lazy = false,       -- Ensure it’s loaded immediately (optional, adjust as needed)
    version = false,    -- Use the latest version instead of pinning
    build = "make",     -- Build the plugin (required for some setups)
    opts = {
      provider = "gemini", -- Set Gemini as the AI provider
      gemini = {
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models", -- Gemini API endpoint
        model = "gemini-1.5-flash", -- Specify the Gemini model (adjust based on available models)
        api_key_name = "GEMINI_API_KEY", -- Environment variable for the API key
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0, -- Controls randomness (0 = deterministic)
        max_tokens = 8192, -- Maximum tokens for response
      },
      behaviour = {
        auto_suggestions = false, -- Disable auto-suggestions if not needed
      },
    },
    dependencies = {
      "stevearc/dressing.nvim", -- For better UI elements
      "nvim-lua/plenary.nvim",  -- Utility functions
      "MunifTanjim/nui.nvim",   -- UI components
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      -- Optional: For better markdown rendering
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    },
  },
}
