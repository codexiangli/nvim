return {
	-- Treesitter 配置
	{
		"nvim-treesitter/nvim-treesitter",
		-- main = "nvim-treesitter.configs",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"json",
				"yaml",
				"markdown",
				"bash",
				"kotlin",
				"query",
			},
			sync_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
		},
		opts_extend = { "ensure_installed" },
		-- config = function(_, opts)
		--     require("nvim-treesitter").setup(opts)
		-- end,
	},
}
