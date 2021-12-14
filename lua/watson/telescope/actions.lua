local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local utils = require('watson/utils')
local Job = require "plenary.job"

local api = vim.api

local M = {}

function M.insert(prompt_bufnr)
    actions.close(prompt_bufnr)

    local entry = action_state.get_selected_entry()

    -- HACK: quick fix to get it working under windows, there are probably
    -- better ways...
    local path = entry[1]
    path = string.gsub(path, "\\", "/")

    local data_path = string.gsub(path, utils.data_dir().."/", "") 

    api.nvim_put({'datadir("' .. data_path .. '")'}, "c", true, true)

end

function M.open_plot(prompt_bufnr)
    actions.close(prompt_bufnr)
    local entry = action_state.get_selected_entry()


    local stdout, ret = Job
      :new({
        command = "xdg-open",
        args = { entry[1] },
        cwd = utils.plots_dir(),
      })
      :start()
end

return M
