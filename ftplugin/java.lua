-- Cursor/VSCode 环境不需要 nvim-jdtls，直接跳过
if vim.g.vscode then
	return
end

local jdtls = require("jdtls")
local home = os.getenv("HOME")
local mason_path = home .. "/.local/share/nvim/mason"

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
		"-javaagent:" .. lombok_jar,
		"-data",
		workspace_dir,
	},

	root_dir = root_dir,

	settings = {
		java = {
			-- 让 gd 优先跳转到 .java 源码而不是 .class
			contentProvider = { preferred = "fernflower" },

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

			-- 代码补全
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
			},

			-- 源码操作
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},

			-- 引用和实现的代码透镜
			referencesCodeLens = { enabled = true },
			implementationsCodeLens = { enabled = true },

			-- 格式化
			format = {
				enabled = true,
			},

			-- 签名帮助
			signatureHelp = { enabled = true },

			-- 配置运行时（支持多版本 JDK）
			configuration = {
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

	init_options = {
		bundles = {},
	},
}

jdtls.start_or_attach(config)
