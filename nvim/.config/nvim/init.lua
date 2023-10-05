local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


require("options")
require("utilities")
require("formatter").setup()

require("lazy").setup("plugins")

require("termdebug_helper").setup()
require("rust_cargo_checker").setup()

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		-- do stuff after lazy initialized
	end
})


require("load_project_config").load_custom_config_for_cwd()
