return {
	-- telescope.
	"nvim-telescope/telescope.nvim",

	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
		{
			"nvim-telescope/telescope-ui-select.nvim",
			config = function()
				require("telescope").load_extension("ui-select")
			end,
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local trouble = require("trouble.sources.telescope")

		telescope.setup({
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "smart" },
				file_ignore_patterns = {
					"node_modules",
					"%.git/",
					"%.cache",
					"%.o",
					"%.a",
					"%.out",
					"%.class",
					"%.pdf",
					"%.mkv",
					"%.mp4",
					"%.zip",
				},
				-- vimgrep_arguments = {
				-- 	"rg",
				-- 	"--color=never",
				-- 	"--no-heading",
				-- 	"--with-filename",
				-- 	"--line-number",
				-- 	"--column",
				-- 	"--smart-case",
				-- 	"--trim",
				-- 	-- '--hidden', -- include hidden files
				-- 	-- '-u' -- single u includes .gitignore, 2 u's include gitignore and hidden files
				-- },
				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-c>"] = actions.close,
						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,
						["<CR>"] = actions.select_default,
						["<C-x>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,
						["<c-t>"] = trouble.open,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<PageUp>"] = actions.results_scrolling_up,
						["<PageDown>"] = actions.results_scrolling_down,
						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-l>"] = actions.complete_tag,
						["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
					},
					n = {
						["<esc>"] = actions.close,
						["<CR>"] = actions.select_default,
						["<C-x>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,
						["<c-t>"] = trouble.open,
						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["j"] = actions.move_selection_next,
						["k"] = actions.move_selection_previous,
						["H"] = actions.move_to_top,
						["M"] = actions.move_to_middle,
						["L"] = actions.move_to_bottom,
						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,
						["gg"] = actions.move_to_top,
						["G"] = actions.move_to_bottom,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<PageUp>"] = actions.results_scrolling_up,
						["<PageDown>"] = actions.results_scrolling_down,
						["?"] = actions.which_key,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					theme = "ivy",
					previewer = false,
					winblend = 15,
					initial_mode = "insert",
				},
				keymaps = {
					theme = "ivy",
					winblend = 15,
					initial_mode = "normal",
				},
				buffers = {
					theme = "ivy",
					winblend = 15,
					initial_mode = "normal",
				},
				current_buffer_fuzzy_find = {
					theme = "dropdown",
					previewer = false,
					winblend = 0,
					layout_config = {
						width = 0.8,
						height = 0.7
					}
				},
				git_files = {
					theme = "dropdown",
					previewer = false,
					winblend = 15,
				},
				lsp_references = {
					trim_text = true,
					initial_mode = "normal",
				},
				live_grep = {
					theme = "dropdown",
					layout_config = {
						width = 0.9
					},
					winblend = 15,
					initial_mode = "insert",
				},
				quickfix = {
					initial_mode = "normal",
				},
				-- Default configuration for builtin pickers goes here:
				-- picker_name = {
				--   picker_config_key = value,
				--   ...
				-- }
				-- Now the picker_config_key will be applied every time you call this
				-- builtin picker
			},
			extensions = {
				-- Your extension configuration goes here:
				-- extension_name = {
				--   extension_config_key = value,
				-- }
				-- please take a look at the readme of the extension you want to configure
				["ui-select"] = {
					require("telescope.themes").get_dropdown {
						-- even more opts
						theme = "dropdown",
						winblend = 15
					}
				},
				require("telescope").load_extension("refactoring"),
				fzf = {
					fuzzy = true,    -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					-- or "ignore_case" or "respect_case"
					--	the default case_mode is "smart_case"
					case_mode = "smart_case",
				}
			},
		})

		-- load debugger extension
		telescope.load_extension("dap")
		telescope.load_extension("git_worktree")
	end
}
