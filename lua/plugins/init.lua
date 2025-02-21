require("plugins.devicons")
require("plugins.treesitter")
require("plugins.cmp")
-- require("plugins.cmp")
require("plugins.blink")
require("plugins.persisted")
require("plugins.telescope")
require("plugins.nvim-colorizer")
require("plugins.which-key")
require("plugins.tabout")
require("plugins.indent-blankline")
require("plugins.close-buffers")
require("plugins.gitsigns")
require("plugins.neoscroll")
-- require("plugins.specs")
-- require("plugins.spellsitter")
require("ts_context_commentstring").setup({})
require("plugins.nvim-autopair")
-- require("plugins.nvim-gps")
-- require("plugins.neo-tree")
require("plugins.oil")
require("plugins.sniprun")
-- require("plugins.comment")
require("plugins.bufferline")
require("plugins.project-nvim")
-- require("plugins.orgmode")
require("plugins.leap")
-- require("plugins.toggleterm")
require("plugins.nvim-pqf")
require("plugins.lualine")
-- -- require("plugins.litee")
require("plugins.marks")
require("plugins.modes")
require("plugins.neodim") -- until errors fixed
require("plugins.zen")
-- require('dim').setup({})
require("plugins.markdownflow")
require("femaco").setup()
require("plugins.dashboard")
require("plugins.persisted")
-- require("dbsession").setup({})
require("hlslens").setup()
-- require("scrollbar").setup()
-- require("scrollbar.handlers.search").setup({
-- 	override_lens = function() end,
-- })
-- require("scrollbar.handlers.gitsigns").setup()
require("scrollview.contrib.gitsigns").setup()
require("git-conflict").setup()
require("plugins.ai")
require("pretty_hover").setup()
require("plugins.neotest")
require("plugins.lsp-lens")
require("plugins.overseer")
require("plugins.container")
-- require("plugins.rest")
require("plugins.neogit")
-- require("plugins.detour")
require("flatten").setup()
-- require("ufo").setup()
-- vim.o.foldcolumn = "1"
-- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.foldlevelstart = -1
-- vim.o.foldenable = true
-- vim.o.fillchars = [[fold: ,foldopen:⏷,foldsep: ,foldclose:⏵]]
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- TODO: replace this plugin with usercmd
-- require("auto-session").setup({
-- 	bypass_session_save_file_types = { "neo-tree", "startify" },
-- 	auto_session_enabled = false,
-- 	auto_session_create_enabled = false,
-- 	auto_restore_enabled = true,
-- })
require("window-picker").setup()
-- require("plugins.hydras")
-- require("satellite").setup()
require("nvim-surround").setup()
require("outline").setup()
require("plugins.trouble")
require("syntax-tree-surfer").setup()
require("fidget").setup({})
require("plugins.config-local")
require("neogen").setup({
	snippet_engine = "luasnip",
	languages = {
		cs = {
			template = {
				annotation_convention = "xmldoc",
			},
		},
	},
})
require("obsidian").setup({
	dir = "~/Documents/Obsidasion",
	completion = {
		nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
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
	mappings = {
		["gf"] = vim.keymap.set("n", "gf", function()
			if require("obsidian").util.cursor_on_markdown_link() then
				return "<cmd>ObsidianFollowLink<CR>"
			else
				return "gf"
			end
		end, { noremap = false, expr = true }),
	},
})
-- require("headlines").setup({
-- 	markdown = {
-- 		fat_headlines = false,
-- 		bullets = nil,
-- 	},
-- })
require("render-markdown").setup({})
require("highlight-undo").setup({
	duration = 300,
	keymaps = {
		Undo = { mode = "n", lhs = "u", rhs = "u", desc = "undo", hlgroup = "HighlightUndo", opts = {} },
		Redo = { mode = "n", lhs = "<C-r>", rhs = "<C-r>", desc = "redo", hlgroup = "HighlightUndo", opts = {} },
	},
})
require("yanky").setup({})
require("plugins.scissors")
-- require("plugins.rainbow-delimiters")
-- require("projections").setup({})
-- require("sentiment").setup({})
local codewindow = require("codewindow")
codewindow.setup()
codewindow.apply_default_keybinds()
require("plugins.custom-usercommands")
-- require("plugins.various-textobj")
require("kanagawa").setup({
	overrides = function(colors) -- add/modify highlights
		return {
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
		}
	end,
})
require("plugins.multicursor")
