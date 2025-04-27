-- This package is for add the presistant breadcrumb at the top of the 
return {
  'nvim-treesitter/nvim-treesitter-context',
  commit = "439789a9a8df9639ecd749bb3286b77117024a6f",
  opts = {
        enable = true,
    -- max_lines = 3, -- Limit the number of context lines shown
    trim_scope = 'outer', -- Always display the outermost scope
    patterns = {
      default = {
        'class',       -- Classes
        'function',    -- Functions
        'method',      -- Methods
        'for',         -- For loops
        'while',       -- While loops
        'if',          -- If statements
        'switch',      -- Switch statements
        'case',        -- Case statements
      },
      lua = {
        'function',
        'if_statement',
        'for_statement',
      },
      ruby = {
        'module',      -- Ruby modules
        'class',       -- Ruby classes
        'method',      -- Ruby methods
        'do_block',    -- Ruby blocks
        'if',          -- If statements
        'method_call',        -- for method calls also
        exclude_patterns = { 'comment' }, -- Exclude comments for Ruby files
      },
      rails = {
        'class',       -- Rails models, controllers, etc.
        'method',      -- Controller actions, helpers, etc.
        'do_block',    -- Blocks in Rails code
        exclude_patterns = { 'comment' }, -- Exclude comments for Ruby files
      },
    },
    exclude_patterns = {
      'comment',        -- General comment node
      'line_comment',   -- Specific line comment node
      'block_comment',  -- Specific block comment node
      -- multiline_threshold = 1, -- Show context for single-line nodes
    }, -- Exclude comments globally
  },
  config = function(_, opts)
    require('treesitter-context').setup(opts)
  end,
}

