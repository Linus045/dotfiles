return {
	settings = {
		pylsp = {
			plugins = {
				pylint = { enabled = false },
				pyflakes = { enabled = false },
				pycodestyle = {
					enabled = false,
					-- ignore = {
					-- 	"E501", -- line too long (82 > 79 characters)
					-- 	"E3", -- expected 2 blank lines, found 0
					-- 	"E266", -- too many leading ‘#’ for block comment
					-- 	"E228", -- missing whitespace around modulo operator
					-- }
				},
			},
		},
	},
}
