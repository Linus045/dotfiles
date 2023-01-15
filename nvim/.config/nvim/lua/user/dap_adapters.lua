local status_ok, dap = pcall(require, "dap")
if not status_ok then
  vim.notify("dap not found. Can't load debugger adapters")
  return
end

vim.cmd("packadd termdebug")
vim.g.termdebugger = "gdb"

require('dap-python').setup('/usr/bin/python')

dap.defaults.fallback.external_terminal = {
  command = '/usr/bin/kitty';
  args = { '-e' };
}
dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}

-- https://github.com/mfussenegger/nvim-dap/discussions/93
-- https://marketplace.visualstudio.com/items?itemName=lanza.lldb-vscode#launch-configuration-settings
dap.adapters["lldb-vscode-waitfor"] = function(cb, config)
  local adapter = dap.adapters.lldb
  -- set correct type for lldb-vscode
  config.type = "lldb-vscode"

  -- only do this on attach
  if config.request == 'attach' and config.program then
    local terminal = dap.defaults[config.type].external_terminal
    local full_args = {}
    vim.list_extend(full_args, terminal.args or {})
    table.insert(full_args, config.program)
    vim.list_extend(full_args, config.args or {})
    local opts = {
      args = full_args,
      detached = true
    }

    local handle
    local pid_or_err
    handle, pid_or_err = vim.loop.spawn(terminal.command, opts, function(code)
      handle:close()
      if code ~= 0 then
        vim.notify('Terminal process exited: ' ..
          vim.inspect(code) .. '. Running ' .. terminal.command .. " " .. vim.inspect(full_args))
      end
    end)

    if not handle then
      vim.notify('Could not launch process: ' .. terminal.command)
    else
      vim.notify('Launched external terminal: ' .. pid_or_err)
    end
  end

  cb(adapter)
end


dap.configurations.cpp = {
  {
    name = "Attach to process",
    type = "lldb",
    request = "attach",
    pid = require('dap.utils').pick_process
  },
  {
    name = "Start process extern and attach [with custom args]",
    type = "lldb-vscode-waitfor",
    request = "attach",
    stopOnEntry = false,
    waitFor = true,
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      return vim.fn.split(vim.fn.input("Args: ", ""), " ")
    end,
  },
  {
    name = "Launch process [with custom args]",
    type = "lldb-vscode-waitfor",
    request = "launch",
    stopOnEntry = false,
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      return vim.fn.split(vim.fn.input("Args: ", ""), " ")
    end,
  },
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
