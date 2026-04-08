-- Cursor/VSCode 环境不需要 nvim-jdtls 和 Java Creator，直接跳过
if vim.g.vscode then
	return
end

-- ================================
-- Java Creator 插件配置
-- ================================
-- 检查插件是否可用
local ok, java_creator = pcall(require, "java-creator")
if ok then
	-- 配置插件
	java_creator.setup({
		picker = "snacks", -- 使用 snacks 选择器
		author = nil, -- 使用 git config 中的作者
		keymaps = false, -- 禁用插件默认快捷键，在这里手动设置
		templates = {
			class = {
				extends = nil, -- 可配置默认继承
				implements = {}, -- 可配置默认实现接口
			},
			interface = {
				extends = {}, -- 可配置默认继承接口
			},
		},
		auto_imports = {
			test = {
				"org.junit.jupiter.api.Test",
				"org.junit.jupiter.api.BeforeEach",
				"org.junit.jupiter.api.DisplayName",
			},
			annotation = {
				"java.lang.annotation.ElementType",
				"java.lang.annotation.Retention",
				"java.lang.annotation.RetentionPolicy",
				"java.lang.annotation.Target",
			},
		},
	})

	-- 设置 Java 文件专用的快捷键
	vim.keymap.set("n", "<leader>jc", java_creator.create_class, {
		buffer = true,
		desc = "Create Java class",
	})

	vim.keymap.set("n", "<leader>jo", java_creator.create_with_picker, {
		buffer = true,
		desc = "Create Java file (with type picker)",
	})

	vim.keymap.set("n", "<leader>jt", java_creator.create_test, {
		buffer = true,
		desc = "Create Java test class",
	})

	vim.keymap.set("n", "<leader>ji", java_creator.create_interface, {
		buffer = true,
		desc = "Create Java interface",
	})

	vim.keymap.set("n", "<leader>je", java_creator.create_enum, {
		buffer = true,
		desc = "Create Java enum",
	})

	vim.keymap.set("n", "<leader>ja", java_creator.create_abstract_class, {
		buffer = true,
		desc = "Create Java abstract class",
	})

	vim.keymap.set("n", "<leader>jr", java_creator.create_record, {
		buffer = true,
		desc = "Create Java record",
	})

	vim.keymap.set("n", "<leader>j@", java_creator.create_annotation, {
		buffer = true,
		desc = "Create Java annotation",
	})
end

-- ================================
-- JDTLS 配置（原有配置保持不变）
-- ================================

local jdtls = require("jdtls")
local home = os.getenv("HOME")
local mason_path = home .. "/.local/share/nvim/mason"

-- 指定 jdtls 使用的 JDK（eclipse.jdt.ls 需 Java 17+，推荐 21）；系统默认换成 1.8 时避免 jdtls 报错
-- 可在 init.lua 里用 vim.g.jdtls_java_home = "/path/to/jdk21" 覆盖
local jdtls_java_home = vim.g.jdtls_java_home or "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
vim.env.JAVA_HOME = jdtls_java_home

-- 项目根目录：优先 .git 避免被子模块 pom.xml 截断
local root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" })
	or vim.fs.root(0, { "pom.xml", "build.gradle" })
	or vim.fn.getcwd()

-- 每个项目独立的 workspace 数据目录（避免索引冲突）
local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

-- Lombok 支持
local lombok_jar = mason_path .. "/packages/jdtls/lombok.jar"

