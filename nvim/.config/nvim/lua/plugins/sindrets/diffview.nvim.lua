return {
	-- git diff support
	{
		"sindrets/diffview.nvim",
		config = function()
			local actions = require("diffview.actions")
			require("diffview").setup({
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl',
				keymaps = {
					view = {
						{ "n", "<leader>e", actions.toggle_files, { desc = "Toggle the file panel." } },
					},
					file_panel = {
						{ "n", "s", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
						{ "n", "u", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
					},
				},
			})
		end
	},
}
