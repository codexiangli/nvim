return {
	-- 使用 noice.nvim 改进 UI
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		keys = {
			-- { "<leader>sN", "<CMD>Noice pick<CR>", desc = "[Noice] Pick history messages" },
			{ "<leader>N", "<CMD>Noice<CR>", desc = "[Noice] Show history messages" },
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- 覆盖 LSP 消息
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					hover = {
						enabled = true,
						silent = false, -- 悬停时静音
						view = "hover", -- 使用 hover 视图
						opts = {}, -- 全局 hover 选项
					},
					signature = {
						enabled = true,
						auto_open = {
							enabled = true,
							trigger = true, -- 自动打开签名帮助
							luasnip = true,
							throttle = 50,
						},
						view = "hover", -- 使用 hover 视图
						opts = {},
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = true,
					lsp_doc_border = true, -- 为文档添加边框
				},
			})
		end,
	},
}
