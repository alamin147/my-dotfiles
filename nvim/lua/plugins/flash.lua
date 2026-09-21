return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  -- stylua: ignore
  keys = {
    { "s",  false, mode = { "n", "x", "o" } },
    { "S",  false, mode = { "n", "x", "o" } },
    { "zk", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
    { "Zk", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
