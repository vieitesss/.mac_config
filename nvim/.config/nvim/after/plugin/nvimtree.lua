local status, tree = pcall(require, "nvim-tree")
if not status then
	return
end

-- nvim-tree
vim.keymap.set("n", "<Leader>pv", ":NvimTreeToggle<CR>", { silent = true })

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

tree.setup()
