require("obsidian").setup({
	dir = "/mnt/c/Users/CanBerkCetin/Documents/Obsidian/Vispera/",
	workspaces = {
		{
			name = "work",
			path = "~/Documents/Obsidasion/",
		},
	},
	completion = {
		blink = true,
		min_chars = 2,
		-- nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
	},
	templates = {
		subdir = "templates",
		date_format = "%Y-%m-%d-%a",
		time_format = "%H:%M",
	},
	daily_notes = {
		-- Optional, if you keep daily notes in a separate directory.
		folder = "Personal/Daily",
		-- Optional, if you want to change the date format for the ID of daily notes.
		date_format = "%Y-%m-%d",
		-- Optional, if you want to change the date format of the default alias of daily notes.
		alias_format = "%B %-d, %Y",
	},
	-- delete after deprecation
	statusline = {
		enabled = false,
	},
	footer = {
		enabled = true,
	},
	callbacks = {
		---comment
		---@param _ obsidian.Client
		---@param note obsidian.Note
		enter_note = function(_, note)
			-- we can set keymaps here
			vim.keymap.set("n", "gf", function()
				if require("obsidian").util.cursor_on_markdown_link() then
					return "<cmd>ObsidianFollowLink<CR>"
				else
					return "gf"
				end
			end, {
				-- buffer = note.bufnr,
				desc = "Follow Link",
				noremap = false,
				expr = true,
			})
		end,
	},
	legacy_commands = false,
})
