local lspkind = require("lspkind")
local luasnip = require("luasnip")
local types = require("luasnip.util.types")
require("cmp_luasnip_choice").setup({
	auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
})

luasnip.config.setup({
	-- Remember the last snippet I was in
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
-- TABNINE setup
--[[ local tabnine = require("cmp_tabnine.config")
tabnine:setup({
	max_lines = 1000,
	max_num_results = 10,
	sort = true,
	run_on_every_keystroke = true,
	snippet_placeholder = "..",
    show_prediction_strength = true
}) ]]
local cmp_settings = {
	experimental = {
		ghost_text = true,
	},
	-- You can set mappings if you want
	mapping = {
		["<C-n>"] = cmp.mapping(
			cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
			{ "i", "s", "c" }
		),
		["<C-p>"] = cmp.mapping(
			cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
			{ "i", "s", "c" }
		),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- ["<CR>"] = cmp.mapping({
		-- 	c = cmp.mapping.confirm({ select = false }),
		-- }),
		["<CR>"] = cmp.mapping({
			i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
			s = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			--[[ if cmp.visible() then
				cmp.select_next_item()
			else ]]
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s", "c" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
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
		{ name = "nvim_lsp", group_index = 2 },
		{ name = "copilot", keyword_length = 2, group_index = 2 },
		-- { name = "cmp_tabnine", keyword_length = 4 },
		{ name = "buffer", keyword_length = 4, max_item_count = 15 },
		{ name = "luasnip" },
		{ name = "luasnip_choice" },
		-- { name = "nvim_lsp_signature_help" },
		-- { name = "treesitter", keyword_length = 5, max_item_count = 10 },
		{ name = "path" },
		{ name = "nvim_lua" },
		{ name = "calc" },
	}),
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	-- formatting = {
	-- 	format = function(entry, vim_item)
	-- 		if entry.source.name == "buffer" then
	-- 			vim_item.menu = "[Buffer]"
	-- 		elseif entry.source.name == "nvim_lsp" then
	-- 			vim_item.menu = "{" .. entry.source.source.client.name .. "}"
	-- 		else
	-- 			vim_item.menu = "[" .. entry.source.name .. "]"
	-- 		end

	-- 		return vim_item
	-- 	end,
	-- },
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = lspkind.cmp_format({
			mode = "symbol",
			maxwidth = 50,
			symbol_map = { Copilot = "" },
			menu = {
				buffer = "[buf]",
				copilot = "[copilot]",
				-- cmp_tabnine = "[T9]",
				nvim_lsp = "[lsp]",
				nvim_lua = "[nlua]",
				path = "[path]",
				luasnip = "[snip]",
				-- treesitter = "[tsit]",
				calc = "[clc]",
				-- orgmode = "[org]",
				-- fzy_buffer = "[fzy]"
			},
		}),
	},
	view = {
		entries = {
			follow_cursor = false,
		},
	},
}
cmp.setup(cmp_settings)
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	sources = {
		{ name = "dap" },
	},
})
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, { { name = "cmdline" } }),
})
local cmp_search_config = {
	sources = cmp.config.sources({ { name = "nvim_lsp_document_symbol" } }, { { name = "buffer" } }),
}
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
		{ name = "nvim_lsp_document_symbol" },
	},
})
-- If you want insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

require("luasnip/loaders/from_vscode").lazy_load() --friendly-snippts should work after this
require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } }) -- added to scissors
