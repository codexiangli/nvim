return {
	{
		"rmagatti/auto-session",
		lazy = false,

        -- stylua: ignore
        keys = {
            { "<leader>ps", "<CMD>AutoSession restore<CR>", desc = "[Auto Session] Restore session" },
            { "<leader>pS", "<CMD>AutoSession search<CR>",  desc = "[Auto Session] Search session" },
            { "<leader>pD", "<CMD>AutoSession delete<CR>",  desc = "[Auto Session] Delete session" },
            { "<leader>pa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
        },

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			auto_restore = false,
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			session_lens = {
				picker = "snacks",
			},
			git_use_branch_name = true,
			git_auto_restore_on_branch_change = true,
		},

		init = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end,
	},
}
