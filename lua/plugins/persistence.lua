return {
    -- 会话管理
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            resume = true,
            last_session = true,
        },
        config = function(_, opts)
            require("persistence").setup(opts)
        end,
    },
}
