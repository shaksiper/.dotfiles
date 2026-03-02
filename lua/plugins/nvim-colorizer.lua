require("colorizer").setup({
	filetypes = {
		"css",
		"javascript",
		html = { mode = "foreground" },
	},
	options = {
		parsers = {
			css = true,
		},
	},
})
