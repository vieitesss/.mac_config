-- Status line
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.api.nvim_command("set laststatus=3")
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.c", "*.h", "*.lua", "*.sh", "*.java" },
	callback = function()
		vim.lsp.buf.format()
	end,
})
