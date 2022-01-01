local telescope_builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local themes = require('telescope.themes')
local watson_actions = require('watson/telescope/actions')
local utils = require('watson/utils')

local flatten = vim.tbl_flatten

local M = {}

M.find_data = function(opts)
    opts = opts or {}
    -- opts.previewer = opts.previewer or false
    opts.search_dirs = opts.search_dirs or {utils.data_dir()}
    opts.cwd = opts.cwd or utils.data_dir()
    opts.prompt_title = opts.prompt_title or "Find Data"

    local insert=true
    if opts.insert==nil then
        insert = true
    else
        insert = opts.insert
    end

    if insert then
        opts.attach_mappings = function()
            actions.select_default:replace(watson_actions.insert)
            return true
        end
    end

    opts.find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }

    if opts.previewer == false then opts = themes.get_dropdown(opts) end

    return telescope_builtin.find_files(opts)

end


M.find_and_open = function(opts)
    opts = opts or {}

    opts.cwd = opts.cwd or utils.watson_dir()
    opts.prompt_title = opts.prompt_title or "Find"


    opts.attach_mappings = function()
        actions.select_default:replace(watson_actions.make_open_with(opts))
        return true
    end

    opts.find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }

    if opts.previewer == false then opts = themes.get_dropdown(opts) end

    return telescope_builtin.find_files(opts)

end


M.find_plot = function(opts)
    return M.find_and_open({
        cwd = utils.plots_dir(),
        open_command = "xdg-open",
        prompt_title = "Find Plot",
    })
end

M.find_notes = function(opts)
    return M.find_and_open({
        cwd = utils.notes_dir(),
        open_command = "xdg-open",
        prompt_title = "Find Notes",
    })
end


return M