local config = {
	name = "jdtls",

	cmd = {
		mason_path .. "/bin/jdtls",
		"-Xms6G",
		"-Xmx8G",
		"-javaagent:" .. lombok_jar,
		"-data",
		workspace_dir,
	},

	root_dir = root_dir,

	settings = {
		java = {
			-- 让 gd 优先跳转到 .java 源码而不是 .class
			contentProvider = { preferred = "fernflower" },

			-- Setup automatical package import oranization on file save
			saveActions = {
				organizeImports = false,
			},

			-- Maven 支持
			import = {
				maven = { enabled = true },
			},
			maven = {
				downloadSources = true,
			},

			-- 源码下载（让 gd 能跳到依赖库的源码）
			eclipse = {
				downloadSources = true,
			},
			inlayHints = { parameterNames = { enabled = "all" } },

			-- 代码补全
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				-- Try not to suggest imports from these packages in the code action window
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org",
				},
			},

			-- 源码操作
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},

			-- How should different pieces of code be generated?
			codeGeneration = {
				-- When generating toString use a json format
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				-- When generating hashCode and equals methods use the java 7 objects method
				hashCodeEquals = {
					useJava7Objects = true,
				},
				-- When generating code use code blocks
				useBlocks = true,
			},

			-- 引用和实现的代码透镜
			referencesCodeLens = { enabled = true },
			implementationsCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },

			-- 排除编译产物目录，减少索引量
			project = {
				resourceFilters = {
					"**/target/**",
					"**/build/**",
					"**/node_modules/**",
					"**/.git/**",
					"**/out/**",
				},
			},

			-- 格式化
			format = {
				enabled = true,
				settings = {
					url = vim.fn.stdpath("config") .. "/lang-servers/intellij-rere-java-style.xml",
					profile = "ATRenew",
				},
			},

			-- 签名帮助
			signatureHelp = { enabled = true },

			-- 配置运行时（支持多版本 JDK）
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home",
						default = false,
					},
					{
						name = "JavaSE-11",
						path = "/Library/Java/JavaVirtualMachines/jdk-11.jdk/Contents/Home",
						default = false,
					},
					{
						name = "JavaSE-21",
						path = "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home",
						default = true,
					},
				},
			},
		},
	},

	-- -- Function that will be ran once the language server is attached
	-- on_attach = function(_, bufnr)
	-- 	-- local ts_indent = require("nvim-treesitter.indent")
	-- 	-- ts_indent.detach(bufnr)
	-- 	-- Enable jdtls commands to be used in Neovim
	-- 	vim.lsp.codelens.refresh()
	--
	-- 	-- Setup a function that automatically runs every time a java file is saved to refresh the code lens
	-- 	vim.api.nvim_create_autocmd("BufWritePost", {
	-- 		pattern = { "*.java" },
	-- 		callback = function()
	-- 			local _, _ = pcall(vim.lsp.codelens.refresh)
	-- 		end,
	-- 	})
	-- end,

	flags = {
		allow_incremental_sync = true,
	},

	init_options = {
		bundles = {},
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	},
}

-- 1) 包装全局 definition 处理器：无论谁触发 gd（Snacks/默认），jdtls 返回的 jdt:// 与 file:// 都由这里统一处理
if not vim.g._jdtls_definition_handler_wrapped then
	vim.g._jdtls_definition_handler_wrapped = true
	local orig = vim.lsp.handlers["textDocument/definition"]
	vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
		if err or not result or vim.tbl_isempty(result) then
			if orig then
				return orig(err, result, ctx, config)
			end
			return
		end
		local loc = result[1]
		local uri = loc.uri or loc.targetUri
		local range = loc.range or loc.targetRange or loc.targetSelectionRange
		if not uri then
			if orig then
				return orig(err, result, ctx, config)
			end
			return
		end
		local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id)
		-- 仅对 jdtls 做特殊处理：jdt:// 用 :edit 打开，file:// 用 jump_to_location
		if client and client.name == "jdtls" then
			if uri:match("^jdt://") then
				vim.cmd("edit " .. vim.fn.fnameescape(uri))
				if range and range.start then
					local jdt_buf = vim.api.nvim_get_current_buf()
					local target_line = range.start.line + 1
					local target_col = range.start.character
					vim.schedule(function()
						-- jdt 内容由 nvim-jdtls 异步拉取，需等 buffer 有足够行再设光标，避免 "Cursor position outside buffer"
						vim.wait(3000, function()
							return not vim.api.nvim_buf_is_valid(jdt_buf)
								or vim.api.nvim_buf_line_count(jdt_buf) >= target_line
						end, 30)
						if not vim.api.nvim_buf_is_valid(jdt_buf) then
							return
						end
						local line_count = vim.api.nvim_buf_line_count(jdt_buf)
						if line_count < target_line then
							return
						end
						local win = vim.fn.bufwinid(jdt_buf)
						if win and win > 0 then
							local line_len = #(
								vim.api.nvim_buf_get_lines(jdt_buf, target_line - 1, target_line, false)[1] or ""
							)
							local col = math.min(target_col, math.max(0, line_len))
							pcall(vim.api.nvim_win_set_cursor, win, { target_line, col })
							vim.api.nvim_set_current_win(win)
							vim.cmd("normal! zz")
						end
					end)
				end
				return
			end
			-- file:// 统一成 Location 再跳
			local ok = pcall(vim.lsp.util.jump_to_location, { uri = uri, range = range or {} })
			if ok then
				return
			end
		end
		if orig then
			return orig(err, result, ctx, config)
		end
		pcall(vim.lsp.util.jump_to_location, loc)
	end
