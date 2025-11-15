return {
  -- 🎮 Fun Plugins
  {
    "alec-gibson/nvim-tetris",
    cmd = "Tetris",
  },
  -- make it rain fun animation
  {
    "Eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
    config = function()
      vim.api.nvim_create_user_command("Rain", function()
        vim.cmd("CellularAutomaton make_it_rain")
      end, {})
    end,
  },
}
