return {
	{
		dir = vim.fn.stdpath("config") .. "/lua/plugins/restful-search-nvim",
		name = "restful-search.nvim",
		config = function()
			require("restful-search").setup()
		end,
		-- stylua: ignore
		keys = {
			{ "<leader>se", function() require("restful-search").search() end,   desc = "[RestfulSearch] Search API endpoints" },
			{ "<leader>sE", function() require("restful-search").refresh() end,  desc = "[RestfulSearch] Refresh & search" },
		},
	},
}
