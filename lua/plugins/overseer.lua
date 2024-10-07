local overseer = require("overseer")
overseer.setup()
vim.api.nvim_create_user_command("OverseerRestartLast", function()
	-- local overseer = require("overseer")
	local tasks = overseer.list_tasks({ recent_first = true })
	if vim.tbl_isempty(tasks) then
		vim.notify("No tasks found", vim.log.levels.WARN)
	else
		overseer.run_action(tasks[1], "restart")
	end
end, {})
require("dap.ext.vscode").json_decode = require("overseer.json").decode
