return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "VeryLazy",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-j>", -- 改为 Ctrl+j 接受建议
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			panel = { enabled = false },
		},
		config = function(_, opts)
			require("copilot").setup(opts)
			vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#6A9955", italic = true }) -- 设置 Copilot 建议的颜色和样式
			vim.api.nvim_set_hl(0, "CopilotSuggestionSelected", { fg = "#6A9955", bg = "#1E1E1E", italic = true }) -- 设置选中建议的颜色和样式
		end,
	},

	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.diff",
			"j-hui/fidget.nvim",
		},

		init = function()
			require("utils.codecompanion_fidget_spinner"):init()
		end,

        -- stylua: ignore
        keys = {
            { "<leader>cca", "<CMD>CodeCompanionActions<CR>",     mode = { "n", "v" }, noremap = true, silent = true, desc = "CodeCompanion actions" },
            { "<leader>cci", "<CMD>CodeCompanion<CR>",            mode = { "n", "v" }, noremap = true, silent = true, desc = "CodeCompanion inline" },
            { "<leader>ccc", "<CMD>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, noremap = true, silent = true, desc = "CodeCompanion chat (toggle)" },
            { "<leader>ccp", "<CMD>CodeCompanionChat Add<CR>",    mode = { "v" },      noremap = true, silent = true, desc = "CodeCompanion chat add code" },
        },

		opts = {
			display = {
				diff = {
					enabled = true,
					provider = "mini_diff",
				},
			},

			strategies = {
				chat = { adapter = "copilot" },
				inline = { adapter = "copilot" },
			},

			opts = {
				language = "English", -- "English"|"Chinese"
			},
		},
	},
}
