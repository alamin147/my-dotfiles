-- Base46's configuration contract without the NvChad distribution/UI.
-- Extra integrations use the same palette -> highlights -> bytecode pipeline.
return {
  base46 = {
    theme = "onedark",
    transparency = false,
    hl_add = {},
    hl_override = {},
    changed_themes = {},
    excluded = { "cmp", "nvcheatsheet", "nvimtree", "statusline", "tbline" },
    integrations = {
      "bufferline",
      "dap",
      "flash",
      "gitsigns",
      "semantic_tokens",
      "trouble",
      "todo",
      "notify",
      "render-markdown",
      "desktop",
    },
    integrations_dir = "config.theme-integrations",
  },
  ui = {
    telescope = { style = "borderless" },
    cmp = { style = "default" },
    statusline = { theme = "default" }, -- referenced by poimandres' palette polish
  },
}
