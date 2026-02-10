return {

	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "java" },
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"williamboman/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				"jdtls",
			},
		},
		opts_extend = { "ensure_installed" },
	},

	-- Java (jdtls) specific configuration
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		dependencies = { "neovim/nvim-lspconfig" },
		-- config = function()
		--   local lsp_utils = require('lsp')
		--   local jdtls = require('jdtls')
		--   jdtls.start_or_attach({
		--     cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/jdtls') },
		--     root_dir = jdtls.setup.find_root({'gradlew', '.git', 'mvnw'}),
		--     on_attach = lsp_utils.on_attach,
		--     capabilities = lsp_utils.capabilities,
		--   })
		-- end,
	},
}
