-- This module is now simplified to only define and export LSP handlers and capabilities.
-- The actual setup is handled by plugins in `plugins.lua`.

local M = {}

-- Customized on_attach function
-- M.on_attach = function(client, bufnr)
--     -- Debug: print when on_attach is called
--     print(string.format("LSP on_attach called for buffer %d with client %s", bufnr, client.name))

--     vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

--     local bufopts = { noremap = true, silent = true, buffer = bufnr }
--     vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
--     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
--     vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
--     vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
--     vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
--     vim.keymap.set('n', '<space>wl', function()
--         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--     end, bufopts)
--     vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
--     vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
--     vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
--     vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
--     vim.keymap.set("n", "<space>f", function()
--         vim.lsp.buf.format({ async = true })
--     end, bufopts)
-- end


vim.diagnostic.config({
    virtual_text = true
})

require("mason-lspconfig").setup({
    ensure_installed = { 'pylsp', 'pyright', 'lua_ls', 'rust_analyzer', 'kotlin_language_server', 'jdtls', 'clangd' },
    handlers = {},
})


vim.lsp.config.clangd = {
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--pch-storage=memory",
        "--offset-encoding=utf-16", -- 如果你的 clangd 版本 >= 15
    },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
    on_attach = function(client, bufnr)
        -- 自定义按键映射
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- 跳转到定义
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        -- 显示文档
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        -- 重命名
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        -- 代码操作
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        -- 引用查找
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        -- 格式化（异步）
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)

        -- 禁用 clangd 的格式化，可以使用 null-ls 或其他格式化工具
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
}

vim.lsp.enable({ 'pyright' })


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
