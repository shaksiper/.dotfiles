vim.opt.splitkeep = "screen"
require("edgy").setup({
	animate = {
		enabled = false,
	},
	bottom = {
		{
			ft = "snacks_terminal",
			title = "%{b:snacks_terminal.id}: %{b:term_title}",
			size = { height = 0.4 },
			filter = function(_buf, win)
				return vim.w[win].snacks_win
					and vim.w[win].snacks_win.position == "bottom"
					and vim.w[win].snacks_win.relative == "editor"
					and not vim.w[win].trouble_preview
			end,
			-- filter = function(buf)
			-- 	return not vim.b[buf].lazyterm_cmd
			-- end,
		},
		{
			ft = "neotest-run-history",
			title = "Neotest Run History",
			size = { height = 0.4 },
			-- filter = function(buf)
			-- 	return not vim.b[buf].lazyterm_cmd
			-- end,
		},
		{
			ft = "neotest-run-details",
			title = "Neotest Run Details",
			size = { height = 0.4 },
			-- filter = function(buf)
			-- 	return not vim.b[buf].lazyterm_cmd
			-- end,
		},
		{
			ft = "neotest-output-panel",
			title = "Neotest Output",
			size = { height = 0.4 },
			-- filter = function(buf)
			-- 	return not vim.b[buf].lazyterm_cmd
			-- end,
		},
		"Trouble",
		{ ft = "qf", title = "QuickFix" },
		{
			ft = "help",
			size = { height = 0.4 },
			-- only show help buffers
			filter = function(buf)
				return vim.bo[buf].buftype == "help"
			end,
		},
	},
})
