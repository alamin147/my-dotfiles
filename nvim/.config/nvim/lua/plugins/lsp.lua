local lspconfig = require("lspconfig")

return {
  -- tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- Language Servers
        "clangd",                        -- C/C++
        "pyright",                       -- Python
        "typescript-language-server",    -- JavaScript/TypeScript
        "vtsls",                         -- Enhanced TypeScript/JavaScript LSP
        "html-lsp",                      -- HTML
        "css-lsp",                       -- CSS
        "tailwindcss-language-server",   -- TailwindCSS
        "emmet-ls",                      -- HTML/CSS snippets
        "jdtls",                         -- Java
        "json-lsp",                      -- JSON
        "lua-language-server",          -- Lua

        -- Linters
        "luacheck",            -- Lua linter
        "shellcheck",          -- Shell script linter
        "eslint-lsp",          -- JS/TS linter
        "cpplint",             -- C/C++ linter

        -- Formatters
        "clang-format",        -- C/C++ formatter
        "black",               -- Python formatter
        "prettier",            -- JS/TS/CSS/HTML/JSON formatter
        "stylua",              -- Lua formatter
        "shfmt",               -- Shell formatter

        -- Debuggers
        "debugpy",             -- Python debugger
        "codelldb",            -- C/C++/Rust debugger
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

        -- JavaScript/TypeScript (using vtsls for better performance)
        vtsls = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")(...)
          end,
          single_file_support = true,
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
              suggest = {
                completeFunctionCalls = true,
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
              suggest = {
                completeFunctionCalls = true,
              },
            },
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
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
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },

        -- TailwindCSS
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(
              "tailwind.config.js",
              "tailwind.config.cjs",
              "tailwind.config.mjs",
              "tailwind.config.ts",
              "postcss.config.js",
              "postcss.config.cjs",
              "postcss.config.mjs",
              "postcss.config.ts",
              ".git"
            )(...)
          end,
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
          },
          init_options = {
            userLanguages = {
              html = "html",
            },
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                },
              },
              validate = true,
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidScreen = "error",
                invalidVariant = "error",
                invalidConfigPath = "error",
                invalidTailwindDirective = "error",
                recommendedVariantOrder = "warning",
              },
            },
          },
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
