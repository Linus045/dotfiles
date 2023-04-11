return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local lualine = require("lualine")

		local function lsp_formatter_status()
			local lspFormat = require "formatter"

			local get_string = function()
				local lspDisabled = lspFormat.disabled or lspFormat.disabled_filetypes[vim.bo.filetype] or vim.b.format_saving
				local autosaveText = ""
				if lspDisabled then
					autosaveText = "[Format on save]"
				else
					autosaveText = "[Format on save]"
				end
				return --[[ lspStatus .. " " .. ]] autosaveText
			end

			local get_color = function()
				local lspDisabled = lspFormat.disabled or lspFormat.disabled_filetypes[vim.bo.filetype] or vim.b.format_saving
				if lspDisabled then
					return { fg = "#ff6666" }
				else
					return { fg = "#66ff66" }
				end
			end

			return {
				get_string,
				color = get_color,
			}
		end

		local function rust_cargo_checker_status()
			local rust_cargo_checker = require "rust_cargo_checker"

			local get_string = function()
				if rust_cargo_checker.enabled then
					return "[Cargo-check]"
				else
					return "[Cargo-check]"
				end
			end

			local get_color = function()
				if rust_cargo_checker.enabled then
					return { fg = "#66ff66" }
				else
					return { fg = "#ff6666" }
				end
			end

			return {
				get_string,
				color = get_color,
				cond = rust_cargo_checker.current_buffer_filetype_is_rust
			}
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
					-- "%{cmake#GetInfo().cmake_version.string}",
					"%{FugitiveStatusline()}",
					lsp_formatter_status(),
					rust_cargo_checker_status(),
					-- {
					-- 	"fileformat",
					-- 	icons_enabled = true,
					-- 	symbols = {
					-- 		unix = 'LF',
					-- 		dos = 'CRLF',
					-- 		mac = 'CR',
					-- 	},
					-- },
					"filetype",
				},
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
