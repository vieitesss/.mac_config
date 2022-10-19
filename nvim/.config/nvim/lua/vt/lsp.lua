local status_installer, installer = pcall(require, 'nvim-lsp-installer')
if (not status_installer) then return end

local status_lsp, lsp = pcall(require, 'lspconfig')
if (not status_lsp) then return end

installer.setup {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true


----- Global configs -----
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
    -- disable virtual text
    -- virtual_text = false,

    -- show signs
    signs = true,

    -- delay update diagnostics
    update_in_insert = false,
  }
  )
end

local util = require("lspconfig.util")

util.default_config = vim.tbl_extend(
  "force",
  util.default_config,
  {
    on_attach = on_attach,
    capabilities = capabilities
  }
)

-- Lua
lsp.sumneko_lua.setup {
  settings = {
    Lua = {
      completion = {
        enable = true
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        enable = true,
        globals = { 'vim', 'use', 'love' },
        disable = { "lowercase-global" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        -- checkThirdParty = false,
        -- maxPreload = 2000,
        -- preloadFileSize = 1000
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

lsp.clangd.setup {}

lsp.bashls.setup {}
