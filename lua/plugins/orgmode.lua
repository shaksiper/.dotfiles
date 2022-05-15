require("orgmode").setup({
	org_agenda_files = { "~/Documents/Org/*" },
	org_default_notes_file = "~/Documents/Org/refile.org",
	org_todo_keywords = { "TODO", "WAITING", "|", "DONE", "DELEGATED" },
	org_todo_keyword_faces = {
		WAITING = ":foreground blue :weight bold",
		DELEGATED = ":background #FFFFFF :slant italic :underline on",
		TODO = ":background #000000 :foreground red", -- overrides builtin color for `TODO` keyword
	},
})
require("headlines").setup({
	markdown = {
		fat_headlines = false,
	},
	org = {
		fat_headlines = false,
	},
})
require("org-bullets").setup({
	symbols = { "◉", "○", "✸", "✿" },
	-- or a function that receives the defaults and returns a list
	--[[ symbols = function(default_list)
        table.insert(default_list, "♥")
        return default_list
    end, --]]
})
