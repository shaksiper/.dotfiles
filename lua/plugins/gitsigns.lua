require("gitsigns").setup({
	current_line_blame = true,
	numhl = true,
	current_line_blame_formatter_opts = {
		relative_time = true,
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>hS", ":Gitsigns stage_buffer<CR>")
		map("n", "<leader>hu", ":Gitsigns undo_stage_hunk<CR>")
		map("n", "<leader>hR", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>hp", ":Gitsigns preview_hunk<CR>")
		map("n", "<leader>hb", ":Gitsigns blame_line<CR>")
		-- map("n", "<leader>tb", gs.toggle_current_line_blame)
		-- map("n", "<leader>hd", ":Gitsigns diffthis<CR>")
		-- map("n", "<leader>hD", function()
		-- 	gs.diffthis("~")
		-- end)
		map("n", "<leader>td", ":Gitsigns toggle_deleted<CR>")

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
