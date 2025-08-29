-- Plugin to move in the buffers quickly

-- Plugin to move in the buffers quickly

return {
  "folke/flash.nvim", -- The plugin name was missing
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  -- The format for keys is { "key", function, opts }
  -- The function must be the second item.
  keys = {
    { "s", function() require("flash").jump() end,       mode = { "n", "x", "o" }, desc = "Flash" },
    { "S", function() require("flash").treesitter() end,  mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
    { "r", function() require("flash").remote() end,      mode = "o",               desc = "Remote Flash" },
    { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Treesitter Search" },
    { "<c-s>", function() require("flash").toggle() end, mode = { "c" }, desc = "Toggle Flash Search" },
  },
}
