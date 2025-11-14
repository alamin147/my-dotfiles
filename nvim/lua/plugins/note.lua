return {
  "gsuuon/note.nvim",
  opts = {
    spaces = { "~" },
    disable_ts = true, -- optional if you don't have treesitter
  },
  cmd = "Note", -- <--- must be uppercase
  ft = "note",
  keys = {
    {
      "<leader>tn",
      function()
        require("telescope.builtin").live_grep({
          cwd = require("note.api").current_note_root(),
        })
      end,
      mode = "n",
    },
  },
}
