return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local lualine = require("lualine")

		local function lsp_formatter_status()
			local lspFormat = require "custom_tools.formatter"

			local get_string = function()
				local lspDisabled = lspFormat.disabled or lspFormat.disabled_filetypes[vim.bo.filetype] or
					vim.b.format_saving
				local autosaveText = ""
				-- if lspDisabled then
				-- 	autosaveText = "[Format on save]"
				-- else
				-- 	autosaveText = "[Format on save]"
				-- end
				autosaveText = "[F]"
				return --[[ lspStatus .. " " .. ]] autosaveText
			end

			local get_color = function()
				local lspDisabled = lspFormat.disabled or lspFormat.disabled_filetypes[vim.bo.filetype] or
					vim.b.format_saving
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
			local rust_cargo_checker = require "custom_tools.rust_cargo_checker"

			local get_string = function()
				-- if rust_cargo_checker.enabled then
				-- 	return "[Cargo-check]"
				-- else
				-- 	return "[Cargo-check]"
				-- end
				return "[C]"
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

		local function null_ls_root_dir_status()
			local status_ok, null_ls = pcall(require, "null-ls.client")
			if not status_ok then
				return
			end

			local get_string = function()
				local client = null_ls.get_client()
				if client then
					local root_dir = client.config.root_dir
					return "Null-ls root_dir: " .. vim.fn.pathshorten(root_dir)
				else
					return "null-ls disabled - no root_dir"
				end
			end

			local get_color = function()
				local client = null_ls.get_client()
				if client then
					return { fg = "#999900" }
				else
					return { fg = "#ff6666" }
				end
			end

			local get_cond = function()
				local client = null_ls.get_client()
				return true --client ~= nil
			end

			return {
				get_string,
				color = get_color,
				cond = get_cond
			}
		end

		lualine.setup({
			options = {
				icons_enabled = true,
				theme = 'auto',
				-- component_separators = { left = '', right = '' },
				-- section_separators = { left = '', right = '' },
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
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
				lualine_b = { --[["branch"]] },
				lualine_c = { {
					'filename',
					file_status = true, -- displays file status (readonly status, modified status)
					path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
				} },
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
					-- "filetype",
				},
				lualine_y = { --[[ null_ls_root_dir_status() ]] --[[ "progress" ]] },
				lualine_z = { --[["location"]] },
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
