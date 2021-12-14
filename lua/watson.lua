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



M.find_plot = function(opts)
    opts = opts or {}
    -- opts.previewer = opts.previewer or false
    opts.search_dirs = opts.search_dirs or {utils.plots_dir()}
    opts.cwd = opts.cwd or utils.plots_dir()
    opts.prompt_title = opts.prompt_title or "Find Plot"


    opts.attach_mappings = function()
        actions.select_default:replace(watson_actions.open_plot)
        return true
    end

    opts.find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }

    if opts.previewer == false then opts = themes.get_dropdown(opts) end

    return telescope_builtin.find_files(opts)

end


return M
