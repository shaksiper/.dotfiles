require("orgmode").setup({
	org_agenda_files = { "~/Documents/org/*", "~/my-orgs/**/*" },
	org_default_notes_file = "~/Documents/org/refile.org",
})
require("headlines").setup()
require("org-bullets").setup({
	symbols = { "◉", "○", "✸", "✿" },
	-- or a function that receives the defaults and returns a list
	--[[ symbols = function(default_list)
        table.insert(default_list, "♥")
        return default_list
    end, --]]
})
