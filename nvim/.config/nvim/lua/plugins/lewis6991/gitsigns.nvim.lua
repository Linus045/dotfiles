return {
	"lewis6991/gitsigns.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/which-key.nvim"
	},
	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%d.%m.%Y> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000,
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			on_attach = function()
				local keymap = require("custom_tools.keybindings_util").keymap
				-- Navigation
				-- &diff is true when in diff mode: https://neovim.io/doc/user/diff.html
				keymap("n", "]c", function()
						if vim.wo.diff then return ']c' end
						vim.schedule(function() gitsigns.next_hunk() end)
						return '<Ignore>'
					end,
					{ expr = true }, "[GITSIGNS] Next Hunk", false, false)

				keymap("n", "[c", function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gitsigns.prev_hunk() end)
					return '<Ignore>'
				end, { expr = true }, "[GITSIGNS] Previous Hunk", false, false)

				-- Actions
				opts = { noremap = true, silent = true }
				keymap("n", "<leader>h", nil, opts, "[GITSIGNS|VIM-FUGITIVE]", false, true)
				keymap("v", "<leader>h", nil, opts, "[GITSIGNS]", false, true)
				keymap("n", "<leader>ht", nil, opts, "[GITSIGNS] Toggles", false, true)
				keymap("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", opts, "[GITSIGNS] Stage hunk", false, false)
				keymap("v", "<leader>hs", ":Gitsigns stage_hunk<CR>", opts, "[GITSIGNS] Stage hunk", false, false)
				keymap("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", opts, "[GITSIGNS] Reset hunk", false, false)
				keymap("v", "<leader>hr", ":Gitsigns reset_hunk<CR>", opts, "[GITSIGNS] Reset hunk", false, false)
				keymap("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", opts, "[GITSIGNS] Stage current buffer",
					false, false)
				keymap("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", opts, "[GITSIGNS] Undo stage hunk", false,
					false)
				keymap("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", opts, "[GITSIGNS] Reset buffer", false, false)
				keymap("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", opts, "[GITSIGNS] Preview Hunk", false, false)
				keymap("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', opts,
					"[GITSIGNS] Blame line (full)", false, false)
				keymap("n", "<leader>htb", "<cmd>Gitsigns toggle_current_line_blame<CR>", opts,
					"[GITSIGNS] Toggle current line blame", false, false)
				keymap("n", "<leader>htl", "<cmd>Gitsigns toggle_linehl<CR>", opts, "[GITSIGNS] Toggle line highlights",
					false,
					false)
				keymap("n", "<leader>htw", "<cmd>Gitsigns toggle_word_diff<CR>", opts, "[GITSIGNS] Toggle word diff",
					false,
					false)
				keymap("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>", opts, "[GITSIGNS] Diff this file", false, false)
				keymap("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>', opts,
					"[GITSIGNS] Diff this file ",
					false, false)
				keymap("n", "<leader>htd", "<cmd>Gitsigns toggle_deleted<CR>", opts, "[GITSIGNS] Show/Hide deleted hunks",
					false,
					false)
				-- Text object
				-- Visual-select inner hunk
				keymap("o", "ih", ":<C-U>Gitsigns select_hunk<CR>", opts, "[GITSIGNS] Select inner hunk", false, false)
				keymap("x", "ih", ":<C-U>Gitsigns select_hunk<CR>", opts, "[GITSIGNS] Select inner hunk", false, false)
			end,
		})
	end
}
