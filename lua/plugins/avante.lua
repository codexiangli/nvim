return {
	{
		"yetone/avante.nvim",
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false,
		opts = {
			provider = "openrouter",
			providers = {
				openrouter = {
					__inherited_from = "openai",
					-- endpoint = "https://openrouter.ai/api/v1",
					endpoint = "https://openrouter.ai/api/v1",
					-- model = "google/gemini-2.5-flash",
					-- model = "anthropic/claude-sonnet-4.5",
					model = "anthropic/claude-opus-4.5",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 4096,
					},
				},
				gemini = {
					endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
					model = "gemini-2.5-pro",
					timeout = 30000,
					context_window = 1048576,
					use_ReAct_prompt = true,
					extra_request_body = {
						generationConfig = { temperature = 0.75 },
					},
				},
				claude = {
					endpoint = "https://api.anthropic.com",
					model = "claude-3-sonnet-20240229",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 4096,
					},
				},
				moonshot = {
					endpoint = "https://api.moonshot.ai/v1",
					model = "moonshot-v1-32k",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 4096,
					},
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"echasnovski/mini.pick",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			"ibhagwan/fzf-lua",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = { insert_mode = true },
						use_absolute_path = true,
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = { file_types = { "markdown", "Avante" } },
				ft = { "markdown", "Avante" },
			},
		},
	},
}