end

-- 2) Java 内 gd 自己发 definition 请求并在回调里跳转，避免触发 buf.lua 的 on_response（否则 jdt:// 会报 Cursor position outside buffer）
local function do_jump(loc)
	local uri = loc.uri or loc.targetUri
	local range = loc.range or loc.targetRange or loc.targetSelectionRange
	if not uri then
		return
	end
	if uri:match("^jdt://") then
		vim.cmd("edit " .. vim.fn.fnameescape(uri))
		if range and range.start then
			local jdt_buf = vim.api.nvim_get_current_buf()
			local target_line = range.start.line + 1
			local target_col = range.start.character
			vim.schedule(function()
				vim.wait(3000, function()
					return not vim.api.nvim_buf_is_valid(jdt_buf) or vim.api.nvim_buf_line_count(jdt_buf) >= target_line
				end, 30)
				if not vim.api.nvim_buf_is_valid(jdt_buf) then
					return
				end
				local line_count = vim.api.nvim_buf_line_count(jdt_buf)
				if line_count < target_line then
					return
				end
				local win = vim.fn.bufwinid(jdt_buf)
				if win and win > 0 then
					local line_len = #(
						vim.api.nvim_buf_get_lines(jdt_buf, target_line - 1, target_line, false)[1] or ""
					)
					local col = math.min(target_col, math.max(0, line_len))
					pcall(vim.api.nvim_win_set_cursor, win, { target_line, col })
					vim.api.nvim_set_current_win(win)
					vim.cmd("normal! zz")
				end
			end)
		end
		return
	end
	-- file:// 手动打开并定位，避免 jump_to_location 在 0.11 下对单参/range 行为异常
	local path = vim.uri_to_fname(uri)
	if path and path ~= "" then
		vim.cmd("edit " .. vim.fn.fnameescape(path))
		if range and range.start then
			local target_line = range.start.line + 1
			local target_col = range.start.character
			vim.schedule(function()
				local cur_buf = vim.api.nvim_get_current_buf()
				local line_count = vim.api.nvim_buf_line_count(cur_buf)
				if target_line <= line_count then
					local line_len = #(
						vim.api.nvim_buf_get_lines(cur_buf, target_line - 1, target_line, false)[1] or ""
					)
					local col = math.min(target_col, math.max(0, line_len))
					vim.api.nvim_win_set_cursor(0, { target_line, col })
					vim.cmd("normal! zz")
				end
			end)
		end
	else
		pcall(vim.lsp.util.jump_to_location, { uri = uri, range = range or {} })
	end
end

local function java_gd()
	local buf, params
	local ok = pcall(function()
		local win = vim.api.nvim_get_current_win()
		buf = vim.api.nvim_win_get_buf(win)
		local pos = vim.api.nvim_win_get_cursor(win)
		params = {
			textDocument = { uri = vim.uri_from_bufnr(buf) },
			position = { line = pos[1] - 1, character = pos[2] },
		}
	end)
	if not ok or not buf or not params then
		vim.lsp.buf.definition()
		return
	end
	vim.lsp.buf_request(buf, "textDocument/definition", params, function(err, result)
		if err or not result or vim.tbl_isempty(result) then
			vim.lsp.buf.definition()
			return
		end
		do_jump(result[1])
	end)
