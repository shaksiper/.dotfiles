-- require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets", "./snippets/luasnip"} }) -- added to scissors
-- require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
	enabled = function()
		return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
	end,
	fuzzy = { implementation = "prefer_rust_with_warning" },
	keymap = {
		preset = "enter",
	},
	cmdline = {
		-- enabled = true,
		completion = {
			menu = {
				auto_show = true,
			},
		},
		keymap = {
			preset = "default",
			-- ['<CR>'] = { 'accept', 'fallback' },
			["<TAB>"] = { "select_and_accept", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			-- ['<S-TAB>'] = { 'select_prev', 'fallback' },
		},
	},

	-- Experimental signature help support
	signature = {
		enabled = true,
		window = {
			border = "single",
		},
	},
	completion = {
		list = {
			selection = {
				-- preselect = true,
				--   auto_insert = true,
				preselect = function(ctx)
					return ctx.mode ~= "cmdline" and vim.bo.filetype ~= "oil" -- and not require('blink.cmp').snippet_active({ direction = 1 })
				end,
			},
		},
		documentation = {
			-- Controls whether the documentation window will automatically show when selecting a completion item
			auto_show = true,
			-- Delay before showing the documentation window
			-- auto_show_delay_ms = 500,
			-- -- Delay before updating the documentation window when selecting a new item,
			-- -- while an existing item is still visible
			-- update_delay_ms = 50,
			-- -- Whether to use treesitter highlighting, disable if you run into performance issues
			-- treesitter_highlighting = true,
			window = {
				-- winblend = 60,
				border = "single",
			},
		},
		ghost_text = {
			enabled = true,
			show_without_menu = false,
			show_without_selection = true, -- we are defaulting to first element already
		},
		menu = {
			draw = {
				treesitter = { "lsp" },
				-- columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } }, -- same as the default already
				components = {
					kind_icon = {
						text = function(ctx)
							local icon = ctx.kind_icon
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									icon = dev_icon
								end
							else
								icon = require("lspkind").symbol_map[ctx.kind] or ""
							end

							return icon .. ctx.icon_gap
						end,

						-- Optionally, use the highlight groups from nvim-web-devicons
						-- You can also add the same function for `kind.highlight` if you want to
						-- keep the highlight groups in sync with the icons.
						highlight = function(ctx)
							local hl = ctx.kind_hl
								-- local hl = "BlinkCmpKind" .. ctx.kind
								or require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									hl = dev_hl
								end
							end
							return hl
						end,
					},
				},
			},
		},
		accept = {
			dot_repeat = true, -- causes bug, drops to background when snippet completion
			auto_brackets = {
				enabled = true,
				kind_resolution = {
					enabled = true,
				},
				semantic_token_resolution = {
					enabled = true,
					timeout_ms = 400,
				},
			},
		},
	},
	-- experimental auto-brackets support

	-- experimental signature help support
	-- trigger = { signature_help = { enabled = true } },
	snippets = { preset = "luasnip" },
	sources = {
		default = { "lsp", "path", "snippets", "luasnip_choice", "buffer", "nvim_lua", "lazydev" },
		providers = {
			nvim_lua = {
				name = "nvim_lua",
				async = true,
				min_keyword_length = 2,
				module = "blink.compat.source",
				score_offset = 0,
			},
			luasnip_choice = {
				name = "luasnip_choice",
				async = true,
				min_keyword_length = 1,
				module = "blink.compat.source",
				score_offset = -1,
			},
			buffer = {
				min_keyword_length = 2,
				async = true,
			},
			snippets = {
				score_offset = -1,
				opts = {
					use_label_description = true,
				},
			},
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},
})
