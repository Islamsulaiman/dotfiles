return {
  "LunarVim/bigfile.nvim",
  event = "BufReadPre",
  otps = {
    filesize = 2
  },
  config = function (_, opts)
    require('bigfile').setup(opts)
  end
}
