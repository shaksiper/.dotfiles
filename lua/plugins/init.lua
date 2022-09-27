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
require("plugins.specs")
-- require("plugins.spellsitter")
require("plugins.nvim-autopair")
-- require("plugins.nvim-gps")
require("plugins.neo-tree")
require("plugins.sniprun")
require("plugins.comment")
require("plugins.bufferline")
require("plugins.project-nvim")
require("plugins.orgmode")
require("plugins.lightspeed")
-- require("plugins.toggleterm")
require("plugins.nvim-pqf")
require("plugins.lualine")
-- -- require("plugins.litee")
require("plugins.marks")
require("plugins.modes")
require("plugins.neodim")
-- require('dim').setup({})
require("plugins.markdownflow")
require("femaco").setup()
-- require("ufo").setup()
-- vim.o.foldcolumn = "1"
-- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.foldlevelstart = -1
-- vim.o.foldenable = true
-- vim.o.fillchars = [[fold: ,foldopen:⏷,foldsep: ,foldclose:⏵]]
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
require("auto-session").setup({
	bypass_session_save_file_types = { "neo-tree", "startify" },
    auto_session_enabled = false,
	auto_session_create_enabled = false,
    auto_restore_enabled = true,
})
require("window-picker").setup()
require("plugins.hydras")
-- require("satellite").setup()
require("nvim-surround").setup()
require("symbols-outline").setup() -- closes #151
-- require('plugins.ufo')
-- require('dressing').setup({
--   input = {
--     -- Set to false to disable the vim.ui.input implementation
--     enabled = true,

--     -- Default prompt string
--     default_prompt = "Input:",

--     -- Can be 'left', 'right', or 'center'
--     prompt_align = "left",

--     -- When true, <Esc> will close the modal
--     insert_only = false,

--     -- These are passed to nvim_open_win
--     anchor = "SW",
--     border = "rounded",
--     -- 'editor' and 'win' will default to being centered
--     relative = "cursor",

--     -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
--     prefer_width = 40,
--     width = nil,
--     -- min_width and max_width can be a list of mixed types.
--     -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
--     max_width = { 140, 0.9 },
--     min_width = { 20, 0.2 },

--     -- Window transparency (0-100)
--     winblend = 10,
--     -- Change default highlight groups (see :help winhl)
--     winhighlight = "",

--     override = function(conf)
--       -- This is the config that will be passed to nvim_open_win.
--       -- Change values here to customize the layout
--       return conf
--     end,

--     -- see :help dressing_get_config
--     get_config = nil,
--   },
--   select = {
--     -- Set to false to disable the vim.ui.select implementation
--     enabled = true,

--     -- Priority list of preferred vim.select implementations
--     backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

--     -- Trim trailing `:` from prompt
--     trim_prompt = true,

--     -- Options for telescope selector
--     -- These are passed into the telescope picker directly. Can be used like:
--     -- telescope = require('telescope.themes').get_ivy({...})
--     telescope = nil,

--     -- Options for fzf selector
--     fzf = {
--       window = {
--         width = 0.5,
--         height = 0.4,
--       },
--     },

--     -- Options for fzf_lua selector
--     fzf_lua = {
--       winopts = {
--         width = 0.5,
--         height = 0.4,
--       },
--     },

--     -- Options for nui Menu
--     nui = {
--       position = "50%",
--       size = nil,
--       relative = "editor",
--       border = {
--         style = "rounded",
--       },
--       buf_options = {
--         swapfile = false,
--         filetype = "DressingSelect",
--       },
--       win_options = {
--         winblend = 10,
--       },
--       max_width = 80,
--       max_height = 40,
--       min_width = 40,
--       min_height = 10,
--     },

--     -- Options for built-in selector
--     builtin = {
--       -- These are passed to nvim_open_win
--       anchor = "NW",
--       border = "rounded",
--       -- 'editor' and 'win' will default to being centered
--       relative = "editor",

--       -- Window transparency (0-100)
--       winblend = 10,
--       -- Change default highlight groups (see :help winhl)
--       winhighlight = "",

--       -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
--       -- the min_ and max_ options can be a list of mixed types.
--       -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
--       width = nil,
--       max_width = { 140, 0.8 },
--       min_width = { 40, 0.2 },
--       height = nil,
--       max_height = 0.9,
--       min_height = { 10, 0.2 },

--       override = function(conf)
--         -- This is the config that will be passed to nvim_open_win.
--         -- Change values here to customize the layout
--         return conf
--       end,
--     },

--     -- Used to override format_item. See :help dressing-format
--     format_item_override = {},

--     -- see :help dressing_get_config
--     get_config = nil,
--   },
-- })
