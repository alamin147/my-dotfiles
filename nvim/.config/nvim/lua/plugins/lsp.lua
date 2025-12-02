local lspconfig = require("lspconfig")

return {
  -- tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- Language Servers
        "clangd",              -- C/C++
        "pyright",             -- Python
        "typescript-language-server", -- JavaScript/TypeScript
        "html-lsp",            -- HTML
        "css-lsp",             -- CSS
        "tailwindcss-language-server", -- TailwindCSS
        "jdtls",               -- Java
        "emmet-ls",            -- HTML/CSS snippets

        -- Linters
        "luacheck",            -- Lua linter
        "shellcheck",          -- Shell script linter
        "eslint-lsp",          -- JS/TS linter

        -- Formatters
        "clang-format",        -- C/C++ formatter
        "black",               -- Python formatter
        "prettier",            -- JS/TS/CSS/HTML/JSON formatter
        "stylua",              -- Lua formatter

        -- Debuggers
        "debugpy",             -- Python debugger
        "codelldb",            -- C/C++/Rust debugger

        "shfmt",
      })
    end,
  },
  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      ---@type lspconfig.options
      servers = {
        -- C/C++
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },

        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                diagnosticMode = "workspace",
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                },
              },
            },
          },
        },

        -- JavaScript/TypeScript
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- HTML
        html = {
          filetypes = { "html", "htmldjango" },
        },

        -- CSS
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },

        -- TailwindCSS
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },

        -- Emmet (HTML/CSS snippets)
        emmet_ls = {
          filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
        },

        -- Java
        jdtls = {
          -- Java LSP will be configured automatically
        },

        -- Lua
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
              },
            },
          },
        },
      },
      setup = {},
    },
  },
  {
    "nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },
}
