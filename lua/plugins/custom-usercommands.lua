vim.api.nvim_create_user_command("ToggleDiagnostic", function()
	-- get current buffer
	-- local buf = vim.api.nvim_get_current_buf()
	-- -- check if the diagnostics hidden for the current buffer
	-- if vim.diagnostic.is_disabled(buf) then
	-- 	-- show the diagnostics
	-- 	vim.diagnostic.enable(buf)
	-- else
	-- 	-- hide the diagnostics
	-- 	vim.diagnostic.disable(buf)
	-- end
	vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, {})
