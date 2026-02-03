return {
    -- nvim-tree 配置
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons", -- 可选但推荐
        },
        lazy = false,
        opts = {
            view = { width = 45 },
            update_focused_file = {
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-tree").setup(opts)
            vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
        end
    },
}
