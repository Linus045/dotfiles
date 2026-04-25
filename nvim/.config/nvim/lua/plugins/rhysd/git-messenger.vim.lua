return {
	-- see git line info
	-- <leader>gm
	{
		"rhysd/git-messenger.vim",
		config = function()
			vim.g.git_messenger_always_into_popup = true
			vim.g.git_messenger_no_default_mappings = true
		end
	},

}
