local function launch_root()
  return vim.g.original_cwd or vim.fn.getcwd()
end

local function build_current_native_file()
  local source = vim.fn.expand("%:p")
  local filetype = vim.bo.filetype
  local compiler = filetype == "c" and "gcc" or "g++"

  if source == "" then
    error("Save the file before starting the debugger")
  end
  if vim.fn.executable(compiler) ~= 1 then
    error(compiler .. " is not installed")
  end

  vim.cmd.write()
  local output_dir = vim.fn.stdpath("cache") .. "/dap-build"
  vim.fn.mkdir(output_dir, "p")
  local output = output_dir .. "/" .. vim.fn.fnamemodify(source, ":t:r") .. "-" .. vim.fn.sha256(source):sub(1, 10)
  local result = vim.fn.system({ compiler, "-g", "-O0", "-Wall", "-Wextra", source, "-o", output })

  if vim.v.shell_error ~= 0 then
    vim.notify(result, vim.log.levels.ERROR, { title = "Debug build failed" })
    error("Compilation failed; see the notification for details")
  end

  return output
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          require("dap-python").setup("debugpy-adapter")
        end,
      },
    },
    config = function()
      -- Keep LazyVim's DAP-core initialization while adding the language
      -- adapters below. This is explicit because LazyVim's core config owns
      -- the plugin's config callback.
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(value)
        return vim.json.decode(json.json_strip_comments(value))
      end

      local dap = require("dap")

      dap.adapters.codelldb = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }

      for _, language in ipairs({ "c", "cpp" }) do
        dap.configurations[language] = {
          {
            name = "Build and debug current file",
            type = "codelldb",
            request = "launch",
            program = build_current_native_file,
            cwd = launch_root,
            stopOnEntry = false,
          },
          {
            name = "Debug an existing executable",
            type = "codelldb",
            request = "launch",
            program = function()
              return vim.fn.input("Executable: ", launch_root() .. "/", "file")
            end,
            cwd = launch_root,
            stopOnEntry = false,
          },
          {
            name = "Attach to a running process",
            type = "codelldb",
            request = "attach",
            pid = require("dap.utils").pick_process,
            cwd = launch_root,
          },
        }
      end

      for _, adapter_type in ipairs({ "node", "chrome", "msedge" }) do
        local pwa_type = "pwa-" .. adapter_type
        dap.adapters[pwa_type] = dap.adapters[pwa_type]
          or {
            type = "server",
            host = "127.0.0.1",
            port = "${port}",
            executable = {
              command = "js-debug-adapter",
              args = { "${port}", "127.0.0.1" },
            },
          }
      end

      local js_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
      for _, language in ipairs(js_filetypes) do
        local runtime
        if language:find("typescript", 1, true) then
          runtime = vim.fn.executable("tsx") == 1 and "tsx"
            or (vim.fn.executable("ts-node") == 1 and "ts-node" or "node")
        end
        dap.configurations[language] = {
          {
            name = "Debug current file",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd = launch_root,
            sourceMaps = true,
            runtimeExecutable = runtime,
            skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
          },
          {
            name = "Attach to a Node process",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = launch_root,
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
          },
        }
      end
    end,
  },
}
