return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = my_lualine_theme,
      },
      sections = {
        lualine_b = {
          "branch",
          {
            "diff",
            colored = true,
            symbols = { added = "+", modified = "~", removed = "-" }, -- Git diff symbols with icons
          },
          -- Git status function removed - it was causing cursor blinking/flickering
          -- The git diff component above already shows git information
          "diagnostics",
        },
        lualine_c = {
          {
            function()
              local filepath = vim.fn.expand("%:p") -- Full path
              local cwd = vim.fn.getcwd() -- Where you opened nvim
              -- Make path relative to cwd
              local relative = filepath:gsub("^" .. vim.pesc(cwd) .. "/", "")

              -- Split path and take last N parts (adjust the number below)
              local parts = vim.split(relative, "/")
              local depth = 4 -- Number of folders to show (change this number)

              if #parts > depth then
                local shown = {}
                for i = #parts - depth + 1, #parts do
                  table.insert(shown, parts[i])
                end
                return table.concat(shown, "/")
              end

              return relative
            end,
            icon = "",
            color = { gui = "bold" },
          },
        },
        lualine_y = {
          { "fileformat", symbols = { unix = " " } },
          { "progress" },
        },
        lualine_x = {
          -- {
          --   lazy_status.updates,
          --   cond = lazy_status.has_updates,
          --   color = { fg = "#ff9e64" },
          -- },
          -- { "encoding" },
          { "filetype" },
        },
      },
    })
  end,
}
