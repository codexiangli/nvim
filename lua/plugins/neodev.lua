return {
	{
		"folke/neodev.nvim",
		opts = {},
		enabled = false,
		config = function()
			require("neodev").setup({
				-- add any options here, or leave empty to use the default settings
			})
		end,
	},
}
