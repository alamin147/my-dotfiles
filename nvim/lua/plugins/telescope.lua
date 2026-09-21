local function launch_root()
  return vim.g.original_cwd or vim.fn.getcwd()
end

local function search_all_files()
  require("telescope.builtin").live_grep({
    cwd = launch_root(),
    prompt_title = "Search All Files",
  })
end

local function show_keybinds()
  require("config.keybind-help").show()
end

return {
  -- Highlight colors
  {
    "nvim-mini/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim", -- ✅ fixed here
    priority = 1000,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    init = function()
      vim.api.nvim_create_user_command("Keybinds", show_keybinds, {
        desc = "Search custom, plugin, LazyVim, and Neovim default keybinds",
      })
    end,
    keys = {
      {
        "<leader>hk",
        show_keybinds,
        desc = "Help: Search all custom and default keybinds",
      },
      {
        ";f",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            cwd = launch_root(),
            no_ignore = true, -- Don't respect .gitignore
            hidden = true,
            file_ignore_patterns = {}, -- Clear any ignore patterns
          })
        end,
        desc = "Find Files (Launch Root, Including Hidden/Ignored)",
      },
      {
        ";r",
        search_all_files,
        desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
      },
      {
        ";;",
        function()
          local builtin = require("telescope.builtin")
          builtin.resume()
        end,
        desc = "Resume the previous telescope picker",
      },
      {
        ";e",
        function()
          local builtin = require("telescope.builtin")
          builtin.diagnostics()
        end,
        desc = "Diagnostics (Telescope)",
      },
      {
        ";q",
        function()
          vim.diagnostic.setqflist()
          vim.cmd.copen()
        end,
        desc = "Diagnostics to Quickfix",
      },
      {
        ";s",
        function()
          local builtin = require("telescope.builtin")
          builtin.treesitter()
        end,
        desc = "Treesitter Symbols",
      },
      {
        ";d",
        function()
          local builtin = require("telescope.builtin")
          local current_dir = vim.fn.expand("%:p:h")
          builtin.find_files({
            prompt_title = "Find Files in Current Directory",
            cwd = current_dir,
            hidden = true,
            no_ignore = false,
          })
        end,
        desc = "Find Files Under Current File Directory",
      },
      {
        ";w",
        function()
          local builtin = require("telescope.builtin")
          builtin.grep_string()
        end,
        desc = "Grep Word Under Cursor",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      -- Load file_browser actions directly from the extension module to avoid order issues
      local fb_actions = require("telescope._extensions.file_browser.actions")

      -- Ensure opts and its sub-tables exist before deep-extending
      opts = opts or {}

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        follow_symlinks = true,
        mappings = {
          n = {},
        },
      })
      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
        -- Make find files grep preview wider
        find_files = {
          layout_config = {
            preview_width = 0.55,
          },
        },
        -- Make grep preview a bit wider
        live_grep = {
          layout_config = {
            preview_width = 0.5,
          },
        },
        grep_string = {
          layout_config = {
            preview_width = 0.55,
          },
        },
        -- Make current buffer fuzzy preview wider too
        current_buffer_fuzzy_find = {
          layout_config = {
            preview_width = 0.5,
          },
        },
      })
      opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
        file_browser = {
          theme = "dropdown",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            ["n"] = {
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
            },
          },
        },
      })
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
    end,
  },
}
