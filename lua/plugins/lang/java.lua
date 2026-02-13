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

	{
		"codexiangli/mapper-jump.nvim",
		config = function()
			vim.keymap.set("n", "<leader>mx", function()
				require("mapper-jump").jump_to_xml()
			end, { desc = "Jump to Mapper XML" })
			-- Mapper.xml 内 gd 跳回 Mapper 接口（仅 *Mapper.xml buffer）
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*Mapper.xml",
				callback = function()
					vim.keymap.set("n", "gd", function()
						require("mapper-jump").jump_to_java()
					end, { buffer = true, noremap = true, silent = true, desc = "Jump to Mapper interface" })
				end,
			})
		end,
	},
}
