return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    enabled = true,
    root_dir = vim.fn.stdpath "data" .. "/sessions/",
    auto_save = true,
    auto_restore = true,
    auto_create = true,
    suppressed_dirs = nil,
    allowed_dirs = nil,
    auto_restore_last_session = false,
    use_git_branch = false,
    lazy_support = true,
    bypass_save_filetypes = nil,
    close_unsupported_windows = true,
    args_allow_single_directory = true,
    args_allow_files_auto_save = false,
    continue_restore_on_error = true,
    show_auto_restore_notif = false,
    cwd_change_handling = false,
    lsp_stop_on_restore = false,
    log_level = "error",

    -- Clean up neo-tree buffers after restore, no NeoTreeShow
    post_restore_cmds = {
      "silent! NeoTreeClose",
      function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(buf)
          if name:match("neo%-tree") then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
      end,
    },

    session_lens = {
      load_on_setup = true,
      theme_conf = {},
      previewer = false,
      mappings = {
        delete_session = { "i", "<C-D>" },
        alternate_session = { "i", "<C-S>" },
        copy_session = { "i", "<C-Y>" },
      },
      session_control = {
        control_dir = vim.fn.stdpath "data" .. "/auto_session/",
        control_filename = "session_control.json",
      },
    },
  }
}
