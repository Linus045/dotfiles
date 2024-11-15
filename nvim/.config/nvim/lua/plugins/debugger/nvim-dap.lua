return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")

		dap.defaults.fallback.external_terminal = {
			command = '/usr/bin/kitty',
			args = { '-e' },
		}

		dap.defaults.fallback.terminal_win_cmd = '50vsplit new'


		-- opens a picker to select an executable in the current working directory
		-- starts lldb debug session upon selection
		local executables_picker = function(selected_cwd)
			local cwd = vim.fn.getcwd()
			require("plugins.telescope.telescope_custom")
				.custom_selection_menu_files(
					"Executable to debug",
					cwd,
					{
						'--no-ignore', '--absolute-path', '--type', 'x'
					},
					function(selected_entry)
						vim.notify("Selected entry: " .. selected_entry)
						dap.run(
							{
								name = "Launch process [with custom args]",
								type = "lldb-dap",
								request = "launch",
								stopOnEntry = false,
								program = selected_entry,
								cwd = selected_cwd,
								args = function()
									return vim.fn.split(vim.fn.input("Args: ", ""), " ")
								end,
							}
						)
					end)
		end

		-- opens a picker to select a working directory
		-- opens executables_picker upon selection
		local cwd_picker = function()
			local cwd = vim.fn.getcwd()
			require("plugins.telescope.telescope_custom")
				.custom_selection_menu_files(
					"Pick working directory for executable",
					cwd,
					{
						'--no-ignore', '--absolute-path', '--type', 'd'
					},
					function(selected_entry)
						vim.notify("Selected entry: " .. selected_entry)
						executables_picker(selected_entry)
					end)
		end

		-- "smart" continue function that will either continue the current session
		-- or open the picker to select a working directory and executable
		dap.my_custom_continue_function = function(filetype)
			if dap.session() then
				dap.continue()
			else
				if filetype == "cpp" then
					cwd_picker()
				else
					print(
						"Note: No custom launch function for filetype. Please add to dap.my_custom_continue_function. Trying to load launch.json file instead")

					-- map 'type' in launch.json to correct configuration
					require('dap.ext.vscode').load_launchjs(".vscode/launch.json", {
						codelldb = { "c", "cpp" },
						node = { "typescript" },
						["pwa-node"] = { "typescript" }
					})
				end
			end
		end

		local bin_locations = vim.fn.stdpath("data") .. "/mason/bin/"
		dap.adapters.codelldb = {
			type = 'server',
			port = "${port}",
			executable = {
				command = bin_locations .. 'codelldb', -- adjust as needed, must be absolute path
				args = { "--port", "${port}" },
			},
		}

		dap.adapters["codelldb-attach"] = {
			type = 'server',
			port = "${port}",
			executable = {
				command = bin_locations .. 'codelldb', -- adjust as needed, must be absolute path
				args = { "--port", "${port}" },
			},
		}

		-- https://github.com/mfussenegger/nvim-dap/discussions/93
		-- https://marketplace.visualstudio.com/items?itemName=lanza.lldb-vscode#launch-configuration-settings
		dap.adapters["lldb-dap"] = function(cb, config)
			-- grab config from codelldb adapter
			local adapter = dap.adapters.codelldb

			-- only do this on attach to run in external terminal
			if config.request == 'attach' and config.program then
				local terminal = dap.defaults[config.type].external_terminal
				local full_args = {}
				vim.list_extend(full_args, terminal.args or {})
				table.insert(full_args, config.program)
				vim.list_extend(full_args, config.args or {})
				local opts = {
					args = full_args,
					cwd = config.cwd,
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
			-- TODO: Attach to process is not working
			-- {
			-- 	name = "Attach to process",
			-- dont use lldb-dap type here because that does special things for
			-- external terminals
			-- 	type = "codelldb",
			-- 	request = "attach",
			-- 	pid = require('dap.utils').pick_process,
			-- 	args = {},
			-- },
			{
				name = "Start process extern and attach [with custom args]",
				type = "lldb-dap",
				request = "attach",
				stopOnEntry = false,
				waitFor = true,
				cwd = function()
					return vim.fn.input('Working directory for executable: ', vim.fn.getcwd() .. '/', 'dir')
				end,
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				args = function()
					return vim.fn.split(vim.fn.input("Args: ", ""), " ")
				end,
			},
			{
				name = "Launch process [with custom args]",
				type = "lldb-dap",
				request = "launch",
				cwd = function()
					return vim.fn.input('Working directory for executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
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

		--[[
		dap.configurations.rust = {
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
}
]]

		--[[
		-- DAP setup javascript/typescript
		-- install dap-vscode-js via mason
		local status_ok, vscode_js_dap = pcall(require, 'dap-vscode-js')
		if not status_ok then
			vim.notify('File nvim-dap.lua: dap-vscode-js not found.')
		else
			vscode_js_dap.setup({
				debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
				adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
				debugger_cmd = { 'js-debug-adapter' },
			})

			dap.adapters["node"] = function(cb, config)
				P("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
				P(config)
				cb({
					type = "pwa-node",
					port = "${port}"
				})
			end

			-- custom adapter for running tasks before starting debug
			-- local custom_adapter = 'pwa-node-custom'
			-- dap.adapters[custom_adapter] = function(cb, config)
			-- 	if config.preLaunchTask then
			-- 		local async = require('plenary.async')
			-- 		local notify = require('notify').async

			-- 		async.run(function()
			-- 			notify('Running [' .. config.preLaunchTask .. ']').events.close()
			-- 		end, function()
			-- 			vim.fn.system(config.preLaunchTask)
			-- 			config.type = 'pwa-node'
			-- 			dap.run(config)
			-- 		end)
			-- 	end
			-- end

			-- language config
			for _, language in ipairs({ 'typescript', 'javascript' }) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require 'dap.utils'.pick_process,
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Jest Tests",
						-- trace = true, -- include debugger info
						runtimeExecutable = "node",
						runtimeArgs = {
							"./node_modules/jest/bin/jest.js",
							"--runInBand",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
					},
					-- {
					-- 	name = 'Launch',
					-- 	type = 'pwa-node',
					-- 	request = 'launch',
					-- 	program = '${file}',
					-- 	rootPath = '${workspaceFolder}',
					-- 	cwd = '${workspaceFolder}',
					-- 	sourceMaps = true,
					-- 	skipFiles = { '<node_internals>/**' },
					-- 	protocol = 'inspector',
					-- 	console = 'integratedTerminal',
					-- },
					-- {
					-- 	name = 'Attach to node process',
					-- 	type = 'pwa-node',
					-- 	request = 'attach',
					-- 	rootPath = '${workspaceFolder}',
					-- 	processId = require('dap.utils').pick_process,
					-- },
					-- {
					-- 	name = 'Debug Main Process (Electron)',
					-- 	type = 'pwa-node',
					-- 	request = 'launch',
					-- 	program = '${workspaceFolder}/node_modules/.bin/electron',
					-- 	args = {
					-- 		'${workspaceFolder}/dist/index.js',
					-- 	},
					-- 	outFiles = {
					-- 		'${workspaceFolder}/dist/*.js',
					-- 	},
					-- 	resolveSourceMapLocations = {
					-- 		'${workspaceFolder}/dist/**/*.js',
					-- 		'${workspaceFolder}/dist/*.js',
					-- 	},
					-- 	rootPath = '${workspaceFolder}',
					-- 	cwd = '${workspaceFolder}',
					-- 	sourceMaps = true,
					-- 	skipFiles = { '<node_internals>/**' },
					-- 	protocol = 'inspector',
					-- 	console = 'integratedTerminal',
					-- },
					-- {
					-- 	name = 'Compile & Debug Main Process (Electron)',
					-- 	type = custom_adapter,
					-- 	request = 'launch',
					-- 	preLaunchTask = 'npm run build-ts',
					-- 	program = '${workspaceFolder}/node_modules/.bin/electron',
					-- 	args = {
					-- 		'${workspaceFolder}/dist/index.js',
					-- 	},
					-- 	outFiles = {
					-- 		'${workspaceFolder}/dist/*.js',
					-- 	},
					-- 	resolveSourceMapLocations = {
					-- 		'${workspaceFolder}/dist/**/*.js',
					-- 		'${workspaceFolder}/dist/*.js',
					-- 	},
					-- 	rootPath = '${workspaceFolder}',
					-- 	cwd = '${workspaceFolder}',
					-- 	sourceMaps = true,
					-- 	skipFiles = { '<node_internals>/**' },
					-- 	protocol = 'inspector',
					-- 	console = 'integratedTerminal',
					-- },
				}
			end
		end
]]
	end,
}
