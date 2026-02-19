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
local test_filters = { "image", "visit" }
overseer.register_template({
	name = string.format("Dotnet Test All"),
	builder = function()
		local sln = vim.g.roslyn_nvim_selected_solution
		return {
			cmd = { "dotnet" },
			args = { "test", sln },
			name = "dotnet test",
			components = {
				{ "open_output", on_complete = "always" },
				"on_exit_set_status",
				"default",
				-- "status-notification",
			},
		}
	end,
	condition = {
		callback = function()
			return vim.g.roslyn_nvim_selected_solution ~= nil
		end,
	},
})

for _, filter in ipairs(test_filters) do
	overseer.register_template({
		name = string.format("Dotnet Test: Filter %s", filter),
		builder = function()
			local sln = vim.g.roslyn_nvim_selected_solution
			return {
				cmd = { "dotnet" },
				args = { "test", sln, "--filter", filter },
				name = "dotnet test --filter " .. filter,
				components = {
					{ "open_output", on_complete = "always" },
					"on_exit_set_status",
					"default",
					-- "status-notification",
				},
			}
		end,
		condition = {
			callback = function()
				return vim.g.roslyn_nvim_selected_solution ~= nil
			end,
		},
	})
end
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
