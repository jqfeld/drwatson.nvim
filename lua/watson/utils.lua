
local M = {}

function M.projectdir()
    local git_root =  vim.fn.systemlist("git rev-parse --show-toplevel")
    return git_root[1]
end

function M.datadir()
    return M.projectdir() .. "/data"
end

function M.scriptsdir()
    return M.projectdir() .. "/scripts"
end

function M.plotsdir()
    return M.projectdir() .. "/plots"
end

function M.notesdir()
    return M.projectdir() .. "/notes"
end

return M
