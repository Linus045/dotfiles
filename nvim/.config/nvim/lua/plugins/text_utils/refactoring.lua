return {
	"ThePrimeagen/refactoring.nvim",
	config = function()
		require('refactoring').setup({
			prompt_func_return_type = {
				go = false,
				java = true,
				cpp = true,
				c = true,
				h = true,
				hpp = true,
				cxx = true,
				python = true
			},
			prompt_func_param_type = {
				go = false,
				java = false,
				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
				python = true
			},
			printf_statements = {},
			print_var_statements = {},
		})
	end
}
