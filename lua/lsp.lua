-- This module is now simplified to only define and export LSP handlers and capabilities.
-- The actual setup is handled by plugins in `plugins.lua`.

local M = {}

-- Customized on_attach function
M.on_attach = function(client, bufnr)
    -- Debug: print when on_attach is called
    print(string.format("LSP on_attach called for buffer %d with client %s", bufnr, client.name))

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
end

M.capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.diagnostic.config({
    virtual_text = true
})


local lsp_config = require('lspconfig')
require("mason-lspconfig").setup({
    ensure_installed = { 'pylsp', 'pyright', 'lua_ls', 'rust_analyzer', 'kotlin_language_server', 'jdtls' },
    handlers = {
        -- Default handler for all servers EXCEPT jdtls
        function(server_name)
            if server_name == 'jdtls' then return end -- Skip jdtls, it's handled by nvim-jdtls
            require("lspconfig")[server_name].setup({
                on_attach = lsp_config.on_attach,
                capabilities = lsp_config.capabilities,
            })
        end,
        ["pyright"] = function()
            require("lspconfig").pyright.setup({
                on_attach = lsp_config.on_attach,
                capabilities = lsp_config.capabilities,
                filetypes = { "python" },
            })
        end,
        ["pylsp"] = function()
            require("lspconfig").pylsp.setup({
                on_attach = lsp_config.on_attach,
                capabilities = lsp_config.capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                ignore = { "W391" },
                                maxLineLength = 100,
                            },
                        },
                    },
                },
            })
        end,
        ["lua_rs"] = function()
            require("lspconfig").lua_ls.setup({
                on_attach = lsp_config.on_attach,
                capabilities = lsp_config.capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {
                                'vim',
                                'require'
                            },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    },
                },

            })
        end
    },
})

vim.lsp.enable('pyright')


vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})



return M
