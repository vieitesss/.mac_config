local status_mason, mason = pcall(require, "mason")
if not status_mason then
	return
end

local status_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_mason_lspconfig then
	return
end

local status_mason_null_ls, mason_null_ls = pcall(require, "mason-null-ls")
if not status_mason_null_ls then
	return
end

mason.setup()

mason_lspconfig.setup({
	ensure_installed = {
		"sumneko_lua",
		"clangd",
		"bashls",
		"jdtls",
		"marksman",
		"pyright",
	},
})

mason_null_ls.setup({
	ensure_installed = {
		"clang_format",
		"cpplint",
		"stylua",
		"pylint",
	},
})
