-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autosave_group = vim.api.nvim_create_augroup("custom_autosave", { clear = true })

local function should_autosave(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end
  if not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly then
    return false
  end
  if vim.fn.expand("%") == "" then
    return false
  end
  return vim.bo[bufnr].modified
end

vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "TextChanged" }, {
  group = autosave_group,
  callback = function(args)
    if should_autosave(args.buf) then
      vim.cmd("silent! write")
    end
  end,
  desc = "Auto save on mode, buffer, and normal mode edits",
})
