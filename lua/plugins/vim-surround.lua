return {
    -- 环绕编辑
    {
        "tpope/vim-surround",
        keys = {
            { "cs", mode = "n" },          -- 更改环绕
            { "ds", mode = "n" },          -- 删除环绕
            { "ys", mode = { "n", "v" } }, -- 添加环绕
        }
    },
}
