return {
	-- floating terminal in nvim
	{
		"akinsho/toggleterm.nvim",
		config = function()
			local toggleterm = require("toggleterm")
			toggleterm.setup({
				open_mapping = [[<c-\>]],
				close_on_exit = true, -- close the terminal window when the process exits
			})
		end
	},
}
