return {

	-- git inside nvim
	{
		"TimUntersberger/neogit",
		branch = "master",
		config = function()
			require("neogit").setup({})
		end
	},

}
