-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keep macro migration from the old config:
-- @c yanks the whole file.
vim.fn.setreg("c", "gg_vG$y")

local function open_pr_for_current_line()
  local line = vim.fn.line(".")
  local file = vim.fn.expand("%:p")
  local file_dir = vim.fn.expand("%:p:h")

  if file == "" then
    vim.notify("No file open", vim.log.levels.WARN)
    return
  end

  local blame_cmd = "git -C " .. vim.fn.shellescape(file_dir) .. " blame -L " .. line .. "," .. line .. " " .. vim.fn.shellescape(file) .. " | awk '{print $1}'"
  local commit_hash = vim.fn.system(blame_cmd):gsub("%s+", "")

  if commit_hash == "" or commit_hash == "0000000000000000000000000000000000000000" then
    vim.notify("No commit found for this line", vim.log.levels.WARN)
    return
  end

  local pr_cmd = "cd " .. vim.fn.shellescape(file_dir) .. " && gh api repos/{owner}/{repo}/commits/" .. commit_hash .. "/pulls --jq '.[0] | {number, title, url: .html_url}'"
  local pr_result = vim.fn.system(pr_cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("GitHub CLI error. Run `gh auth status`.", vim.log.levels.ERROR)
    return
  end

  local ok, pr_data = pcall(vim.fn.json_decode, pr_result)
  if not ok or not pr_data or not pr_data.url then
    vim.notify("No merged PR found for this line", vim.log.levels.WARN)
    return
  end

  vim.notify("Opening PR #" .. pr_data.number .. ": " .. pr_data.title, vim.log.levels.INFO)

  if vim.fn.has("mac") == 1 then
    vim.fn.system("open " .. vim.fn.shellescape(pr_data.url))
  else
    vim.fn.system("xdg-open " .. vim.fn.shellescape(pr_data.url))
  end
end

vim.keymap.set("n", "<leader>gpr", open_pr_for_current_line, { desc = "Open PR for current line" })

vim.keymap.set("n", "<C-q>", "<cmd>qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<C-c>", "gcc", { remap = true, silent = true, desc = "Toggle comment line" })
vim.keymap.set("x", "<C-c>", "gc", { remap = true, silent = true, desc = "Toggle comment selection" })

-- Buffer navigation and ordering
-- NOTE: mapping <Tab> in normal mode overrides Vim's default jump-forward (<C-i>) behavior.
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
