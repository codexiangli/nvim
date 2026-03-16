return {
	{
		"sphamba/smear-cursor.nvim",
		opts = {
			cursor_color = "#d3cdc3",
			smear_insert_mode = false,
			smear_normal_mode = true,
		},
		config = function(_, opts)
			require("smear_cursor").setup(opts)
			-- cmdline 打开时禁用，关闭时恢复
			vim.api.nvim_create_autocmd("CmdlineEnter", {
				callback = function()
					require("smear_cursor").enabled = false
				end,
			})
			vim.api.nvim_create_autocmd("CmdlineLeave", {
				callback = function()
					require("smear_cursor").enabled = true
				end,
			})
		end,
	},
}