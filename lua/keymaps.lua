vim.g.mapleader = " "
-- define common options
local opts = {
	noremap = true, -- non-recursive
	silent = true, -- do not show message
}

-----------------
-- 通用快捷键（两个环境都生效）
-----------------

-- 插入模式光标移动
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")

-- Visual mode 缩进保持选区
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

if vim.g.vscode then
	-- ============================================
	-- Cursor/VSCode 环境快捷键
	-- ============================================
	local vscode = require("vscode")

	-- ---- Snacks Picker 风格快捷键 ----
	vim.keymap.set("n", "<leader><space>", function()
		vscode.action("workbench.action.quickOpen")
	end, { desc = "Smart find files" })
	vim.keymap.set("n", "<leader>sf", function()
		vscode.action("workbench.action.quickOpen")
	end, { desc = "Find files" })
	vim.keymap.set("n", "<leader>ff", function()
		vscode.action("workbench.action.quickOpen")
	end, { desc = "Find files" })
	vim.keymap.set("n", "<leader>sg", function()
		vscode.action("workbench.action.findInFiles")
	end, { desc = "Grep" })
	vim.keymap.set("n", "<leader>fg", function()
		vscode.action("workbench.action.findInFiles")
	end, { desc = "Live grep" })
	vim.keymap.set("n", "<leader>,", function()
		vscode.action("workbench.action.showAllEditors")
	end, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>sb", function()
		vscode.action("workbench.action.showAllEditors")
	end, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>fb", function()
		vscode.action("workbench.action.showAllEditors")
	end, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>sr", function()
		vscode.action("workbench.action.quickOpenPreviousRecentlyUsedEditor")
	end, { desc = "Recent files" })
	vim.keymap.set("n", "<leader>fr", function()
		vscode.action("workbench.action.quickOpenPreviousRecentlyUsedEditor")
	end, { desc = "Recent files" })
	vim.keymap.set("n", "<leader>sd", function()
		vscode.action("workbench.actions.view.problems")
	end, { desc = "Diagnostics" })
	vim.keymap.set("n", "<leader>ss", function()
		vscode.action("workbench.action.gotoSymbol")
	end, { desc = "LSP symbols" })
	vim.keymap.set("n", "<leader>sS", function()
		vscode.action("workbench.action.showAllSymbols")
	end, { desc = "Workspace symbols" })
	vim.keymap.set("n", "<leader>sk", function()
		vscode.action("workbench.action.openGlobalKeybindings")
	end, { desc = "Keymaps" })
	vim.keymap.set("n", "<leader>sc", function()
		vscode.action("workbench.action.showCommands")
	end, { desc = "Commands" })
	vim.keymap.set("n", "<leader>fh", function()
		vscode.action("workbench.action.showCommands")
	end, { desc = "Commands" })
	vim.keymap.set("n", "<leader>su", function()
		vscode.action("timeline.focus")
	end, { desc = "Undo/Timeline" })
	vim.keymap.set("n", "<leader>sp", function()
		vscode.action("workbench.action.openRecent")
	end, { desc = "Projects/Recent" })

	-- ---- 搜索结果导航 ----
	vim.keymap.set("n", "<C-n>", function()
		vscode.action("search.action.focusNextSearchResult")
	end, { desc = "Next search result" })
	vim.keymap.set("n", "<C-p>", function()
		vscode.action("search.action.focusPreviousSearchResult")
	end, { desc = "Prev search result" })

	-- ---- LSP 快捷键（使用 vscode.call 同步调用，更可靠）----
	vim.keymap.set("n", "gd", function()
		vscode.call("editor.action.revealDefinition")
	end, { desc = "Go to definition" })
	vim.keymap.set("n", "gD", function()
		vscode.call("editor.action.revealDeclaration")
	end, { desc = "Go to declaration" })
	vim.keymap.set("n", "gr", function()
		vscode.call("editor.action.goToReferences")
	end, { desc = "References" })
	vim.keymap.set("n", "gi", function()
		vscode.call("editor.action.goToImplementation")
	end, { desc = "Go to implementation" })
	vim.keymap.set("n", "gI", function()
		vscode.call("editor.action.goToImplementation")
	end, { desc = "Go to implementation" })
	vim.keymap.set("n", "gy", function()
		vscode.call("editor.action.goToTypeDefinition")
	end, { desc = "Go to type definition" })
	vim.keymap.set("n", "K", function()
		vscode.call("editor.action.showHover")
	end, { desc = "Hover" })
	vim.keymap.set("n", "<leader>rn", function()
		vscode.call("editor.action.rename")
	end, { desc = "Rename" })
	vim.keymap.set("n", "<leader>ca", function()
		vscode.call("editor.action.quickFix")
	end, { desc = "Code action" })
	vim.keymap.set("n", "<leader>lf", function()
		vscode.call("editor.action.formatDocument")
	end, { desc = "Format" })
	vim.keymap.set("n", "<C-S>", function()
		vscode.call("editor.action.triggerParameterHints")
	end, { desc = "Signature help" })
	vim.keymap.set("i", "<C-S>", function()
		vscode.call("editor.action.triggerParameterHints")
	end, { desc = "Signature help" })

	-- ---- 文件树 ----
	vim.keymap.set("n", "<leader>e", function()
		vscode.action("workbench.view.explorer")
	end, { desc = "File explorer" })

	-- ---- Buffer/Tab 操作 ----
	vim.keymap.set("n", "<A-h>", function()
		vscode.action("workbench.action.previousEditor")
	end, { desc = "Previous buffer" })
	vim.keymap.set("n", "<A-l>", function()
		vscode.action("workbench.action.nextEditor")
	end, { desc = "Next buffer" })
	vim.keymap.set("n", "<A-w>", function()
		vscode.action("workbench.action.closeActiveEditor")
	end, { desc = "Close buffer" })
	for i = 1, 9 do
		vim.keymap.set("n", "<A-" .. i .. ">", function()
			vscode.action("workbench.action.openEditorAtIndex" .. i)
		end, { desc = "Go to buffer " .. i })
	end

	-- ---- 窗口导航 ----
	vim.keymap.set("n", "<C-h>", function()
		vscode.action("workbench.action.focusLeftGroup")
	end, { desc = "Focus left group" })
	vim.keymap.set("n", "<C-j>", function()
		vscode.action("workbench.action.focusBelowGroup")
	end, { desc = "Focus below group" })
	vim.keymap.set("n", "<C-k>", function()
		vscode.action("workbench.action.focusAboveGroup")
	end, { desc = "Focus above group" })
	vim.keymap.set("n", "<C-l>", function()
		vscode.action("workbench.action.focusRightGroup")
	end, { desc = "Focus right group" })

	-- ---- 终端 ----
	vim.keymap.set({ "n", "t" }, "<A-i>", function()
		vscode.action("workbench.action.terminal.toggleTerminal")
	end, { desc = "Toggle terminal" })
	vim.keymap.set({ "n", "t" }, "<C-\\>", function()
		vscode.action("workbench.action.terminal.toggleTerminal")
	end, { desc = "Toggle terminal" })

	-- ---- Git ----
	vim.keymap.set("n", "<leader>ggl", function()
		vscode.action("git.viewHistory")
	end, { desc = "Git log" })
	vim.keymap.set("n", "<leader>ggb", function()
		vscode.action("gitlens.toggleLineBlame")
	end, { desc = "Git blame line" })
	vim.keymap.set("n", "<leader>ggB", function()
		vscode.action("gitlens.openFileOnRemote")
	end, { desc = "Git browse" })

	-- ---- Trouble 风格快捷键 ----
	vim.keymap.set("n", "<leader>xx", function()
		vscode.action("workbench.actions.view.problems")
	end, { desc = "Diagnostics" })
	vim.keymap.set("n", "<leader>xX", function()
		vscode.action("workbench.actions.view.problems")
	end, { desc = "Buffer diagnostics" })
	vim.keymap.set("n", "<leader>cs", function()
		vscode.action("outline.focus")
	end, { desc = "Symbols" })
	vim.keymap.set("n", "<leader>cl", function()
		vscode.action("editor.action.goToReferences")
	end, { desc = "LSP references" })

	-- ---- Cursor AI 专用 ----
	vim.keymap.set({ "n", "v" }, "<leader>ai", function()
		vscode.action("aipopup.action.modal.generate")
	end, { desc = "Cursor AI generate" })
	vim.keymap.set("n", "<leader>ac", function()
		vscode.action("workbench.action.chat.open")
	end, { desc = "Cursor AI chat" })

	-- ---- 退出/保存 ----
	vim.keymap.set({ "n", "x" }, "Q", function()
		vscode.action("workbench.action.closeAllEditors")
	end, { desc = "Close all" })
	vim.keymap.set({ "n", "x" }, "qq", function()
		vscode.action("workbench.action.closeActiveEditor")
	end, { desc = "Close editor" })

	-- ---- Zen Mode ----
	vim.keymap.set("n", "<leader>z", function()
		vscode.action("workbench.action.toggleZenMode")
	end, { desc = "Toggle Zen Mode" })

	-- ---- MyBatis: Mapper 接口 → XML 跳转 ----
	vim.keymap.set("n", "<leader>mx", function()
		vscode.action("mybatis-boost.jumpToXml")
	end, { desc = "Jump to Mapper XML" })

	-- ---- RestfulSearch: API 端点搜索 ----
	vim.keymap.set("n", "<leader>se", function()
		require("restful-search").search()
	end, { desc = "Search API endpoints" })
	vim.keymap.set("n", "<leader>sE", function()
		require("restful-search").refresh()
	end, { desc = "Refresh & search API endpoints" })
else
	-- ============================================
	-- 终端 Neovim 环境快捷键（保持原有配置）
	-- ============================================

	-- Better window navigation
	vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
	vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
	vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
	vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

	-- 自己添加的快捷键
	vim.keymap.set("n", "<F2>", ":set invpaste<CR>", { silent = true, noremap = true })

	vim.keymap.set({ "n", "x" }, "Q", "<CMD>:qa<CR>")
	vim.keymap.set({ "n", "x" }, "qq", "<CMD>:q<CR>")

	-- lua 运行
	vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
	vim.keymap.set("n", "<space>x", ":.lua<CR>")
	vim.keymap.set("v", "<space>x", ":lua<CR>")

	local bufopts = { noremap = true, silent = true }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-S>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)

	-- Resize with arrows
	-- delta: 2 lines
	vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
	vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
	vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
	vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)
end
