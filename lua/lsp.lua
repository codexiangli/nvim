-- This module is now simplified to only define and export LSP handlers and capabilities.
-- The actual setup is handled by plugins in `plugins.lua`.

local M = {}

vim.diagnostic.config({
    virtual_text = true
})

require("mason-lspconfig").setup({
    ensure_installed = { 'pylsp', 'pyright', 'lua_ls', 'rust_analyzer', 'kotlin_language_server', 'jdtls', 'clangd' },
    handlers = {},
})


vim.lsp.config.clangd = {
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

vim.lsp.enable({'pylsp'})

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
