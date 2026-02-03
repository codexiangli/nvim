return {
    -- Telescope 配置
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = { height = 0.95 },
                }
            })
            vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {})
            vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
            vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {})
            vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, {})
        end
    },
}
