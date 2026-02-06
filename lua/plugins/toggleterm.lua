return {
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                size = 15,
                open_mapping = [[<c-\>]],
                direction = "horizontal",
            })
            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                float_opts = { border = "rounded" },
                close_on_exit = false,
            })
        end
    },
}
