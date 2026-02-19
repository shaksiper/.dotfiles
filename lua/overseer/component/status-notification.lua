local Snakcs = require("snacks")
---@type overseer.StatusNotification
return {
	desc = "Status notification",
	-- Optional, default true. Set to false to disallow editing this component in the task editor
	editable = true,
	-- Optional, default true. When false, don't serialize this component when saving a task to disk
	serializable = true,
	-- The params passed in will match the params defined above
	constructor = function(_)
		-- You may optionally define any of the methods below
		return {
			---@param status overseer.Status
			on_status = function(_, task, status)
				local notification_id = "overseer_notification"
				if status == "RUNNING" then
					vim.notify("Task Started: " .. task.name, vim.log.levels.INFO, {
						title = "Overseer",
						timeout = false,
						id = notification_id,
						opts = function(notif)
							notif.icon = Snakcs.util.spinner()
						end,
					})
				elseif status == "SUCCESS" then
					vim.notify(
						"Task Passed: " .. task.name,
						vim.log.levels.INFO,
						{ title = "Overseer", timeout = 3000, id = notification_id }
					)
				elseif status == "FAILURE" then
					vim.notify(
						"Task Failed: " .. task.name,
						vim.log.levels.ERROR,
						{ title = "Overseer", timeout = 3000, id = notification_id }
					)
				end
			end,
		}
	end,
}
