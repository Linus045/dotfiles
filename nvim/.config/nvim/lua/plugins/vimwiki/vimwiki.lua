return {
	-- vim wiki
	{
		"vimwiki/vimwiki",
		-- using init here instead of config to set the variable before loading the plugin
		init = function()
			vim.g.vimwiki_list = {
				{
					path = "~/.nvim_journal/",
					path_html = "~/.nvim_journal/wiki_html/",
					index = ".nvim_journal",
					syntax = "markdown",
					ext = ".md"
				}
			}
		end
	},
}
