require("neotest").setup({
	adapters = {
		-- require("neotest-dotnet") {
		--     discovery_root = "solution",
		--     dap = {
		--         adapter_name = "coreclr"
		--     },
		-- },
		require("neotest-vstest")({
			dap_settings = {
				type = "coreclr",
			},
		}),
	},
	consumers = {
		overseer = require("neotest.consumers.overseer"),
	},
	overseer = {
		enabled = true,
		-- When this is true (the default), it will replace all neotest.run.* commands
		-- force_default = false,
	},
})
-- vim.api.nvim_create_autocmd("User", {
--     pattern = "NeotestSummaryOpen",
--     callback = function()
--         vim.defer_fn(
--             function() vim.api.nvim_set_current_win(vim.fn.bufwinid("Neotest Summary")) end,
--             1
--         )
--     end,
-- })
