require("focus").setup({
	enable = false,
	cursorline = false,
	signcolumn = false,
	number = false,
	excluded_filetypes = { "minimap", "NvimTree", "undotree", "diff", "TelescopePrompt" },
	excluded_buftypes = { "nofile", "prompt", "help" }, -- Telescope buffer preview yields a '' buffer typed window
})
