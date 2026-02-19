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
			-- Add or skip cursor above/below the main cursor.
			vim.keymap.set({ "n", "x" }, "<up>", function()
				mc.lineAddCursor(-1)
			end)
			vim.keymap.set({ "n", "x" }, "<down>", function()
				mc.lineAddCursor(1)
			end)
			vim.keymap.set({ "n", "x" }, "<leader><up>", function()
				mc.lineSkipCursor(-1)
			end)
			vim.keymap.set({ "n", "x" }, "<leader><down>", function()
				mc.lineSkipCursor(1)
			end)

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
