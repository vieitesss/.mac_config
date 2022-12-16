local status = pcall(require, "vim-maximizer")
if not status then
	return
end

vim.keymap.set("n", "<Leader>sm", ":MaximizerToggle<CR>")
