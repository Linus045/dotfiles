return {
	settings = {
		pylsp = {
			plugins = {
				pylint = {
					enabled = true,
					-- "C0116", --Missing function or method docstring []
					-- "C0103", -- [invalid-name] Constant name "n" doesn't conform to UPPER_CASE naming style []
					args = { '--ignore=C0116,C0103', '-' },
				},
				pyflakes = { enabled = true },
				pycodestyle = {
					enabled = true,
					ignore = {
						"E501", -- line too long (82 > 79 characters)
						"E3", -- expected 2 blank lines, found 0
						"E266", -- too many leading ‘#’ for block comment
						"E228", -- missing whitespace around modulo operator
						"E226", -- E226 missing whitespace around arithmetic operator
						"W504", -- W504 line break after binary operator
						"W503", -- line break before binary operator
					}
				},
			},
		},
	},
}
