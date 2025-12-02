return {
  --discord presence
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    config = function()
      require("presence").setup({
        neovim_image_text = "Neovim",
        main_image = "file",
        enable_line_number = false,
      })
    end,
  },
  --harpoon
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
  -- Tetris
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
  --which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  --noice
  -- {
  --   "folke/noice.nvim",
  --   opts = function(_, opts)
  --     table.insert(opts.routes, {
  --       filter = {
  --         event = "notify",
  --         find = "No information available",
  --       },
  --       opts = { skip = true },
  --     })
  --     local focused = true
  --     vim.api.nvim_create_autocmd("FocusGained", {
  --       callback = function()
  --         focused = true
  --       end,
  --     })
  --     vim.api.nvim_create_autocmd("FocusLost", {
  --       callback = function()
  --         focused = false
  --       end,
  --     })
  --     table.insert(opts.routes, 1, {
  --       filter = {
  --         cond = function()
  --           return not focused
  --         end,
  --       },
  --       view = "notify_send",
  --       opts = {
  --         stop = false,
  --         fps = 30,
  --       },
  --     })
  --
  --     opts.commands = {
  --       all = {
  --         -- options for the message history that you get with `:Noice`
  --         view = "split",
  --         opts = { enter = true, format = "details" },
  --         filter = {},
  --       },
  --     }
  --     opts.presets.lsp_doc_border = true
  --   end,
  --   config = function(_, opts)
  --     require("noice").setup(opts)
  --
  --     vim.defer_fn(function()
  --       vim.notify("      Cat will take the world 😼", vim.log.levels.INFO, {
  --         title = "Welcome back, Alamin!",
  --       })
  --     end, 1000)
  --   end,
  -- },
  {
    "CRAG666/code_runner.nvim",
    config = function()
      require("code_runner").setup({
        filetype = {
          java = {
            "cd $dir &&",
            "javac $fileName &&",
            "java $fileNameWithoutExt",
          },
          python = "python3 -u",
          typescript = "deno run",
          rust = {
            "cd $dir &&",
            "rustc $fileName &&",
            "$dir/$fileNameWithoutExt",
          },
        },
      })
    end,
  },
  -- Blink.cmp - Fast completion engine
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = true, -- Show inline ghost text from copilot
        },
      },
      sources = {
        -- Conditionally enable copilot based on filetype
        default = function()
          local filetype = vim.bo.filetype
          -- Disable copilot for C++, C, and Python
          if filetype == "cpp" or filetype == "c" or filetype == "python" then
            return { "lsp", "path", "snippets", "buffer" }
          end
          -- Enable copilot for all other filetypes
          return { "lsp", "path", "snippets", "buffer", "copilot" }
        end,
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },

  --refactor/rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>rn",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        desc = "Incremental rename",
        mode = "n",
        noremap = true,
        expr = true,
      },
    },
    config = true,
  },

  -- Refactoring tool
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor({
            show_success_message = true,
          })
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },
}
