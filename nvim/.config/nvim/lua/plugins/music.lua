return {
  {
    "dadav/schreibmaschine.nvim",
    config = function()
      require("schreibmaschine").setup({
        -- configuration options: map specific keys/events to sound files
      })
    end,
  },
}
