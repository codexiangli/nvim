vim.lsp.enable("clangd")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "c" },
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"williamboman/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				"clangd",
			},
		},
		opts_extend = { "ensure_installed" },
	},
}
