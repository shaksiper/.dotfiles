local overseer = require("overseer")
overseer.register_template({
	name = "Roslyn: Build Current Solution",
	builder = function()
		local sln = vim.g.roslyn_nvim_selected_solution
		return {
			cmd = { "dotnet" },
			args = { "build", sln },
			name = "dotnet build " .. vim.fn.fnamemodify(sln, ":t"),
			components = {
				"default",
				"status-notification",
			},
		}
	end,
	condition = {
		callback = function()
			-- Only show if roslyn.nvim has actually picked a solution
			return vim.g.roslyn_nvim_selected_solution ~= nil
		end,
	},
})
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
