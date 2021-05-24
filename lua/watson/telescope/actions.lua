local actions = require('telescope.actions')
local utils = require('watson/utils')

local api = vim.api

local M = {}

function M.insert(prompt_bufnr)
    actions.close(prompt_bufnr)

    local entry = actions.get_selected_entry()
    local data_path = string.gsub(entry[1], utils.data_dir().."/", "") 

    api.nvim_put({'datadir(\"' .. data_path .. '\")'}, "c", true, true)

end

return M
