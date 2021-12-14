
local M = {}

function M.watson_dir()
    local git_root =  vim.fn.systemlist("git rev-parse --show-toplevel")  

    return git_root[1]
end

function M.data_dir()
    return M.watson_dir() .. "/data"
end

function M.plots_dir()
    return M.watson_dir() .. "/plots"
end

return M