end
local function bind_gd_late(buf)
	vim.defer_fn(function()
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end
		vim.keymap.set("n", "gd", java_gd, {
			buffer = buf,
			noremap = true,
			silent = true,
			desc = "Go to definition (Java + JAR)",
		})
	end, 50)
end

jdtls.start_or_attach(config)

vim.keymap.set(
	"n",
	"gd",
	java_gd,
	{ buffer = true, noremap = true, silent = true, desc = "Go to definition (Java + JAR)" }
)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("java_gd_jdtls", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client or client.name ~= "jdtls" then
			return
		end
		vim.keymap.set(
			"n",
			"gd",
			java_gd,
			{ buffer = args.buf, noremap = true, silent = true, desc = "Go to definition (Java + JAR)" }
		)
		bind_gd_late(args.buf)
	end,
})
-- 进入 Java 文件时延迟再绑一次，确保覆盖 Snacks 的 gd
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("java_gd_bufenter", { clear = true }),
	pattern = "*.java",
	callback = function(args)
		bind_gd_late(args.buf)
	end,
})

-- Java 专用快捷键
-- 多模块项目刷新（自动刷新所有模块）
vim.keymap.set("n", "<leader>ju", function()
	jdtls.update_projects_config({ select_mode = "all" })
end, { buffer = true, desc = "Update all modules config" })

-- 复制 完整包名.类名.方法名 到剪贴板
vim.keymap.set("n", "<leader>cy", function()
	-- 获取包名（从 package 声明）
	local package_name = ""
	local class_name = ""
	local lines = vim.api.nvim_buf_get_lines(0, 0, 100, false) -- 检查前100行

	for _, line in ipairs(lines) do
		-- 获取包名
		if package_name == "" then
			local pkg = line:match("^%s*package%s+([%w%.]+)%s*;")
			if pkg then
				package_name = pkg
			end
		end

		-- 获取类名（从 class/interface 声明）
		if class_name == "" then
			local cls = line:match("class%s+([%w]+)") or line:match("interface%s+([%w]+)")
			if cls then
				class_name = cls
			end
		end

		-- 都找到了就退出
		if package_name ~= "" and class_name ~= "" then
			break
		end
	end

	-- 如果没找到类名，从文件名获取
	if class_name == "" then
		class_name = vim.fn.expand("%:t:r")
		-- 处理 JAR 文件中的特殊格式
		class_name = class_name:gsub("%%3C.*", "") -- 移除 %3C 后面的内容
		class_name = class_name:gsub("%(.*", "") -- 移除括号及后面的内容
	end

	-- 使用 treesitter 获取当前光标所在的方法名
	local node = vim.treesitter.get_node()
	while node do
		local node_type = node:type()
		if node_type == "method_declaration" or node_type == "interface_method_declaration" then
			-- 找到方法名节点
			for child in node:iter_children() do
				local child_type = child:type()
				if child_type == "identifier" or child_type == "name" then
					local method_name = vim.treesitter.get_node_text(child, 0)
					local result = package_name .. "." .. class_name .. "." .. method_name
					vim.fn.setreg("+", result)
					vim.notify("Copied: " .. result, vim.log.levels.INFO)
					return
				end
			end
		end
		node = node:parent()
	end

	-- 如果没找到方法，只复制 包名.类名
	local result = package_name .. "." .. class_name
	vim.fn.setreg("+", result)
	vim.notify("Copied: " .. result .. " (no method found)", vim.log.levels.INFO)
end, { buffer = true, desc = "Copy full.package.ClassName.methodName" })

vim.keymap.set("n", "<leader>oi", function()
	jdtls.organize_imports()
end, { buffer = true, desc = "Organize imports" })
vim.keymap.set("n", "<leader>jv", function()
	jdtls.extract_variable()
end, { buffer = true, desc = "Extract variable" })
vim.keymap.set("n", "<leader>jm", function()
	jdtls.extract_method()
end, { buffer = true, desc = "Extract method" })
