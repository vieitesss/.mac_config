return {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
        {
            "williamboman/mason.nvim",
            name = "mason",
            config = true
        },
        {
            "williamboman/mason-lspconfig.nvim",
            name = "mason-lspconfig",
            opts = {
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                    "jdtls",
                    "marksman",
                    "pyright",
                },
            }
        },
        {
            "glepnir/lspsaga.nvim",
            config = function()
                require 'lspsaga'.setup({
                    symbol_in_winbar = {
                        enable = false
                    }
                })
            end,
        },
    },
    config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        capabilities.offsetEncoding = 'utf-8'

        local keymap = vim.keymap
        local on_attach = function(client, bufnr)
            -- require 'lsp-format'.on_attach(client)
            local opts = { noremap = true, silent = true, buffer = bufnr }

            keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
            keymap.set("n", "gr", ":Telescope lsp_references<CR>", opts)
            keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
            keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
            keymap.set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
            keymap.set("n", "<space>rn", "<cmd>Lspsaga rename<CR>", opts)
            keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
            keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
            keymap.set("n", "<leader>ou", "<cmd>Lspsaga outline<CR>", opts)
            keymap.set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        end

        local lspconfig = require('lspconfig')

        local servers = {
            "clangd",
            "bashls",
            "tsserver",
            "marksman",
            "texlab",
            "pylsp",
            "pyright",
            "cssls",
            "jdtls"
        }

        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end

        -- Ignore nil messages.
        local function on_language_status(_, result)
            if result.message == nil then
                return
            end
            local command = vim.api.nvim_command
            command 'echohl ModeMsg'
            command(string.format('echo "%s"', result.message))
            command 'echohl None'
        end

        lspconfig.jdtls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            handlers = {
                ["$/progress"] = vim.schedule_wrap(on_language_status),
            },
            settings = {
                java = {
                    project = {
                        referencedLibraries = {
                            "**/*.jar",
                        }
                    }
                }
            },
            root_dir = function(fname)
                return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname) or
                vim.fn.getcwd()
            end,
        })

        -- lspconfig.ltex.setup({
        --     capabilities = capabilities,
        --     on_attach = on_attach,
        --     settings = {
        --         ltex = {
        --             disabledRules = {
        --                 ["en-US"] = { "MORFOLOGIK_RULE_EN_US", "EN_A_VS_AN" },
        --             }
        --         }
        --     }
        -- })

        lspconfig.sumneko_lua.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    completion = {
                        enable = true,
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        enable = true,
                        globals = { "require", "vim", "use", "love" },
                        -- disable = { "lowercase-global" },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                        -- maxPreload = 2000,
                        -- preloadFileSize = 1000,
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })
    end
}
