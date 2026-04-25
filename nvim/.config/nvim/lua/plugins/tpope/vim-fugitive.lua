return {
	-- Useful short videos of how to use fugitive:
	-- Links taken from: https://github.com/tpope/vim-fugitive#screencasts
	-- 	## Screencasts
	-- * [A complement to command line git](http://vimcasts.org/e/31)
	-- * [Working with the git index](http://vimcasts.org/e/32)
	-- * [Resolving merge conflicts with vimdiff](http://vimcasts.org/e/33)
	-- * [Browsing the git object database](http://vimcasts.org/e/34)
	-- * [Exploring the history of a git repository](http://vimcasts.org/e/35)
	{
		"tpope/vim-fugitive",
		config = function()
			-- remap '=' to '<TAB>' so I can toggle the diff more easily
			vim.cmd([[ let g:nremap = {'=': '<TAB>'}]])
		end
	},
}
