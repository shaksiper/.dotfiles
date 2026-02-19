vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LSPHelpers", { clear = true }),
	callback = function()
		require("neodim").setup({
			alpha = 0.75,
			blend_color = "#000000",
			-- update_in_insert = {
			-- 	enable = false,
			-- 	delay = 100,
			-- },
			hide = {
				virtual_text = false,
				signs = false,
				underline = false,
			},
		})
	end,
})
