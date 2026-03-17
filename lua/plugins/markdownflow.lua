require("mkdnflow").setup({
	mappings = {
		MkdnEnter = { { "i", "n", "v" }, "<CR>" },
		MkdnUpdateNumbering = { { "n" }, "<leader>gn" },
		MkdnNextLink = { "n", "<C-Tab>" }, -- TAB = C-i in terminals and this breaks the jumplist flow otherwise
	},
	-- completions = {
	-- 	blink = { enabled = true },
	-- 	lsp = { enabled = true },
	-- },
	modules = {
		completion = true,
	},
	links = {
		conceal = true,
	},
	tables = {
		auto_extend_rows = true,
	},
	to_do = {
		-- symbols = { " ", ">", "x" },
	},
})
require("peek").setup({})
