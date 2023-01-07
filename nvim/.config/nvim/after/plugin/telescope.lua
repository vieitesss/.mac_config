local status, telescope = pcall(require, "telescope")
if not status then
	return
end

local builtin = require("telescope.builtin")
local vt_telescope = require("vt.telescope")

vim.keymap.set("n", "<Leader>ff", builtin.find_files)
vim.keymap.set("n", "<Leader>fg", builtin.live_grep)
vim.keymap.set("n", "<Leader>fb", builtin.buffers)
vim.keymap.set("n", "<Leader>fh", builtin.help_tags)
vim.keymap.set("n", "<Leader>dot", vt_telescope.search_dotfiles, { silent = true })
vim.keymap.set("n", "<Leader>nv", vt_telescope.search_nvim, { silent = true })

local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		--file_sorter = require'telescope.sorters'.get_fzy_sorter,
		prompt_prefix = " >",
		color_devicons = true,

		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		-- grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        mappings = {
            n = {
                ["q"] = actions.close
            }
        }
	},
	pickers = {
		find_files = {
			hidden = true,
			-- cwd = "~/",
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
