# Cursor + Neovim 配置指南

## 概述

本配置实现了在 Cursor 编辑器中嵌入 Neovim 编辑引擎，保留 Vim 键位习惯的同时使用 Cursor 的 AI 能力。同一份 Neovim 配置同时支持终端 Neovim 和 Cursor 两个环境，通过 `vim.g.vscode` 条件判断实现分流。

## 前提条件

- Neovim >= 0.9.0（推荐 0.11+）
- Cursor 编辑器
- macOS（其他平台需调整路径）

```bash
# 安装 Neovim
brew install neovim

# 验证
nvim --version
```

## 架构设计

```
~/.config/nvim/
├── init.lua                    ← 入口：vim.g.vscode 条件分流
├── lua/
│   ├── options.lua             ← 通用选项（两环境共享）
│   ├── keymaps.lua             ← 快捷键（两套映射）
│   ├── config/
│   │   └── lazy.lua            ← lazy.nvim 条件加载插件
│   └── plugins/
│       ├── restful-search.lua  ← restful-search.nvim 插件配置
│       ├── restful-search-nvim/← 自制插件源码
│       ├── flash.lua           ← 两环境都加载
│       ├── vim-surround.lua    ← 两环境都加载
│       ├── vim-commentary.lua  ← 两环境都加载
│       ├── better-escape.lua   ← 两环境都加载
│       ├── nvim-autopairs.lua  ← 两环境都加载
│       ├── smartyank.lua       ← 两环境都加载
│       └── ...                 ← 其他插件（仅终端 Neovim）
└── ftplugin/
    └── java.lua                ← jdtls 配置（仅终端 Neovim）
```

## 一、Neovim 配置改造

### 1.1 init.lua — 条件分流

核心思路：`vim.g.vscode` 在 Cursor 环境中为 `true`。

```lua
vim.g.mapleader = " "

if vim.g.vscode then
    -- Cursor 环境：只加载基础配置和轻量插件
    require("options")
    require("keymaps")
    require("config.lazy")
else
    -- 终端 Neovim：加载完整配置
    require("options")
    require("keymaps")
    require("config.lazy")
    require("colorscheme")
    require("custom")
end
```

### 1.2 config/lazy.lua — 条件加载插件

Cursor 环境只加载纯编辑增强插件（不需要 UI 渲染的）：

```lua
local spec
if vim.g.vscode then
    spec = {
        { import = "plugins.flash" },          -- 快速跳转 (s/S)
        { import = "plugins.vim-surround" },   -- 环绕操作 (cs/ds/ys)
        { import = "plugins.vim-commentary" }, -- 注释 (gcc/gc)
        { import = "plugins.better-escape" },  -- jk/kj 退出插入模式
        { import = "plugins.nvim-autopairs" }, -- 自动括号
        { import = "plugins.smartyank" },      -- 智能复制
        { import = "plugins.restful-search" }, -- API 端点搜索
    }
else
    spec = {
        { import = "plugins" },
        { import = "plugins.lang" },
    }
end
```

### 1.3 keymaps.lua — 快捷键映射

#### 通用快捷键（两环境共享）

| 快捷键 | 功能 |
|--------|------|
| `<C-h/j/k/l>` (Insert) | 插入模式光标移动 |
| `<` / `>` (Visual) | 缩进保持选区 |

#### Cursor 环境快捷键

所有快捷键通过 `require("vscode").action()` 或 `require("vscode").call()` 调用 VSCode 命令。

**搜索类（Snacks Picker 风格）**

