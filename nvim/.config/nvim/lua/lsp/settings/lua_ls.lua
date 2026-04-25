return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";")
			},
			diagnostics = {
				globals = { "vim", "require" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
}
