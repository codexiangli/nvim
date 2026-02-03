return {
    -- 状态栏配置
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "auto",
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = {
                    'filename',
                    {
                        function() return vim.o.paste and 'PASTE' or '' end,
                        color = { fg = '#ff5555' },
                        padding = { left = 1, right = 0 },
                    }
                },
                lualine_v = {},
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            winbar = {
                lualine_a = { 'filename' },
                lualine_b = {
                    { function() return " " end, color = 'Comment' },
                },
                lualine_x = { 'lsp_status' },
            },
            inactive_winbar = {
                -- always show winbar
                lualine_b = { function() return " " end }
            }
        },
        config = function(_, opts)
            -- local mocha = require("catppuccin.palettes").get_palette("mocha")
            -- local function show_macro_recording()
            --     local recording_register = vim.fn.reg_recording()
            --     if recording_register == "" then
            --         return ""
            --     else
            --         return "󰑋 " .. recording_register
            --     end
            -- end

            -- local macro_recording = {
            --     show_macro_recording,
            --     color = { fg = "#333333", bg = mocha.red },
            --     separator = { left = "", right = "" },
            --     padding = 0,
            -- },


            -- table.insert(opts.sections.lualine_v, 1, macro_recording)

            require("lualine").setup(opts)
        end
    },
}
