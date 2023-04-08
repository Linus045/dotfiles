-- Colorize terminal color codes (when colored output is shown in nvim)
return {
	"norcalli/nvim-terminal.lua",
	config = function()
		require("terminal").setup()
	end,
}
