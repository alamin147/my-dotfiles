-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
--
--
--

require("schreibmaschine").setup({
  keypress = {
    sound = "~/.config/nvim/sounds/key.wav",
    events = { "TextChangedI" }, -- typing
  },

  backspace = {
    sound = "~/.config/nvim/sounds/key.wav",
    keys = { "<BS>" },
  },

  enter = {
    sound = "~/.config/nvim/sounds/key.wav",
    keys = { "<CR>" },
  },
})
