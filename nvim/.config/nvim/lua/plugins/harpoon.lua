-- lua/plugins.lua (example)
return {
  {
    "ThePrimeagen/harpoon",
    lazy = true, -- load on demand
    keys = {
      { "<leader>ha", ":lua require('harpoon.mark').add_file()<CR>", desc = "Add file to Harpoon" },
      { "<leader>hh", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Harpoon menu" },
      { "<leader>hn", ":lua require('harpoon.ui').nav_next()<CR>", desc = "Next Harpoon file" },
      { "<leader>hp", ":lua require('harpoon.ui').nav_prev()<CR>", desc = "Previous Harpoon file" },
    },
  },
}
