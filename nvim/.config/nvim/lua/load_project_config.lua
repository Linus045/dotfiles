local M = {}


M.setup = function()
    local cwd = vim.fn.getcwd()
    -- print(cwd)
    if cwd == "/home/linus/dev/github/MatchBuddy" then
        vim.opt.expandtab = true
    elseif cwd == "/home/linus/dev/github/WORKTREE/main" then
        vim.opt.expandtab = true
    end
end


return M
