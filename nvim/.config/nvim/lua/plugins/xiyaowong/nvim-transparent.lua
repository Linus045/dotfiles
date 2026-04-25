return {
	-- allow transparent code
	{
		"xiyaowong/nvim-transparent",
		config = function()
			local transparent = require("transparent")
			transparent.setup({
				extra_groups = {},
				exclude_groups = {}, -- table: groups you don't want to clear
			})
		end
	},
}
