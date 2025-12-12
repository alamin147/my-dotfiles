-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Fix for symlinked directories - use the path as-is, don't resolve symlinks
vim.opt.autochdir = false

-- Get the REAL original cwd from shell's PWD (not resolved by nvim)
local original_cwd = vim.env.PWD or vim.fn.getcwd()

-- Store it globally so other plugins can use it
vim.g.original_cwd = original_cwd

-- Force nvim to use the original path
vim.api.nvim_set_current_dir(original_cwd)

-- Neo-tree width persistence
local neo_tree_width_file = vim.fn.stdpath("data") .. "/neo_tree_width"
local function get_saved_width()
  local file = io.open(neo_tree_width_file, "r")
  if file then
    local width = tonumber(file:read("*a"))
    file:close()
    return width or 35
  end
  return 35
end

local function save_width(width)
  local file = io.open(neo_tree_width_file, "w")
  if file then
    file:write(tostring(width))
    file:close()
  end
end

-- Save neo-tree width when window is resized
vim.api.nvim_create_autocmd("WinResized", {
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      if ft == "neo-tree" then
        local width = vim.api.nvim_win_get_width(win)
        if width > 10 then
          save_width(width)
        end
      end
    end
  end,
})

require("neo-tree").setup({
  filesystem = {
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    hijack_netrw_behavior = "open_current",
    use_libuv_file_watcher = true,
    follow_symlinks = false,
    -- Prevent neotree from changing to the real path of symlinks
    bind_to_cwd = true,
    cwd_target = {
      sidebar = "tab",
      current = "tab",
    },
    -- Show hidden files
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
      hide_by_name = {
        -- You can add files to hide here if needed
      },
      never_show = {
        ".git",
      },
    },
    -- Use window cwd not resolved path
    group_empty_dirs = false,
  },
  window = {
    position = "left",
    width = get_saved_width(),
    mappings = {
      -- Prevent following symlinks when opening
      ["<cr>"] = "open",
      ["o"] = "open",
      ["l"] = "open",
      -- Toggle hidden files with H
      ["H"] = "toggle_hidden",
    },
  },
  -- Remember window width
  use_popups_for_input = false,
  resize_timer_interval = -1,
})
