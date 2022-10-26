local status_ok, dap = pcall(require, "dap")
if not status_ok then
  vim.notify("dap not found. Can't load debugger adapters")
  return
end

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = "/home/linus/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb",
    args = { "--port", "${port}" },
  }
}

dap.adapters.lldb = {
  type = 'executable',
  command = "/usr/bin/lldb-vscode",
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = 'Launch File [lldb-vscode]',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
      return vim.fn.split(vim.fn.input("Args: ", ""), " ")
    end,
    runInTerminal = false,
  },
  -- {
  --   name = 'Launch File [codelldb]',
  --   type = "codelldb",
  --   request = "launch",
  --   program = function()
  --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  --   end,
  --   cwd = '${workspaceFolder}',
  --   args = function()
  --     return vim.fn.split(vim.fn.input("Args: ", ""), " ")
  --   end,
  --   stopOnEntry = false,
  -- }
}
dap.configurations.c = dap.configurations.cpp

dap.configurations.rust = dap.configurations.cpp
--[[ dap.configurations.rust = {
  {
    name = "Launch Rust file [DEBUG]",
    type = "cppdbg",
    request = "launch",
    program = function()
      local selected = ""
      -- TODO: MAKE THIS WORK
      vim.notify("THIS DOESNT WORK YET")
      require "user.telescope-custom".custom_selection_menu_files("Executable to debug",
        vim.fn.getcwd(),
        { "target/debug/", "-p", "-u", "--type=f", "--max-depth=3" },
        function(selected_entry)
          selected = selected_entry
        end)
      -- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      vim.notify(selected)
      return selected
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
  },
  {
    name = "Attach to gdbserver :1234",
    type = "cppdbg",
    request = "launch",
    MIMode = "gdb",
    miDebuggerServerAddress = "localhost:1234",
    miDebuggerPath = "/usr/bin/gdb",
    cwd = "${workspaceFolder}",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
  },
} ]]
