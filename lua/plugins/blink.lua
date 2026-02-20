local ui = require("core.ui")
return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"xzbdmw/colorful-menu.nvim",
			"L3MON4D3/LuaSnip",
			"Kaiser-Yang/blink-cmp-avante",
			"Kaiser-Yang/blink-cmp-git",
			"fang2hou/blink-copilot",
			-- ... Other dependencies
		},
		version = "1.*",
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "super-tab",
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback_to_mappings" },
				["<C-n>"] = { "select_next", "fallback_to_mappings" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<c-K>"] = { "show_signature", "hide_signature", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
				kind_icons = ui.icons.lazy_kind_icons,
				-- kind_icons = {
				-- 	AvanteCmd = "",
				-- 	AvanteMention = "",
				-- 	AvanteShortcut = "",
				-- },
			},

			completion = {
				accept = {
					-- experimental auto-brackets support
					auto_brackets = {
						enabled = true,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				list = { selection = { preselect = true, auto_insert = true } },
				menu = {
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", gap = 1 },
							{ "kind", gap = 1 },
							{ "source_name", gap = 1 },
						},
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
							kind = {
								text = function(ctx)
									return "[" .. ctx.kind .. "]"
								end,
							},
							source_name = {
								text = function(ctx)
									return "[" .. ctx.source_name .. "]"
								end,
							},
						},
						treesitter = { "lsp" },
					},
				},
			},

			fuzzy = {
				implementation = "prefer_rust_with_warning",
				sorts = {
					"exact",
					-- defaults
					"score",
					"sort_text",
				},
			},

			-- Use a preset for snippets, check the snippets documentation for more information
			snippets = { preset = "luasnip" },

			sources = {
				default = { "avante", "lsp", "path", "snippets", "buffer", "git", "copilot", "lazydev" },
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 95,
					},
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						async = true,
						score_offset = 100,
						opts = {
							max_completions = 3,
							max_items = 2,
							max_attempts = 4,
						},
					},
					path = {
						score_offset = 95,
						opts = {
							get_cwd = function(_)
								return vim.fn.getcwd()
							end,
						},
					},
					-- Hide snippets after trigger character
					-- Trigger characters are defined by the sources. For example, for Lua, the trigger characters are ., ", '.
					snippets = {
						score_offset = 70,
						should_show_items = function(ctx)
							return ctx.trigger.initial_kind ~= "trigger_character"
						end,
						fallbacks = { "buffer" },
					},
					lsp = {
						-- Default
						-- Filter text items from the LSP provider, since we have the buffer provider for that
						transform_items = function(_, items)
							return vim.tbl_filter(function(item)
								return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
							end, items)
						end,
						score_offset = 60,
						fallbacks = { "buffer" },
					},
					buffer = {
						score_offset = 20,
					},
					avante = {
						module = "blink-cmp-avante",
						name = "Avante",
						opts = {
							-- options for blink-cmp-avante
						},
						command = {
							get_kind_name = function(_)
								return "AvanteCmd"
							end,
						},
						mention = {
							get_kind_name = function(_)
								return "AvanteMention"
							end,
						},
						shortcut = {
							get_kind_name = function(_)
								return "AvanteShortcut"
							end,
						},
					},
					git = {
						module = "blink-cmp-git",
						name = "Git",
						opts = {
							-- options for the blink-cmp-git
						},
					},
				},
			},

			-- Experimental signature help support
			signature = { enabled = true },

			cmdline = {
				keymap = { preset = "inherit" },
				completion = { menu = { auto_show = true } },
			},
		},
		config = function(_, opts)
			require("blink.cmp").setup(opts)

			-- Set up Avante highlight groups
			vim.api.nvim_set_hl(0, "BlinkCmpKindAvante", { default = false, fg = "#89b4fa" })
			vim.api.nvim_set_hl(0, "BlinkCmpKindAvanteCmd", { default = false, fg = "#89b4fa" })
			vim.api.nvim_set_hl(0, "BlinkCmpKindAvanteMention", { default = false, fg = "#89b4fa" })
			vim.api.nvim_set_hl(0, "BlinkCmpKindAvanteShortcut", { default = false, fg = "#89b4fa" })
		end,
	},
}
