require("plugins.devicons")
require("plugins.treesitter")
require("plugins.cmp")
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
require("plugins.nvim-autopair")
-- require("plugins.nvim-gps")
-- require("plugins.neo-tree")
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
-- require('dim').setup({})
require("plugins.markdownflow")
require("femaco").setup()
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
-- })
