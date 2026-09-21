local width_file = vim.fn.stdpath("data") .. "/neo_tree_width"

local function launch_root()
  return vim.g.original_cwd or (vim.uv or vim.loop).cwd()
end

local function toggle_explorer()
  require("neo-tree.command").execute({
    source = "filesystem",
    position = "left",
    toggle = true,
    dir = launch_root(),
  })
end

local function saved_width()
  local ok, lines = pcall(vim.fn.readfile, width_file, "", 1)
  local width = ok and tonumber(lines[1]) or nil
  return width and math.max(24, math.min(width, 60)) or 35
end

local function remember_width()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "neo-tree" then
      local width = vim.api.nvim_win_get_width(win)
      if width >= 24 and width <= 60 then
        pcall(vim.fn.writefile, { tostring(width) }, width_file)
      end
    end
  end
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    init = function()
      vim.api.nvim_create_autocmd("WinResized", {
        group = vim.api.nvim_create_augroup("UserNeoTreeWidth", { clear = true }),
        callback = remember_width,
      })
    end,
    opts = function(_, opts)
      opts.use_popups_for_input = false
      opts.resize_timer_interval = -1

      opts.filesystem = vim.tbl_deep_extend("force", opts.filesystem or {}, {
        -- Keep the workspace root where Neovim was launched. LSP roots for a
        -- nested client/server package must not replace the explorer root.
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        follow_symlinks = false,
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          never_show = { ".git" },
        },
      })

      opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
        position = "left",
        width = saved_width(),
        mappings = {
          ["<cr>"] = "open",
          o = "open",
          l = "open",
          H = "toggle_hidden",
        },
      })
    end,
    keys = {
      { "<leader>e", toggle_explorer, desc = "Toggle Explorer (Launch Root)" },
    },
  },
}
