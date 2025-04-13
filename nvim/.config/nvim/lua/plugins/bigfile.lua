return {
  "LunarVim/bigfile.nvim",
  commit = "33eb067e3d7029ac77e081cfe7c45361887a311a",
  event = "BufReadPre",
  otps = {
    filesize = 2
  },
  config = function (_, opts)
    require('bigfile').setup(opts)
  end
}
