return {
    -- LSP Core & Setup
    { "neovim/nvim-lspconfig" },


    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        -- config = function()
        --   local lsp_config = require('lspconfig')
        --   require("mason-lspconfig").setup({
        --     ensure_installed = { 'pylsp', 'pyright', 'lua_ls', 'rust_analyzer', 'kotlin_language_server', 'jdtls' },
        --     handlers = {
        --       -- Default handler for all servers EXCEPT jdtls
        --       function(server_name)
        --         if server_name == 'jdtls' then return end -- Skip jdtls, it's handled by nvim-jdtls
        --         require("lspconfig")[server_name].setup({
        --           on_attach = lsp_config.on_attach,
        --           capabilities = lsp_config.capabilities,
        --         })
        --       end,
        --       ["pyright"] = function()
        --           require("lspconfig").pyright.setup({
        --               on_attach = lsp_config.on_attach,
        --               capabilities = lsp_config.capabilities,
        --               filetypes = {"python"},
        --           })
        --       end,
        --       ["pylsp"] = function()
        --         require("lspconfig").pylsp.setup({
        --           on_attach = lsp_config.on_attach,
        --           capabilities = lsp_config.capabilities,
        --           settings = {
        --             pylsp = {
        --               plugins = {
        --                 pycodestyle = {
        --                   ignore = {"W391"},
        --                   maxLineLength = 100,
        --                 },
        --               },
        --             },
        --           },
        --         })
        --       end,
        --     },
        --   })
        -- end,
    },

    -- Java (jdtls) specific configuration
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
        dependencies = { 'neovim/nvim-lspconfig' },
        -- config = function()
        --   local lsp_utils = require('lsp')
        --   local jdtls = require('jdtls')
        --   jdtls.start_or_attach({
        --     cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/jdtls') },
        --     root_dir = jdtls.setup.find_root({'gradlew', '.git', 'mvnw'}),
        --     on_attach = lsp_utils.on_attach,
        --     capabilities = lsp_utils.capabilities,
        --   })
        -- end,
    },

}
