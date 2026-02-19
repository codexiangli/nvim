return {
	{
		"zaldih/themery.nvim",
		lazy = false,
		config = function()
			require("themery").setup({
				-- add the config hrbarere
				themes = { "catppuccin", "monokai-pro", "tokyonight", "kanagawa", "onedark" }, -- Your list of installed colorschemes.
			})
		end,
	},
}
