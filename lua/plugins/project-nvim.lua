require("project").setup({
	silent_chdir = false,
	-- manual_mode = true,
	exclude_dirs = { "~/.local/share/nvim/plugged/*", "~/go/*", "/home/shaksiper" },
	telescope = {
		enabled = true,
		sort = "newest",
		prefer_file_browser = true,
	},
	ignore_lsp = { "null-ls" },
})
