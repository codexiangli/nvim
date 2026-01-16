-- lazy.nvim 启动代码
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 插件配置
require("lazy").setup({
  -- 主题
  { "tanvirtin/monokai.nvim", lazy = false, priority = 1000 },

  -- LSP
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },

  -- 补全
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip'
    },
    config = function() require('config.nvim-cmp') end
  },

  -- Telescope 配置
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = { height = 0.95 },
        }
      })
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {})
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {})
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, {})
    end
  },

  -- nvim-tree 配置
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({ view = { width = 35 } })
      vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>')
    end
  },

  -- 状态栏配置
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "monokai",
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            'filename',
            {
              function() return vim.o.paste and 'PASTE' or '' end,
              color = { fg = '#ff5555' },
              padding = { left = 1, right = 0 },
            }
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
      })
    end
  },

  -- Treesitter 配置
--  {
--    "nvim-treesitter/nvim-treesitter",
--    build = ":TSUpdate",
--    opts = {
--      ensure_installed = {
--        "lua", "python", "javascript", "typescript", "html", "css",
--        "json", "yaml", "markdown", "bash", "java", "kotlin",
--      },
--      highlight = { enable = true },
--      indent = { enable = true },
--      incremental_selection = {
--        enable = true,
--        keymaps = {
--          init_selection = "gnn",
--          node_incremental = "grn",
--          scope_incremental = "grc",
--          node_decremental = "grm",
--        },
--      },
--    },
--    config = function(_, opts)
--      require("nvim-treesitter.configs").setup(opts)
--    end,
--  },
--
  --  ============ 界面增强 ================

  -- 启动界面
  { "goolord/alpha-nvim" },

  -- 滚动条
  { "petertriho/nvim-scrollbar" },

  -- 缩进线
  { "lukas-reineke/indent-blankline.nvim" },

  -- 彩虹括号
  { "HiPhish/rainbow-delimiters.nvim" },

  -- ============ 编辑增强 ================
  -- 快速注释
  {
    "tpope/vim-commentary",
    config = function()
      vim.keymap.set('n', 'gcc', ':Commentary<CR>')
      vim.keymap.set('v', 'gc', ':Commentary<CR>')
    end
    },

  -- ================  版本控制工具 =============
  -- Git 状态显示
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        }
      })
    end
  },
  -- Git 操作界面
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set('n', '<leader>gs', ':Git<CR>')
      vim.keymap.set('n', '<leader>gc', ':Git commit<CR>')
      vim.keymap.set('n', '<leader>gp', ':Git push<CR>')
    end
  }

})
