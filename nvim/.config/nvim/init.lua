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

ENABLE_COPILOT = true

require("options")
require("utilities")

require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		-- do stuff after lazy initialized
	end
})


require("custom_tools.formatter").setup()
require("custom_tools.termdebug_helper").setup()
require("custom_tools.rust_cargo_checker").setup()
require("custom_tools.load_project_config").load_custom_config_for_cwd()
require("custom_tools.idle")
