local status_cmp, cmp = pcall(require, "cmp")
if not status_cmp then
	return
end

local status_lspkind, lspkind = pcall(require, "lspkind")
if not status_lspkind then
	return
end

local status_luasnip, luasnip = pcall(require, "luasnip")
if not status_luasnip then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

vim.o.completeopt = "menu,menuone,noselect"

cmp.setup({
	enabled = function()
		return true
	end,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-l>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-h>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<Tab>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
	}),
	sources = cmp.config.sources({
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	}),
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol",
			menu = {
				nvim_lsp = "[LSP]",
				buffer = "[BUF]",
				luasnip = "[LuaSnip]",
				cmdline = "[CMD]",
				path = "[PATH]",
			},
		}),
	},
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
})
