return {
	{
		"RaafatTurki/hex.nvim",
		config = function()
			local hex = require "hex"
			local original_is_file_binary_pre_read = hex.cfg.is_file_binary_pre_read
			local original_is_file_binary_post_read = hex.cfg.is_file_binary_post_read

			require 'hex'.setup {
				is_file_binary_pre_read = function()
					local is_binary = original_is_file_binary_pre_read()
					if is_binary then
						vim.notify("[hex.nvim] Use :HexToggle to switch between hex and text view")
					end
					return is_binary
				end,

				is_file_binary_post_read = function()
					local is_binary = original_is_file_binary_post_read()
					if is_binary then
						vim.notify("[hex.nvim] Use :HexToggle to switch between hex and text view")
					end
					return is_binary
				end,
			}
		end
	},
}
