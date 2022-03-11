local lspkind = require("lspkind")
local luasnip = require("luasnip")
local types = require("luasnip.util.types")

luasnip.config.setup({
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "TSString" } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { "●", "TSKeyword" } },
			},
		},
	},
})
local cmp = require("cmp")
local WIDE_HEIGHT = 40
-- TABNINE setup
local tabnine = require("cmp_tabnine.config")
tabnine:setup({
	max_lines = 1000,
	max_num_results = 20,
	sort = true,
	run_on_every_keystroke = true,
	snippet_placeholder = "..",
})
local cmp_settings = {
	experimental = {
		ghost_text = true,
	},
	-- You can set mappings if you want
	mapping = {
		["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s", "c" }),
		["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping({
			c = cmp.mapping.confirm({ select = false }),
		}),
		["<C-J>"] = cmp.mapping({
			i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
			s = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
			c = function(fallback)
				-- This little snippet will confirm with <C-J>, and if no entry is selected, will *enter* the first item
				if cmp.visible() then
					cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }, fallback) -- insert *and* fallback
				else
					fallback()
				end
			end,
		}),

		["<Tab>"] = cmp.mapping(function(fallback)
			--[[ if cmp.visible() then
				cmp.select_next_item()
			else ]]
			if luasnip and luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s", "c" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip and luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s", "c" }),
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	-- You should specify your *installed* sources.
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "cmp_tabnine", keyword_length = 4 },
		-- { name = 'fzy_buffer' },
		{ name = "buffer", keyword_length = 4, max_item_count = 15 },
		{ name = "luasnip" },
		{ name = "orgmode" },
		{ name = "treesitter", keyword_length = 5, max_item_count = 10 },
		{ name = "path" },
		{ name = "nvim_lua" },
		{ name = "calc" },
	}),
	documentation = {
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		winhighlight = "NormalFloat:CmpDocumentation,FloatBorder:CmpDocumentationBorder",
		maxwidth = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
		maxheight = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
	},
	formatting = {
		format = lspkind.cmp_format({
            -- format = 'default',
			menu = {
				buffer = "[buf]",
				cmp_tabnine = "[T9]",
				nvim_lsp = "[lsp]",
				nvim_lua = "[nlua]",
				path = "[path]",
				luasnip = "[snip]",
				treesitter = "[tsit]",
				calc = "[clc]",
				orgmode = "[org]",
				-- fzy_buffer = "[fzy]"
			},
		}),
	},
}
cmp.setup(cmp_settings)
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, { { name = "cmdline" } }),
})
local cmp_search_config = {
	sources = cmp.config.sources({ { name = "nvim_lsp_document_symbol" } }, { { name = "buffer" } }),
}
cmp.setup.cmdline("/", cmp_search_config)
cmp.setup.cmdline("?", cmp_search_config)
-- If you want insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

require("luasnip/loaders/from_vscode").lazy_load() --friendly-snippts should work after this
