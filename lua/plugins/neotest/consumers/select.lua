local Snacks = require("snacks")
local lib = require("neotest.lib")
local nio = require("nio")
-- local Summary = require("neotest.consumers.summary.summary")
-- local config = require("neotest.config")

---@class neotest.select
local M = {}

local states = { RUNNING = 1, STARTING = 2, STARTED = 3, RESULTS = 4 }

---@param client neotest.Client
local function init(client)
	local notification_id = "test_start_notification"
	local notify = function(status)
		vim.notify(
			status == states.RUNNING and "Test are running"
				or status == states.STARTING and "Tests are being discovered"
				or status == states.STARTED and "Tests are discovered"
				or status == states.RESULTS and "Tests are ready",
			vim.log.levels.TRACE,
			{
				title = "neotest",
				id = notification_id,
				timeout = status == (status == states.STARTED or status == states.RESULTS) and 3000 or false,
				opts = function(notif)
					if status == states.STARTING then
						notif.icon = Snacks.util.spinner()
					end
				end,
			}
		)
	end
	client.listeners.run = function()
		notify(states.RUNNING)
	end
	client.listeners.starting = function()
		notify(states.STARTING)
	end
	client.listeners.results = function(adapter_id, results)
		-- TODO: render tests
		-- local expanded = {}
		-- for pos_id, result in pairs(results) do
		-- 	if
		-- 		result.status == "failed"
		-- 		and client:get_position(pos_id, { adapter = adapter_id })
		-- 		and #client:get_position(pos_id, { adapter = adapter_id }):children() > 0
		-- 	then
		-- 		expanded[pos_id] = true
		-- 	end
		-- end

		print(vim.inspect(results))
		print(vim.inspect(adapter_id))

		-- vim.ui.select(results, { prompt = "Select a test", format_item = function (item)
		--     return item.
		-- end}, on_choice)
	end
end

setmetatable(M, {
	__call = function(_, client)
		init(client)
		return M
	end,
})

return M
