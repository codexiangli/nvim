return {
    {
        "petertriho/nvim-scrollbar",
        opts = {
            handelers = {
                gitsigns = true, -- Requires gitsigns
                search = true, -- Requires hlslens
            },
            excluded_buftypes = {
                "terminal",
                "nofile", -- This buftype is used by dap's hover() window
            },
            marks = {
                Search = {
                    color = "#CBA6F7",
                },
                GitAdd = { text = "┃" },
                GitChange = { text = "┃" },
                GitDelete = { text = "_" },
            },
        },
    },
}
