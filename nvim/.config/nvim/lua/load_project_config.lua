local M = {}



M.setup = function()
	local cwd = vim.fn.getcwd()

	local status_ok, project_configs = pcall(require, 'project_configs.local')
	if not status_ok then
		return
	end

	for path, config_func in pairs(project_configs.configs) do
		if path == cwd then
			config_func()
		end
	end
end


return M
