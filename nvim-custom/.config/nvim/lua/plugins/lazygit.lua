return {
  "kdheepak/lazygit.nvim",
  commit = "b9eae3badab982e71abab96d3ee1d258f0c07961",
 cmd = {
  "LazyGit",
  "LazyGitConfig",
  "LazyGitCurrentFile",
  "LazyGitFilter",
  "LazyGitFilterCurrentFile",
 },
 -- optional for floating window border decoration
 dependencies = {
  "nvim-lua/plenary.nvim",
 },
 -- setting the keybinding for LazyGit with 'keys' is recommended in
 -- order to load the plugin when the command is run for the first time
 keys = {
  { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
 },
}
