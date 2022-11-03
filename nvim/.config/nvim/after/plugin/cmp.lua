local status_cmp, cmp = pcall(require, 'cmp')
if not status_cmp then return end

local status_lspkind, lspkind = pcall(require, 'lspkind')
if not status_lspkind then return end

-- local luasnip = require('luasnip')

vim.o.completeopt = 'menu,menuone,noselect'

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- Disable cmp when writting comments
local enabled = function()
  local in_prompt = vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt'
  if in_prompt then
    return false
  end
  local context = require("cmp.config.context")
  return not (context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
end

cmp.setup {
  enabled = enabled,
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-l>"] = cmp.mapping(function(fallback)
      if vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<Tab>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<C-space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = 'vsnip' },
    { name = 'nvim_lsp', max_item_count = 6 },
    { name = 'path' },
    { name = 'buffer' },
    -- { name = 'luasnip'},
  }),
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        vsnip = "[VSnip]",
        nvim_lsp = "[LSP]",
        buffer = "[BUF]"
        -- luasnip = "[LuaSnip]",
      }
    }
  },
  -- confirm_opts = {
  --   behavior = cmp.ConfirmBehavior.Replace,
  --   select = false,
  -- },
  -- experimental = {
  -- native_menu = false,
  --   ghost_text = true,
  -- },
}
