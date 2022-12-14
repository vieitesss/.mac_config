local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local dropdown = require('telescope.themes').get_dropdown()
local actions = require('telescope.actions')
local state = require('telescope.actions.state')
local sorter = require('telescope.sorters').get_generic_fuzzy_sorter({})

local file_colors = vim.fn.getenv('HOME') .. "/.config/nvim/after/plugin/colors.lua"

-- Background picker
local bg_picker = {
    finder = finders.new_table({ "light", "dark" }),
    sorter = sorter,
    attach_mappings = function (prompt_bufnr, map)
        map("i", "<cr>", enter_bg)
        map("i", "<C-J>", next_bg)
        map("i", "<C-K>", prev_bg)
        map("i", "<esc>", escape)

        map("n", "<cr>", enter_bg)
        map("n", "j", next_bg)
        map("n", "k", prev_bg)
        map("n", "<esc>", escape)

        return true
    end
}

function enter_bg(prompt_bufnr)
    local selected = state.get_selected_entry()[1]
    vim.api.nvim_command("set background=" .. selected)
    vim.api.nvim_command(":!sed -i '' 's/\\(background=\\)[^\"]*/\\1" .. selected .. "/' " .. file_colors)
    actions.close(prompt_bufnr)
end

function escape(prompt_bufnr)
    vim.api.nvim_command("so " .. file_colors)
    actions.close(prompt_bufnr)
end

function next_bg(prompt_bufnr)
    actions.move_selection_next(prompt_bufnr)
    local selected = state.get_selected_entry()[1]
    vim.api.nvim_command("set background=" .. selected)
end

function prev_bg(prompt_bufnr)
    actions.move_selection_previous(prompt_bufnr)
    local selected = state.get_selected_entry()[1]
    vim.api.nvim_command("set background=" .. selected)
end

local bg = pickers.new(dropdown, bg_picker)

bg:find()
