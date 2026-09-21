return {
  -- tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      local ensure_installed = {
        -- Language Servers
        "clangd", -- C/C++
        "pyright", -- Python
        "typescript-language-server", -- JavaScript/TypeScript
        "vtsls", -- Enhanced TypeScript/JavaScript LSP
        "html-lsp", -- HTML
        "css-lsp", -- CSS
        "tailwindcss-language-server", -- TailwindCSS
        "emmet-ls", -- HTML/CSS snippets
        "jdtls", -- Java
        "json-lsp", -- JSON
        "lua-language-server", -- Lua

        -- Linters
        -- "luacheck",         -- Lua linter; requires luarocks, added conditionally below
        "shellcheck", -- Shell script linter
        "eslint-lsp", -- JS/TS linter
        "cpplint", -- C/C++ linter

        -- Formatters
        "clang-format", -- C/C++ formatter
        "black", -- Python formatter
        "prettier", -- JS/TS/CSS/HTML/JSON formatter
        "stylua", -- Lua formatter
        "shfmt", -- Shell formatter
        "google-java-format", -- Java formatter

        -- Debuggers
        "debugpy", -- Python debugger
        "codelldb", -- C/C++/Rust debugger
        "js-debug-adapter", -- JavaScript/TypeScript debugger
      }

      if vim.fn.executable("luarocks") == 1 then
        table.insert(ensure_installed, "luacheck")
      end

      vim.list_extend(opts.ensure_installed, ensure_installed)
      local seen = {}
      opts.ensure_installed = vim.tbl_filter(function(name)
        if seen[name] then
          return false
        end
        seen[name] = true
        return true
      end, opts.ensure_installed)
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
          -- Keep nvim-lspconfig's root detector. It uses Neovim's current
          -- (bufnr, on_dir) API and detects both config-based Tailwind v3
          -- projects and config-free Tailwind v4 package.json projects.
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
