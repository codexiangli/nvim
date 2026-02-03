return {
    -- Treesitter 配置
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "lua", "python", "json", "yaml", "markdown", "bash", "java", "kotlin", "c", "query"
            },
            sync_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
        end,
    },
}
