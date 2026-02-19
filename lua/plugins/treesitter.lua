require("tsht").config.hint_keys = { "h", "j", "f", "d", "n", "v", "s", "l", "a" }
--require("orgmode").setup_ts_grammar()
local ts = require("nvim-treesitter")
ts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

require("various-textobjs").setup({
	keymaps = {
		useDefaults = true,
	},
})
local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	desc = "Enable treesitter highlighting and indentation",
	callback = function(event)
		-- if vim.tbl_contains(ignore_filetypes, event.match) then
		--   return
		-- end

		local lang = vim.treesitter.language.get_lang(event.match) or event.match
		local buf = event.buf

		-- Start highlighting immediately (works if parser exists)
		pcall(vim.treesitter.start, buf, lang)

		-- Enable treesitter indentation
		-- vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

		-- Install missing parsers (async, no-op if already installed)
		-- ts.install({ lang })
	end,
})

-- require("todo-comments").setup({
-- 	highlight = {
-- 		-- before = "", -- "fg" or "bg" or empty
-- 		keyword = "bg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
-- 		-- after = "fg", -- "fg" or "bg" or empty
-- 	},
-- })
require("treewalker").setup({})
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "TSUpdate",
-- 	callback = function()
-- 		require("nvim-treesitter.parsers").comment = {
-- 			install_info = {
-- 				url = "https://github.com/OXY2DEV/tree-sitter-comment",
--
-- 				branch = "main", -- only needed if different from default branch
-- 				queries = "queries/",
-- 			},
-- 		}
-- 	end,
-- })
