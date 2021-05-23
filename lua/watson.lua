local Job = require('plenary/job')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local make_entry = require('telescope.make_entry')

local flatten = vim.tbl_flatten

local M = {}

function M.watson_dir()
    git_root =  vim.fn.systemlist("git rev-parse --show-toplevel")  

    return git_root[1]
end

function M.data_dir()
    return M.watson_dir() .. "/data"
end

function M.find_data(opts)
    opts = opts or {}

    local find_command = opts.find_command
    local hidden = opts.hidden
    local follow = opts.follow
    -- local search_dirs = opts.search_dirs
    local search_dirs = {M.data_dir()}
    

    if search_dirs then
        for k,v in pairs(search_dirs) do
            search_dirs[k] = vim.fn.expand(v)
        end
    end

    if not find_command then
        if 1 == vim.fn.executable("fd") then
            find_command = { 'fd', '--type', 'f' }
                if hidden then table.insert(find_command, '--hidden') end
                if follow then table.insert(find_command, '-L') end
                if search_dirs then
                    table.insert(find_command, '.')
                    for _,v in pairs(search_dirs) do
                        table.insert(find_command, v)
                    end
                end
        elseif 1 == vim.fn.executable("fdfind") then
            find_command = { 'fdfind', '--type', 'f' }
                if hidden then table.insert(find_command, '--hidden') end
                if follow then table.insert(find_command, '-L') end
                if search_dirs then
                    table.insert(find_command, '.')
                    for _,v in pairs(search_dirs) do
                        table.insert(find_command, v)
                    end
                end
        elseif 1 == vim.fn.executable("rg") then
            find_command = { 'rg', '--files' }
            if hidden then table.insert(find_command, '--hidden') end
            if follow then table.insert(find_command, '-L') end
            if search_dirs then
                for _,v in pairs(search_dirs) do
                    table.insert(find_command, v)
                end
            end
        elseif 1 == vim.fn.executable("find") then
            find_command = { 'find', '.', '-type', 'f' }
            if not hidden then
                table.insert(find_command, { '-not', '-path', "*/.*" })
                find_command = flatten(find_command)
            end
            if follow then table.insert(find_command, '-L') end
            if search_dirs then
                table.remove(find_command, 2)
                for _,v in pairs(search_dirs) do
                    table.insert(find_command, 2, v)
                end
            end
        end
    end

    if not find_command then
        print("You need to install either find, fd, or rg. " ..
              "You can also submit a PR to add support for another file finder :)")
        return
    end

    if opts.cwd then
        opts.cwd = vim.fn.expand(opts.cwd)
    end

    opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

    pickers.new(opts, {
        prompt_title = 'Data',
        finder = finders.new_oneshot_job(
            find_command,
            opts
        ),
        previewer = conf.file_previewer(opts),
        sorter = conf.file_sorter(opts),
        }
    ):find()
end

return M
