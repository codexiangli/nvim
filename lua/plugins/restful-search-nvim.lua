return {
	{
		"codexiangli/restful-search.nvim",
		config = function()
			require("restful-search").setup({
				root_markers = { "pom.xml", "build.gradle", ".git" },
			})
		end,
		keys = {
			{
				"<leader>se",
				function()
					require("restful-search").search()
				end,
				desc = "Search API endpoints",
			},
			{
				"<leader>sE",
				function()
					require("restful-search").refresh()
				end,
				desc = "Refresh & search",
			},
		},
	},
}
