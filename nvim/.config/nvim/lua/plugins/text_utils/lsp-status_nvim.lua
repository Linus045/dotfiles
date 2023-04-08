return {
	"nvim-lua/lsp-status.nvim",
	config = function()
		require("lsp-status").config({
			status_symbol = "❤ ",
		})
		require("lsp-status").register_progress()
	end,
}
