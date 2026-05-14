require("project").setup({
	-- silent_chdir = false,
	-- manual_mode = true,
	exclude_dirs = {
		"~/.local/share/nvim/plugged/*",
		"~/.local/share/nvim/site/pack/core/opt/*",
		"~/go/*",
		"/home/shaksiper",
	},
	-- telescope = {
	-- 	enabled = false,
	-- 	sort = "newest",
	-- 	prefer_file_browser = true,
	-- },
	-- ignore_lsp = { "null-ls" },
})
