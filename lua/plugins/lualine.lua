-- local navic = require("nvim-navic")
require("lualine").setup({
	options = {
		section_separators = { left = "", right = "" },
	},
	--[[ sections = {
		lualine_c = {
			{ navic.get_location, cond = navic.is_available },
		},
	}, ]]
})
