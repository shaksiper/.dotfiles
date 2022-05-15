vim.opt.list = true
vim.opt.listchars:append("trail:⋅")
vim.opt.listchars:append("tab:▸ ")
-- TODO: add blank indent char => ebedbed53690a53cd15b53c124eb29f9faffc1d2
require("indent_blankline").setup({
	enabled = true,
	filetype_exclude = { "startify" },
	buftype_exclude = { "terminal", "nofile" },
	use_treesitter = true,
	show_current_context = true,
	show_trailing_blankline_indent = true,
	char_list = { "│", "┊", "┆", "¦", "|", "⋅" },
	show_current_context_start = true,
	context_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
		"IndentBlanklineIndent3",
		"IndentBlanklineIndent4",
		"IndentBlanklineIndent5",
		"IndentBlanklineIndent6",
	},
	context_patterns = {
		"class",
		"function",
		"method",
		"table",
		"condition",
		"body",
		"import",
		"func_literal",
		"block",
		"try",
		"except",
		"argument_list",
		"object",
		"element",
	},
})
vim.cmd([[highlight IndentBlanklineIndent1 guifg=#56B6C2 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#E06C75 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])
