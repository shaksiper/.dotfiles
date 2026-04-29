local Snacks = require("snacks")
require("neotest").setup({
	adapters = {
		-- require("neotest-dotnet")({
		-- 	discovery_root = "solution",
		-- 	dap = {
		-- 		adapter_name = "coreclr",
		-- 	},
		-- }),
		require("neotest-vstest")({
			dap_settings = {
				type = "coreclr",
			},
			-- build_opts = {
			-- 	"/p:ConsoleLoggerParameters=ForceNoAlign;LogColor",
			-- },
		}),
	},
	consumers = {
		-- overseer = require("neotest.consumers.overseer"),
		run_history = require("plugins.neotest.consumers.run_history"),
		notification = function(client)
			local notification_id = "test_start_notification"
			client.listeners.run = function(_) -- (adapter_id, results)
				vim.notify("Tests running...", vim.log.levels.INFO, {
					title = "Neotest",
					id = notification_id,
					timeout = false, -- Keep it open until we manually close it
					layout = { top = 5 },
					opts = function(notif)
						notif.icon = Snacks.util.spinner()
					end,
				})
				-- BUG
				-- ...can/.local/share/nvim/plugged/nvim-nio/lua/nio/tasks.lua:100: Async task failed without callback: The coroutine failed with this message:
				-- /home/can/.config/nvim/lua/plugins/neotest.lua:31: E5560: nvim_exec_autocmds must not be called in a fast event context
				vim.schedule(function()
					vim.api.nvim_exec_autocmds("User", {
						pattern = "RemoteOperationTerminated",
					})
				end)
			end
			client.listeners.starting = function(_)
				vim.notify("Tests being discovered", vim.log.levels.DEBUG, {
					title = "Neotest",
					id = notification_id,
					timeout = false, -- Keep it open until we manually close it
					layout = { top = 5 },
					opts = function(notif)
						notif.icon = Snacks.util.spinner()
					end,
				})
			end
			client.listeners.started = function(_)
				vim.notify("Tests discovered", vim.log.levels.INFO, {
					title = "Neotest",
					id = notification_id,
					timeout = 5000,
				})
			end
			-- TODO: improve success/fail details with a little bit more persistent notification
			client.listeners.results = function(_, results)
				local has_failed = false
				for _, result in pairs(results) do
					if result.status == "failed" then
						has_failed = true
						break
					end
				end

				local level = has_failed and vim.log.levels.ERROR or vim.log.levels.INFO
				local msg = has_failed and "Tests Failed" or "Tests Passed"

				vim.notify(msg, level, {
					title = "Neotest",
					id = notification_id,
					timeout = 3000,
					hl = not has_failed and { title = "NeotestPassed", border = "NeotestPassed" },
					icon = not has_failed and "",
				})
			end
		end,
	},
	-- overseer = {
	-- 	enabled = true,
	-- 	-- When this is true (the default), it will replace all neotest.run.* commands
	-- 	-- force_default = false,
	-- },
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
