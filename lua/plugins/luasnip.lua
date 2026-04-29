local luasnip = require("luasnip")
local types = require("luasnip.util.types")
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

-- require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
require("luasnip.loaders.from_vscode").lazy_load() -- for friendly-snippets
require("luasnip.loaders.from_lua").lazy_load({ paths = { "./snippets/luasnip" } }) -- for custom
