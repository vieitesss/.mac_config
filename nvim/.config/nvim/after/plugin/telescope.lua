local status, telescope = pcall(require, "telescope")
if not status then
	return
end

vim.keymap.set("n", "<Leader>ff", [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
vim.keymap.set("n", "<Leader>fg", [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
vim.keymap.set("n", "<Leader>fb", [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
vim.keymap.set("n", "<Leader>fh", [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
vim.keymap.set("n", "<Leader>fp", [[<cmd>lua require('telescope').extensions.project.project()<CR>]])
vim.keymap.set("n", "<Leader>dot", [[:lua require'vt.telescope'.search_dotfiles()<CR>]], { silent = true })
vim.keymap.set("n", "<Leader>pro", [[:lua require'vt.telescope'.search_projects()<CR>]], { silent = true })
vim.keymap.set("n", "<Leader>nv", [[:lua require'vt.telescope'.search_nvim()<CR>]], { silent = true })

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		--file_sorter = require'telescope.sorters'.get_fzy_sorter,
		prompt_prefix = " >",
		color_devicons = true,

		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		--grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new
	},
	extensions = {
		media_files = {
			filetypes = { "png", "webp", "jpg", "jpeg" },
		},
		project = {
			hidden_files = true,
		},
	},
	pickers = {
		find_files = {
			hidden = true,
			cwd = "~/",
		},
		buffers = {
			initial_mode = "normal",
			show_all_buffers = true,
			sort_lastused = true,
			theme = "dropdown",
			previewer = false,
			mappings = {
				n = {
					["dd"] = actions.delete_buffer,
					["s"] = actions.add_selection,
					["r"] = actions.remove_selection,
				},
			},
		},
		lsp_references = {
			initial_mode = "normal",
		},
	},
})
telescope.load_extension("project")
telescope.load_extension("media_files")

local M = {}

M.search_dotfiles = function()
	builtin.find_files({
		prompt_title = "Dotfiles",
		-- cwd = "~/.dotfiles/",
		cwd = "~/.mac_config/",
	})
end

M.search_nvim = function()
	builtin.find_files({
		prompt_title = "Nvim Config",
		cwd = "~/.config/nvim/",
	})
end

M.search_projects = function()
	builtin.find_files({
		prompt_title = "My projects",
		cwd = "~/projects/",
		follow = true,
		hidden = false,
	})
end

return M
