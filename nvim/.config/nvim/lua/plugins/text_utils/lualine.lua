return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local lualine = require("lualine")


		-- copied from: https://github.com/mcauley-penney/nvim/blob/main/lua/ui/statusline.lua
		-- file/selection info -------------------------------------
		local function fileinfo_widget()
			-- insert grouping separators in numbers
			-- viml regex: https://stackoverflow.com/a/42911668
			-- lua pattern: stolen from Akinsho
			local group_number = function(num, sep)
				if num < 999 then return tostring(num) end

				num = tostring(num)
				return num:reverse():gsub("(%d%d%d)", "%1" .. sep):reverse():gsub("^,", "")
			end


			local get_info = function()
				local ft = vim.api.nvim_get_option_value("filetype", {})
				local lines = group_number(vim.api.nvim_buf_line_count(0), ",")
				local str = "[≡ "

				-- Always show lines and words for all filetypes
				-- local nonprog_modes = {
				-- 	["markdown"] = true,
				-- 	["org"] = true,
				-- 	["orgagenda"] = true,
				-- 	["text"] = true,
				-- }

				-- if not nonprog_modes[ft] then
				-- 	return str .. string.format("%3s lines", lines)
				-- end

				local wc = vim.fn.wordcount()
				if not wc.visual_words then
					return str .. string.format("%3s lines  %3s words]", lines, group_number(wc.words, ","))
				end

				local vlines = math.abs(vim.fn.line(".") - vim.fn.line("v")) + 1
				local info = str .. string.format(
					"%3s lines %3s words  %3s chars]",
					group_number(vlines, ","),
					group_number(wc.visual_words, ","),
					group_number(wc.visual_chars, ",")
				)
				return info
			end

			return {
				get_info,
				{ fg = "#ff6666" }
			}
		end

		local function git_diff_whitespace_status()
			local get_string = function()
				local in_diff_view = vim.opt.diff:get()
				if in_diff_view then
					return "[IgnoreWhitespace]"
				else
					return ""
				end
			end

			local get_color = function()
				local current_diff_opts = vim.opt.diffopt:get()
				local whitespaceEnabled = not vim.list_contains(current_diff_opts, "iwhite")

				if whitespaceEnabled then
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

		local function scrollbar_widget()
			local SBAR = { "▔", "🮂", "🬂", "🮃", "▀", "▄", "▃", "🬭", "▂", "▁" }
			local hl_str = function(hl, str) return "%#" .. hl .. "#" .. str .. "%*" end

			local cur = vim.api.nvim_win_get_cursor(0)[1]
			local total = vim.api.nvim_buf_line_count(0)
			local idx = math.floor((cur - 1) / total * #SBAR) + 1
			return SBAR[idx]:rep(1)
		end

		local function lsp_formatter_status()
			local lspFormat = require "custom_tools.custom_formatter"

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
				lualine_b = { "diagnostics" --[[, "branch"]] },
				lualine_c = { {
					'filename',
					file_status = true, -- displays file status (readonly status, modified status)
					path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
				},
				},
				lualine_x = {
					-- "%{cmake#GetInfo().cmake_version.string}",
					"%{FugitiveStatusline()}",
					fileinfo_widget(),
					lsp_formatter_status(),
					git_diff_whitespace_status(),
					rust_cargo_checker_status(),
					{
						"fileformat",
						icons_enabled = true,
						symbols = {
							unix = 'LF',
							dos = 'CRLF',
							mac = 'CR',
						},
					},
					"filetype",
					-- Ruler to show current cursor position
					{
						"%7([Ln:%4l|Col:%2c] (%0P)%)",
						color = {
							fg = "#ff6666",
						}
					},
					{
						scrollbar_widget,
						color = {
							fg = "Cyan",
						}
					}
				},
				lualine_y = {
					--[[ null_ls_root_dir_status() ]] --[[ "progress" ]] },
				lualine_z = {

					--[["location"]] },
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
