return {
    -- 使用 lazy.nvim 安装
    {
        "jdhao/better-escape.nvim",
        -- event = "InsertEnter",
        config = function()
            require("better_escape").setup {
                -- timeout = vim.o.timeoutlen, -- after `timeout` passes, you can press the escape key and the plugin will ignore it
                timeout = 500,
                default_mappings = true, -- setting this to false removes all the default mappings
                mappings = {
                    -- i for insert
                    i = {
                        j = {
                            -- These can all also be functions
                            k = "<Esc>",
                            j = "<Esc>",
                        },
                    },
                    c = {
                        j = {
                            k = "<C-c>",
                            j = "<C-c>",
                        },
                    },
                    t = {
                        j = {
                            k = "<C-\\><C-n>",
                        },
                    },
                    v = {
                        j = {
                            k = "<Esc>",
                        },
                    },
                    s = {
                        j = {
                            k = "<Esc>",
                        },
                    },
                },
            }
        end,
    },
}
