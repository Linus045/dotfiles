return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local lualine = require("lualine")

		local function mycustomcomponent()
			local lspFormat = require "formatter"
			local lspDisabled = lspFormat.disabled or lspFormat.disabled_filetypes[vim.bo.filetype] or vim.b.format_saving
			local autosaveText = ""
			if lspDisabled then
				autosaveText = "[Format on save disabled]"
			else
				autosaveText = "[Format on save enabled]"
			end
			return --[[ lspStatus .. " " .. ]] autosaveText
		end

		lualine.setup({
			options = {
				icons_enabled = true,
				theme = 'auto',
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				}
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", --[[ "diagnostics" ]] },
				lualine_c = { "filename" },
				lualine_x = {
					-- TODO: Uncomment these
					-- "%{cmake#GetInfo().cmake_version.string}",
					mycustomcomponent,
					-- TODO: Uncomment these
					-- "%{FugitiveStatusline()}",
					"fileformat",
					"filetype" },
				lualine_y = { --[[ "progress" ]] },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "diagnostics" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = {},
		})
	end
}
