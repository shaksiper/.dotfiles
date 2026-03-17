local npairs = require("nvim-autopairs")
local cond = require("nvim-autopairs.conds")
npairs.setup({
	map_c_w = true,
	fast_wrap = {

		chars = { "{", "[", "(", '"', "'", "<" },
	},
	check_ts = true,
	-- map_cr = false,
})

local Rule = require("nvim-autopairs.rule")
npairs.add_rules({
	Rule("<", ">"):with_pair(cond.not_filetypes({ "go" })),
})
require("sentiment").setup({
	-- config
})
