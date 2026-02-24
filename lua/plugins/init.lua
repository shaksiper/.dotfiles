require("plugins.snacks")
require("seeker").setup({})
require("ssr").setup()
require("plugins.treesitter")
require("plugins.treesitter-context")
require("plugins.tree-sitter-textobjects")
require("plugins.neotest")
require("plugins.devicons")
-- require("plugins.cmp")
require("plugins.blink")
require("plugins.luasnip")
require("plugins.persisted")
-- require("plugins.telescope")
require("plugins.nvim-colorizer")
require("plugins.which-key")
require("plugins.tabout")
require("plugins.indent-blankline")
require("plugins.close-buffers")
require("plugins.gitsigns")
-- require("plugins.neoscroll")
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
-- require("plugins.nvim-pqf")
require("plugins.lualine")
-- -- require("plugins.litee")
require("plugins.marks")
require("plugins.modes")
-- require("plugins.neodim") -- until errors fixed
require("plugins.zen")
-- require('dim').setup({})
require("plugins.markdownflow")
require("femaco").setup()
require("plugins.dashboard")
-- require("dbsession").setup({})
require("hlslens").setup()
-- require("scrollbar").setup()
-- require("scrollbar.handlers.search").setup({
-- 	override_lens = function() end,
-- })
-- require("scrollbar.handlers.gitsigns").setup()
require("scrollview.contrib.gitsigns").setup()
require("git-conflict").setup()
-- require("plugins.ai")
-- require("pretty_hover").setup()
-- require("plugins.lsp-lens")
require("plugins.overseer")
require("plugins.container")
-- require("plugins.rest")
require("plugins.neogit")
-- require("plugins.detour")
-- require("flatten").setup()
require("plugins.ufo")
-- vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"
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
vim.g.nvim_surround_no_visual_mappings = false
require("nvim-surround").setup({
	move_cursor = "sticky",
	-- keymaps = {
	-- 	visual = "<C-s>",
	-- },
})
require("outline").setup()
require("plugins.trouble")
--require("syntax-tree-surfer").setup()
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
require("plugins.obsidian")
-- require("headlines").setup({
-- 	markdown = {
-- 		fat_headlines = false,
-- 		bullets = nil,
-- 	},
-- })
require("render-markdown").setup({
	code = {
		-- style = 'normal',
		-- border = 'thick'
	},
	completions = {
		blink = { enabled = true },
		lsp = { enabled = true },
	},
})
-- require("highlight-undo").setup({
--     duration = 300,
--     keymaps = {
--         Undo = { mode = "n", lhs = "u", rhs = "u", desc = "undo", hlgroup = "HighlightUndo", opts = {} },
--         Redo = { mode = "n", lhs = "<C-r>", rhs = "<C-r>", desc = "redo", hlgroup = "HighlightUndo", opts = {} },
--     },
-- })
require("yanky").setup({})
require("plugins.scissors")
-- require("projections").setup({})
-- require("sentiment").setup({})
-- local codewindow = require("codewindow")
-- codewindow.setup()
-- codewindow.apply_default_keybinds()
require("plugins.custom-usercommands")
require("kanagawa").setup({
	overrides = function(_) -- add/modify highlights
		return {
			-- BlinkCmpLabelMatch = { fg = colors.theme.syn.fun },
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
		}
	end,
})
require("plugins.multicursor")
require("snipe").setup()
require("quicker").setup()
require("plugins.commands")
require("grug-far").setup({})
require("demicolon").setup({
	keymaps = {
		horizontal_motions = false,
	},
})
require("refactoring").setup()