| 快捷键 | 功能 | VSCode 命令 |
|--------|------|-------------|
| `<leader><space>` | 智能文件搜索 | `workbench.action.quickOpen` |
| `<leader>ff` / `<leader>sf` | 查找文件 | `workbench.action.quickOpen` |
| `<leader>fg` / `<leader>sg` | 全局搜索 | `workbench.action.findInFiles` |
| `<leader>,` / `<leader>sb` / `<leader>fb` | Buffer 列表 | `workbench.action.showAllEditors` |
| `<leader>fr` / `<leader>sr` | 最近文件 | `workbench.action.quickOpenPreviousRecentlyUsedEditor` |
| `<leader>sd` | 诊断 | `workbench.actions.view.problems` |
| `<leader>ss` | LSP 符号 | `workbench.action.gotoSymbol` |
| `<leader>sS` | 工作区符号 | `workbench.action.showAllSymbols` |
| `<leader>sk` | 快捷键 | `workbench.action.openGlobalKeybindings` |
| `<leader>sc` / `<leader>fh` | 命令面板 | `workbench.action.showCommands` |
| `<leader>sp` | 项目/最近 | `workbench.action.openRecent` |
| `<leader>su` | 时间线 | `timeline.focus` |
| `<leader>se` | API 端点搜索 | restful-search.nvim |
| `<leader>sE` | 刷新 API 端点 | restful-search.nvim |

**LSP 类**

| 快捷键 | 功能 | VSCode 命令 |
|--------|------|-------------|
| `gd` | 跳转定义 | `editor.action.revealDefinition` |
| `gD` | 跳转声明 | `editor.action.revealDeclaration` |
| `gr` | 查看引用 | `editor.action.goToReferences` |
| `gi` | 跳转实现 | `editor.action.goToImplementation` |
| `gy` | 跳转类型定义 | `editor.action.goToTypeDefinition` |
| `K` | 悬停信息 | `editor.action.showHover` |
| `<leader>rn` | 重命名 | `editor.action.rename` |
| `<leader>ca` | 代码操作 | `editor.action.quickFix` |
| `<leader>lf` | 格式化 | `editor.action.formatDocument` |

**导航类**

| 快捷键 | 功能 |
|--------|------|
| `<C-h>` | 编辑器 → 左侧边栏 |
| `<C-l>` | 编辑器 → 右侧边栏 |
| `<C-j>` | 编辑器 → 底部面板 |
| `<C-k>` | 编辑器 → 上方编辑组 |
| `<A-h>` / `<A-l>` | 上一个/下一个标签页 |
| `<A-1>` ~ `<A-9>` | 跳转到第 N 个标签页 |
| `<A-w>` | 关闭当前标签页 |
| `<A-i>` / `<C-\>` | 切换终端 |
| `<leader>e` | 文件浏览器 |
| `Ctrl+N` / `Ctrl+P` | 搜索结果导航 |

**其他**

| 快捷键 | 功能 |
|--------|------|
| `<leader>ai` | Cursor AI 生成 |
| `<leader>ac` | Cursor AI 聊天 |
| `<leader>mx` | Mapper 接口 → XML（MyBatis Boost） |
| `<leader>xx` | 诊断面板（Trouble 风格） |
| `<leader>cs` | 大纲符号 |
| `<leader>z` | Zen Mode |
| `Q` | 关闭所有编辑器 |
| `qq` | 关闭当前编辑器 |

### 1.4 ftplugin/java.lua — jdtls 配置（仅终端 Neovim）

关键配置项：

- `root_dir`：优先 `.git`，避免多模块项目被子模块 `pom.xml` 截断
- `-javaagent:lombok.jar`：启用 Lombok 支持
- `-data workspace_dir`：每个项目独立的索引目录
- `contentProvider = "fernflower"`：`gd` 优先跳转 `.java` 源码
- `downloadSources = true`：自动下载依赖源码
- `configuration.runtimes`：JDK 8/11/21 多版本支持

## 二、Cursor keybindings.json 配置

### 2.1 滚动

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Ctrl+D` | 向下半页 | 覆盖 VSCode 默认的多光标选择 |
| `Ctrl+U` | 向上半页 | |
| `Ctrl+F` | 向下一页 | 覆盖 VSCode 默认的查找 |
| `Ctrl+B` | 向上一页 | |
| `Ctrl+E` | 向下滚动 3 行 | 覆盖 VSCode 默认的 Quick Open |
| `Ctrl+Y` | 向上滚动 3 行 | 覆盖 VSCode 默认的 Redo |

### 2.2 跳转列表

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+O` | 导航后退 |
| `Ctrl+I` | 导航前进 |

