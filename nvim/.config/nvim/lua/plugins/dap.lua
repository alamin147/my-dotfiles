return {
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Dap UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
        mode = { "n", "v" },
      },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mason-org/mason.nvim",
    },
    keys = {
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>da",
        function()
          require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to line (no execute)",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
    },
    config = function()
      local Config = require("lazyvim.config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- C++ debugging configuration
      local dap = require("dap")

      -- Configure codelldb adapter
      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = {"--port", "${port}"},
        }
      }

      -- Configure C++ debugging
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        {
          name = "Launch file with arguments",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ")
          end,
          runInTerminal = false,
        },
        {
          name = "Attach to process",
          type = "codelldb",
          request = "attach",
          pid = function()
            return require("dap.utils").pick_process()
          end,
          args = {},
        },
      }

      -- Configure C debugging (same as C++)
      dap.configurations.c = dap.configurations.cpp
    end,
  },
--   {
--     "mfussenegger/nvim-dap-python",
--     ft = "python",
--     rocks = { enabled = false },
--     dependencies = {
--       "mfussenegger/nvim-dap",
--       "rcarriga/nvim-dap-ui",
--     },
--     keys = {
--       {
--         "<leader>dPt",
--         function()
--           require("dap-python").test_method()
--         end,
--         desc = "Debug Method",
--       },
--       {
--         "<leader>dPc",
--         function()
--           require("dap-python").test_class()
--         end,
--         desc = "Debug Class",
--       },
--     },
--     config = function()
--       -- Try multiple possible paths for debugpy
--       local debugpy_paths = {
--         vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
--         vim.fn.stdpath("data") .. "/mason/bin/debugpy",
--         "debugpy", -- fallback to system debugpy
--       }

--       local debugpy_path = nil
--       for _, path in ipairs(debugpy_paths) do
--         if vim.fn.executable(path) == 1 or vim.fn.filereadable(path) == 1 then
--           debugpy_path = path
--           break
--         end
--       end

--       if not debugpy_path then
--         vim.notify("debugpy not found. Install it via Mason or pip.", vim.log.levels.ERROR)
--         return
--       end

--       require("dap-python").setup(debugpy_path)

--       -- Configure Python debugging
--       require("dap").configurations.python = {
--         {
--           type = "python",
--           request = "launch",
--           name = "Launch file",
--           program = "${file}",
--           pythonPath = function()
--             -- Try to find python in virtual environment first
--             local cwd = vim.fn.getcwd()
--             if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
--               return cwd .. "/venv/bin/python"
--             elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
--               return cwd .. "/.venv/bin/python"
--             else
--               return "/usr/bin/python3"
--             end
--           end,
--         },
--         {
--           type = "python",
--           request = "launch",
--           name = "Launch file with arguments",
--           program = "${file}",
--           args = function()
--             local args_string = vim.fn.input("Arguments: ")
--             return vim.split(args_string, " ")
--           end,
--           pythonPath = function()
--             local cwd = vim.fn.getcwd()
--             if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
--               return cwd .. "/venv/bin/python"
--             elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
--               return cwd .. "/.venv/bin/python"
--             else
--               return "/usr/bin/python3"
--             end
--           end,
--         },
--       }
--     end,
--   },
}
