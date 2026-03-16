return {
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		event = "BufReadPost",
		keys = {
			-- Append/insert for each line of visual selections. Similar to block selection insertion.
			{
				"mI",
				function()
					require("multicursor-nvim").insertVisual()
				end,
				mode = "x",
				desc = "Insert cursors at visual selection",
			},
			{
				"mA",
				function()
					require("multicursor-nvim").appendVisual()
				end,
				mode = "x",
				desc = "Append cursors at visual selection",
			},
		},
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()
			-- Add cursor above/below the main cursor (使用 leader 组合，不影响正常方向键)
			vim.keymap.set({ "n", "x" }, "<leader><up>", function()
				mc.lineAddCursor(-1)
			end, { desc = "Add cursor up" })
			vim.keymap.set({ "n", "x" }, "<leader><down>", function()
				mc.lineAddCursor(1)
			end, { desc = "Add cursor down" })
			-- Skip current line (使用 Ctrl 组合)
			vim.keymap.set({ "n", "x" }, "<leader><C-up>", function()
				mc.lineSkipCursor(-1)
			end, { desc = "Skip cursor up" })
			vim.keymap.set({ "n", "x" }, "<leader><C-down>", function()
				mc.lineSkipCursor(1)
			end, { desc = "Skip cursor down" })

			-- Mappings defined in a keymap layer only apply when there are multiple cursors. This lets you have overlapping mappings.
			mc.addKeymapLayer(function(layerSet)
				-- Enable and clear cursors using escape.
				layerSet("n", "<esc>", function()
					mc.clearCursors()
				end)
			end)
		end,
	},
}
