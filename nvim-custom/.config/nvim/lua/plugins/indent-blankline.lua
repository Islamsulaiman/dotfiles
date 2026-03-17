-- makes the colored lines for each scope.
return {
  'lukas-reineke/indent-blankline.nvim',
  commit = "005b56001b2cb30bfa61b7986bc50657816ba4ba",
  main = 'ibl',
  opts = {
    indent = {
      char = '▏',
    },
    scope = {
      show_start = false,
      show_end = false,
      show_exact_scope = false,
    },
    exclude = {
      filetypes = {
        'help',
        'startify',
        'dashboard',
        'packer',
        'neogitstatus',
        'NvimTree',
        'Trouble',
      },
    },
  },
}
