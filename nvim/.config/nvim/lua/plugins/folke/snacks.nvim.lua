return {
	-- A collection of QoL plugins for Neovim
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		--@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			explorer = { enabled = false },
			indent = { enabled = true },
			input = {
				enabled = true,
				icon = " ",
				icon_hl = "SnacksInputIcon",
				icon_pos = "left",
				prompt_pos = "title",
				win = {
					style = "input",
					relative = "cursor",
				},
				expand = true,
			},
			picker = { enabled = false },

			notifier = { enabled = false },
			quickfile = { enabled = false },
			scope = { enabled = false },
			scroll = { enabled = true },
			statuscolumn = {
				enabled = true,
				left = { "mark", "sign" }, -- priority of signs on the left (high to low)
				right = { "fold", "git", {
					"|"
				} }, -- priority of signs on the right (high to low)
				folds = {
					open = true, -- show open fold icons
					git_hl = true, -- use Git Signs hl for fold icons
				},
				git = {
					-- patterns to match Git signs
					patterns = { "GitSign", "MiniDiffSign" },
				},
				refresh = 50, -- refresh at most every 50ms

			},
			words = {
				enabled = true,

				debounce = 200, -- time in ms to wait before updating
				notify_jump = false, -- show a notification when jumping
				notify_end = true, -- show a notification when reaching the end
				foldopen = true, -- open folds after jumping
				jumplist = true, -- set jump point before jumping
				modes = { "n", "i", "c" }, -- modes to show references
				filter = function(buf) -- what buffers to enable `snacks.words`
					return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
				end,
			},
			zen = {
				enabled = true,
				toggles = {
					dim = true,
					git_signs = false,
					mini_diff_signs = false,
					diagnostics = true,
					inlay_hints = true,
				},
				show = {
					statusline = false, -- can only be shown when using the global statusline
					tabline = false,
				},
				win = {
					style = "zen",
					enter = true,
					fixbuf = false,
					minimal = false,
					width = 140,
					height = 0,
					backdrop = { transparent = true, blend = 40 },
					keys = { q = false },
					zindex = 40,
					wo = {
						winhighlight = "NormalFloat:Normal",
					},
					w = {
						snacks_main = true,
					},
				},


			},
		},
	},
}
