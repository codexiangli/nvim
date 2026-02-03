return {
    -- 主题
    {
        "loctvl842/monokai-pro.nvim",
        name = "monokai-pro",
        lazy = true,
        priority = 1000,
        opts = {
            variant = "pro",
            transparent_background = false,
        },
        config = function(_, opts)
            require("monokai-pro").setup(opts)
        end,
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    {
        "navarasu/onedark.nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('onedark').setup {
                style = 'darker'
            }
        end
    },

}
