-- vim.o.foldmethod = 'expr'
-- vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.o.foldlevelstart = 99
require("plugins.init")
require("lsp.init")
require("lsp.debuggage")
require("vim._core.ui2").enable({
	enable = true,
})
