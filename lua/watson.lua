local telescope_builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local themes = require('telescope.themes')
local watson_actions = require('watson/telescope/actions')
local utils = require('watson/utils')

local flatten = vim.tbl_flatten

local M = {}

M.find_in = function(directory, opts)
    opts = opts or {}
    -- opts.previewer = opts.previewer or false
    -- opts.search_dirs = opts.search_dirs or {utils[directory]()}
    opts.cwd = opts.cwd or utils[directory]()
    opts.prompt_title = opts.prompt_title or "Find"

    local insert=true
    if opts.insert==nil then
        insert = true
    else
        insert = opts.insert
    end

    if insert then
        opts.attach_mappings = function()
            actions.select_default:replace(watson_actions.make_insert(directory))
            return true
        end
    end

    opts.find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }

    if opts.previewer == false then opts = themes.get_dropdown(opts) end

    return telescope_builtin.find_files(opts)

end


M.find_and_open_ext = function(directory, opts)
    opts = opts or {}

    opts.cwd = opts.cwd or utils[directory]()
    opts.prompt_title = opts.prompt_title or "Find"


    opts.attach_mappings = function()
        actions.select_default:replace(watson_actions.make_open_with(opts))
        return true
    end

    opts.find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }

    if opts.previewer == false then opts = themes.get_dropdown(opts) end

    return telescope_builtin.find_files(opts)

end

M.find_data = function (opts)
    opts = opts or {}
    opts.prompt_title = "Find Data"
    return M.find_in('datadir', opts) 
end

M.find_plot = function(opts)
    return M.find_and_open_ext(
        "plotsdir",
        {
            -- open_command = "feh",
            -- args = {'--auto-zoom', '--scale-down', '--conversion-timeout 0'},
            open_command = "zathura",
            args = {},
            prompt_title = "Find Plot",
        }
    )
end

M.find_notes = function(opts)
    return M.find_and_open_ext(
        "notesdir",
        {
            open_command = "xdg-open",
            prompt_title = "Find Notes",
        }
    )
end


return M
