vim.g.mapleader = " "

if vim.g.vscode then
	-- ============================================
	-- Cursor/VSCode 环境
	-- ============================================
	require("options")
	require("keymaps")
	-- 加载 Cursor 专用轻量插件（flash、surround 等）
	require("config.lazy")
else
	-- ============================================
	-- 终端 Neovim 环境（保持原有配置不变）
	-- ============================================
	vim.o.winborder = "rounded"
	-- disable netrw at the very start of your init.lua
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	vim.opt.termguicolors = true
	vim.opt.jumpoptions = { "stack" }

	require("options")
	require("keymaps")
	-- require('plugins')
	require("config.lazy")
	require("colorscheme")
	-- require('lsp')
	require("custom")

	-- Snacks profiler
	if vim.env.PROF then
		-- example for lazy.nvim
		-- change this to the correct path for your plugin manager
		local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
		vim.opt.rtp:append(snacks)
		require("snacks.profiler").startup({
			startup = {
				event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
				-- event = "UIEnter",
				-- event = "VeryLazy",
			},
		})
	end
end
