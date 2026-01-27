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
    {
        "loctvl842/monokai-pro.nvim",
        name = "monokai-pro",
        lazy = true,
        priority = 1000,
        opts = {
            variant = "pro",
            transparent_background = false,
        },
        config = function(_, opts)
            require("monokai-pro").setup(opts)
        end,
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },


    {
        "folke/neodev.nvim",
        opts = {},
        config = function()
            require("neodev").setup({
                -- add any options here, or leave empty to use the default settings
            })
        end
    },

    -- LSP Core & Setup
    { "neovim/nvim-lspconfig" },


    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        -- config = function()
        --   local lsp_config = require('lspconfig')
        --   require("mason-lspconfig").setup({
        --     ensure_installed = { 'pylsp', 'pyright', 'lua_ls', 'rust_analyzer', 'kotlin_language_server', 'jdtls' },
        --     handlers = {
        --       -- Default handler for all servers EXCEPT jdtls
        --       function(server_name)
        --         if server_name == 'jdtls' then return end -- Skip jdtls, it's handled by nvim-jdtls
        --         require("lspconfig")[server_name].setup({
        --           on_attach = lsp_config.on_attach,
        --           capabilities = lsp_config.capabilities,
        --         })
        --       end,
        --       ["pyright"] = function()
        --           require("lspconfig").pyright.setup({
        --               on_attach = lsp_config.on_attach,
        --               capabilities = lsp_config.capabilities,
        --               filetypes = {"python"},
        --           })
        --       end,
        --       ["pylsp"] = function()
        --         require("lspconfig").pylsp.setup({
        --           on_attach = lsp_config.on_attach,
        --           capabilities = lsp_config.capabilities,
        --           settings = {
        --             pylsp = {
        --               plugins = {
        --                 pycodestyle = {
        --                   ignore = {"W391"},
        --                   maxLineLength = 100,
        --                 },
        --               },
        --             },
        --           },
        --         })
        --       end,
        --     },
        --   })
        -- end,
    },

    -- Java (jdtls) specific configuration
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
        dependencies = { 'neovim/nvim-lspconfig' },
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
            require("nvim-tree").setup(
                {
                    view = { width = 35 }
                }
            )
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
                    theme = "kanagawa",
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
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
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "lua", "python", "json", "yaml", "markdown", "bash", "java", "kotlin",
            },
            sync_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
        end,
    },

    --  ============ 界面增强 ================
    { "goolord/alpha-nvim" },
    { "petertriho/nvim-scrollbar" },
    { "lukas-reineke/indent-blankline.nvim" },
    { "HiPhish/rainbow-delimiters.nvim" },

    -- ============ 编辑增强 ================
    {
        "tpope/vim-commentary",
        config = function()
            vim.keymap.set('n', 'gcc', ':Commentary<CR>')
            vim.keymap.set('v', 'gc', ':Commentary<CR>')
        end
    },

    -- 环绕编辑
    {
        "tpope/vim-surround",
        keys = {
            { "cs", mode = "n" },    -- 更改环绕
            { "ds", mode = "n" },    -- 删除环绕
            { "ys", mode = { "n", "v" } }, -- 添加环绕
        }
    },

    -- 自动配对
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },

    -- 多光标编辑
    { "mg979/vim-visual-multi" },

    -- 快速移动 使用flash替代
    -- { "ggandor/leap.nvim" },

    -- ================  版本控制工具 =============
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
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set('n', '<leader>gs', ':Git<CR>')
            vim.keymap.set('n', '<leader>gc', ':Git commit<CR>')
            vim.keymap.set('n', '<leader>gp', ':Git push<CR>')
        end
    },
    { "sindrets/diffview.nvim" },

    -- 项目管理器
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                detection_methods = { "pattern" },
                patterns = { ".git", "Makefile", "package.json", "pyproject.toml" },
            })
            vim.keymap.set('n', '<leader>pp', ':Telescope projects<CR>')
        end
    },

    -- 会话管理
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            resume = true,
            last_session = true,
        },
        config = function(_, opts)
            require("persistence").setup(opts)
        end,
    },

    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                size = 15,
                open_mapping = [[<c-\>]],
                direction = "horizontal",
            })
            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                float_opts = { border = "rounded" },
                close_on_exit = false,
            })
            vim.keymap.set('n', '<leader>gg', function() lazygit:toggle() end)
        end
    },

    -- Other plugins start here...
    {
        "mikavilpas/yazi.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
        },
        keys = {
            { "<leader>-",  mode = { "n", "v" },    "<cmd>Yazi<cr>",                                           desc = "Open yazi at the current file" },
            { "<leader>cw", "<cmd>Yazi cwd<cr>",    desc = "Open the file manager in nvim's working directory" },
            { "<c-up>",     "<cmd>Yazi toggle<cr>", desc = "Resume the last yazi session" },
        },
        opts = {
            open_for_directories = false,
            keymaps = { show_help = "<f1>" },
        },
        init = function()
            vim.g.loaded_netrwPlugin = 1
        end,
    },
    {
        "yetone/avante.nvim",
        build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or
        "make",
        event = "VeryLazy",
        version = false,
        opts = {
            provider = "gemini",
            providers = {
                openrouter = {
                    __inherited_from = "openai",
                    endpoint = "https://openrouter.ai/api/v1",
                    model = "google/gemini-2.5-flash",
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
                'MeanderingProgrammer/render-markdown.nvim',
                opts = { file_types = { "markdown", "Avante" } },
                ft = { "markdown", "Avante" },
            },
        },
    },


    {
        'saghen/blink.cmp',
        dependencies = {
            'Kaiser-Yang/blink-cmp-avante',
            -- ... Other dependencies
        },
        opts = {
            keymap = { preset = 'default' },
            appearance = { nerd_font_variant = 'mono' },
            completion = { documentation = { auto_show = true } },
            fuzzy = { implementation = "prefer_rust_with_warning" },
            sources = {
                -- Add 'avante' to the list
                default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
                -- snippets = { preset = 'luasnip' },
                providers = {
                    avante = {
                        module = 'blink-cmp-avante',
                        name = 'Avante',
                        opts = {
                            -- options for blink-cmp-avante
                        },
                        vim.api.nvim_set_hl(0, 'BlinkCmpKindAvante', { default = false, fg = '#89b4fa' }),
                        command = {
                            get_kind_name = function(_)
                                return 'AvanteCmd'
                            end
                        },
                        mention = {
                            get_kind_name = function(_)
                                return 'AvanteMention'
                            end
                        },
                        shortcut = {
                            get_kind_name = function(_)
                                return 'AvanteShortcut'
                            end
                        },
                        kind_icons = {
                            AvanteCmd = "",
                            AvanteMention = "",
                            AvanteShortcut = '',
                        },
                        vim.api.nvim_set_hl(0, 'BlinkCmpKindAvanteCmd', { default = false, fg = '#89b4fa' }),
                        vim.api.nvim_set_hl(0, 'BlinkCmpKindAvanteMention', { default = false, fg = '#89b4fa' }),
                        vim.api.nvim_set_hl(0, 'BlinkCmpKindAvanteShortcut', { default = false, fg = '#89b4fa' }),
                    },
                },
            }
        }
    },



    {
        "rcarriga/nvim-notify",
        config = function()
            -- require("notify").setup({
            --   background_colour = "#1f2335",
            --   stages = "fade",
            --   timeout = 5000,
            -- })
            vim.notify = require("notify")
        end,
    },


    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
        config = function()
            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                presets = {
                    bottom_search = true,
                    command_palette = true,
                    long_message_to_split = true,
                    inc_rename = false,
                    lsp_doc_border = false,
                },
            })
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                search = { enable = true },
                char = { jump_labels = true },
            },
        },
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },
})
