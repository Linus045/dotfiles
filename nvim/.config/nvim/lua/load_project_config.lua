local M = {}


M.original_options = {}

-- Saves current config as default (will be applied before loading custom configs to reset)
M.store_current_options = function()
	M.original_options = vim.opt
end

M.load_custom_config_for_cwd = function()
	local cwd = vim.fn.getcwd()

	local status_ok, project_configs = pcall(require, 'project_configs_local')
	if not status_ok then
		return
	end

	for path, config_func in pairs(project_configs.configs) do
		if vim.startswith(cwd, path) then
			-- apply default config
			vim.notify("Loading config for: " .. cwd)
			vim.opt = M.original_options
			config_func()
		end
	end
end


return M
