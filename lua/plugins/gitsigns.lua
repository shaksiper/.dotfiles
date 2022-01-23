require("gitsigns").setup({
	current_line_blame = true,
	numhl = true,
	current_line_blame_formatter_opts = {
		relative_time = true,
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		-- Navigation
		vim.keymap.set("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
		vim.keymap.set("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

		-- Actions
		vim.keymap.set({ "n", "v" }, "<leader>hs", gs.stage_hunk)
		vim.keymap.set({ "n", "v" }, "<leader>hr", gs.reset_hunk)
		vim.keymap.set("n", "<leader>hS", gs.stage_buffer)
		vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk)
		vim.keymap.set("n", "<leader>hR", gs.reset_buffer)
		vim.keymap.set("n", "<leader>hp", gs.preview_hunk)
		vim.keymap.set("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end)
		vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame)
		vim.keymap.set("n", "<leader>hd", gs.diffthis)
		vim.keymap.set("n", "<leader>hD", function()
			gs.diffthis("~")
		end)
		vim.keymap.set("n", "<leader>td", gs.toggle_deleted)

		-- Text object
		vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
	-- status_formatter = function(status)
	--       local added, changed, removed = status.added, status.changed, status.removed
	--       local status_txt = {}
	--       if added   and added   > 0 then table.insert(status_txt, ' '..added  ) end
	--       if changed and changed > 0 then table.insert(status_txt, ' '..changed) end
	--       if removed and removed > 0 then table.insert(status_txt, ' '..removed) end
	--       return table.concat(status_txt, ' ')
	-- end
})
