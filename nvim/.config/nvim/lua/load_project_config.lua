local M = {}

M.load_custom_config_for_cwd = function()
    local cwd = vim.fn.getcwd()

    local status_ok, project_configs = pcall(require, 'project_configs_local')
    if not status_ok then
        return
    end

    for path, config_func in pairs(project_configs.configs) do
        if vim.startswith(cwd, path) then
            config_func()
        end
    end
end


return M
