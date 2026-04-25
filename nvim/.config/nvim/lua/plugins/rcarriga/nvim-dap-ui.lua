return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
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
						{ id = "watches",     size = 0.25 },
						{ id = "breakpoints", size = 0.1 },
						-- 'size' can be float or integer > 1
						{ id = "scopes",      size = 0.25, },
					},
					size = 40,
					position = "left", -- Can be "left", "right", "top", "bottom"
				},
				{
					elements = { "repl" },
					size = 10,
					position = "bottom", -- Can be "left", "right", "top", "bottom"
				},
				{
					elements = { "console" },
					size = 90,
					position = "right", -- Can be "left", "right", "top", "bottom"
				},
				{
					elements = { "stacks", },
					size = 5,
					position = "top", -- Can be "left", "right", "top", "bottom"
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
}
