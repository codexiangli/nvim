return {
	{
		"pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup({
				enabled = true, -- 开启自动保存
				events = { "InsertLeave", "TextChanged" }, -- 触发保存的事件
			})
		end,
	},
}
