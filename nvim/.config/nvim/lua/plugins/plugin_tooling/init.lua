---------------- NVIM PROGRAMMING / PLUGIN TOOLING ------------------------
return {
	-- nvim programming/ plugin tooling
	-- add lua ref into :help
	"milisims/nvim-luaref",
	-- "nanotee/luv-vimdocs",
	{
		"tpope/vim-scriptease",
		cmd = {
			"Messages", --view messages in quickfix list
			"Verbose", -- view verbose output in preview window.
			"Time", -- measure how long it takes to run some stuff.
		},
	},
	{ "folke/neodev.nvim", opts = {} }

}