### 2.3 全局窗口导航

从编辑器出发：

| 快捷键 | 目标 |
|--------|------|
| `Ctrl+H` | 左侧边栏 |
| `Ctrl+L` | 右侧边栏 |
| `Ctrl+J` | 底部面板 |
| `Ctrl+K` | 上方编辑组 |

从非编辑器区域出发：

| 快捷键 | 目标 |
|--------|------|
| `Ctrl+L` | 回到编辑器 |
| `Ctrl+K` | 回到编辑器 |
| `Ctrl+H` | 侧边栏 |
| `Ctrl+J` | 底部面板 |

### 2.4 Alt 系列

| 快捷键 | 功能 |
|--------|------|
| `Alt+H` / `Alt+L` | 上/下一个标签页 |
| `Alt+1` ~ `Alt+9` | 跳转到第 N 个标签页 |
| `Alt+W` | 关闭当前标签页 |
| `Alt+I` | 切换终端 |

### 2.5 搜索增强

| 快捷键 | 上下文 | 功能 |
|--------|--------|------|
| `Enter` | 搜索输入框 | 聚焦搜索结果列表 |
| `Ctrl+N` | 搜索结果列表 | 选中下一个（不跳转） |
| `Ctrl+P` | 搜索结果列表 | 选中上一个（不跳转） |

### 2.6 其他

| 快捷键 | 功能 |
|--------|------|
| `Tab` | 在有 AI 建议时接受（Cursor Super Tab） |
| `Cmd+B` | 切换侧边栏 |
| `Ctrl+Shift+N` | 重启 Neovim |
| `Ctrl+Shift+M` | 停止 Neovim |

## 三、Cursor settings.json 关键配置

```json
{
    // Neovim 路径
    "vscode-neovim.neovimExecutablePaths.darwin": "/opt/homebrew/bin/nvim",
    
    // 编辑器行为
    "editor.scrolloff": 10,
    "editor.lineNumbers": "relative",
    "editor.cursorSurroundingLines": 10,

    // 多结果跳转：弹浮窗预览
    "editor.gotoLocation.multipleDefinitions": "peek",
    "editor.gotoLocation.multipleImplementations": "peek",
    "editor.gotoLocation.multipleReferences": "peek",

    // Peek View 浮窗样式（Catppuccin Mocha 风格半透明）
    "workbench.colorCustomizations": {
        "[Catppuccin Mocha]": {
            "peekView.border": "#cba6f7aa",
            "peekViewEditor.background": "#313244c0",
            "peekViewResult.background": "#313244c0",
            "peekViewTitle.background": "#313244c0"
        }
    },

    // MyBatis Boost（不使用 Definition Provider，避免 gd 出现双结果）
    "mybatis-boost.useDefinitionProvider": false,

    // Lua Language Server（替代 neodev）
    "Lua.runtime.version": "LuaJIT",
    "Lua.workspace.library": ["/opt/homebrew/share/nvim/runtime/lua"],
    "Lua.diagnostics.globals": ["vim"],

    // StyLua 格式化
    "[lua]": {
        "editor.defaultFormatter": "JohnnyMorganz.stylua",
        "editor.formatOnSave": true
    }
}
```

## 四、推荐安装的 Cursor 扩展

| 扩展 | 用途 |
|------|------|
| `asvetliakov.vscode-neovim` | Neovim 集成 |
| `Catppuccin.catppuccin-vsc` | 主题（和终端 Neovim 一致） |
| `redhat.java` + Java Extension Pack | Java 语言支持 |
| `young1lin.mybatis-boost` | MyBatis Mapper ↔ XML 跳转 |
| `JohnnyMorganz.stylua` | Lua 格式化 |
| `sumneko.lua` | Lua Language Server |
