-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("neo-tree").setup({
  filesystem = {
    follow_symlinks = false,
    use_libuv_file_watcher = true,
  },
})
