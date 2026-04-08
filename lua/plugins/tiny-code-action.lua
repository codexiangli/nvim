local picker = require("snacks.picker.core.picker")
return {
	-- TODO:configrure later when having an LSP with code actions
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{
				"folke/snacks.nvim",
				opts = {
					terminal = {},
				},
			},
		},
		event = "LspAttach",
		opts = {
			-- backend = "delta",
			bsckend = "vim",
			picker = "telescope",
			-- picker = "snacks",
			resolve_timeout = 1000, -- Timeout in milliseconds to resolve code actions

			-- Notification settings
			notify = {
				enabled = true, -- Enable/disable all notifications
				on_empty = true, -- Show notification when no code actions are found
			},

			-- Customize how action titles are displayed in the picker
			-- Function receives (action, client) and returns a formatted string
			-- Default: action.title
			format_title = nil,

			-- The icons to use for the code actions
			-- You can add your own icons, you just need to set the exact action's kind of the code action
			-- You can set the highlight like so: { link = "DiagnosticError" } or  like nvim_set_hl ({ fg ..., bg..., bold..., ...})
			signs = {
				quickfix = { "", { link = "DiagnosticWarning" } },
				others = { "", { link = "DiagnosticWarning" } },
				refactor = { "", { link = "DiagnosticInfo" } },
				["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
				["refactor.extract"] = { "", { link = "DiagnosticError" } },
				["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
				["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
				["source"] = { "", { link = "DiagnosticError" } },
				["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
				["codeAction"] = { "", { link = "DiagnosticWarning" } },
			},
		},
	},
}
