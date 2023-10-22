return {
	require("plugins.debugger.nvim-dap"),
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			local virtual_text = require("nvim-dap-virtual-text")
			virtual_text.setup({
				enabled = true,         -- enable this plugin (the default)
				enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
				highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
				highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
				show_stop_reason = true, -- show stop reason when stopped for exceptions
				commented = false,      -- prefix virtual text with comment string
				only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
				all_references = true,  -- show virtual text on all all references of the variable (not only definitions)
				-- experimental features:
				virt_text_pos = "eol",  -- position of virtual text, see `:h nvim_buf_set_extmark()`
				all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
				virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
				virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
				-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
			})
		end
	},
	"nvim-telescope/telescope-dap.nvim",
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local dapui = require("dapui")
			local dap = require("dap")

			-- automatically open/close dapui when debugger is launched/existed
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					-- Use a table to apply multiple mappings
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "<CR>",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "<TAB>",
				},
				element_mappings = {
					-- breakpoints = {
					--   open = "<CR>",
					--   toggle = "<TAB>",
					-- }
				},
				controls = {
					-- Requires Neovim nightly (or 0.8 when released)
					enabled = true,
					-- Display controls in this element
					element = "repl",
				},
				layouts = {
					-- You can change the order of elements in the sidebar
					{
						elements = {
							-- Provide as ID strings or tables with "id" and "size" keys
							{
								id = "scopes",
								size = 0.25, -- Can be float or integer > 1
							},
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks",      size = 0.25 },
							{ id = "watches",     size = 0.25 },
						},
						size = 40,
						position = "left", -- Can be "left", "right", "top", "bottom"
					},
					{
						elements = { "repl", "console" },
						size = 10,
						position = "bottom", -- Can be "left", "right", "top", "bottom"
					},
				},
				floating = {
					max_height = nil, -- These can be integers or a float between 0 and 1.
					max_width = nil, -- Floats will be treated as percentage of your screen.
					border = "single", -- Border style. Can be "single", "double" or "rounded"
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				windows = { indent = 1 },
			})
		end
	},
	{
		"mxsdev/nvim-dap-vscode-js",
	},

	-- "mfussenegger/nvim-dap-python",

	-- debug the nvim client
	-- use "jbyuki/one-small-step-for-vimkind"
}
