local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local utils = require('watson/utils')
local Job = require "plenary.job"

local api = vim.api

local M = {}

function M.make_insert(directory)
    local function insert(prompt_bufnr)
        actions.close(prompt_bufnr)

        local entry = action_state.get_selected_entry()

        -- HACK: quick fix to get it working under windows, there are probably
        -- better ways...
        local path = entry[1]
        path = string.gsub(path, "\\", "/")

        local data_path = string.gsub(path, utils[directory]().."/", "")

        api.nvim_put({directory..'("' .. data_path .. '")'}, "c", false, true)
    end
    return insert

end

function M.make_open_with(opts)
    local cmd = opts.open_command or "xdg-open"
    local args = opts.args or {}
    local cwd = opts.cwd or utils.projectdir()

    local func = function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local entry = action_state.get_selected_entry()

        table.insert(args, entry[1])

        local stdout, ret = Job
          :new({
            command = cmd,
            args = args,
            cwd = cwd,
            -- on_stderr = function(error, data)
            --     P(error)
            --     P(data)
            -- end,
          })
          :start()
    end
    return func
end

return M
