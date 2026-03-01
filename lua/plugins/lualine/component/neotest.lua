-- local state = require("plugins.neotest_lualine.state")
local Snacks = require("snacks")
local state = require("neotest.consumers.state")
local neotest_config = require("neotest.config")
local lualine_require = require("lualine_require")
---@class lualine.Component
local M = lualine_require.require("lualine.component"):extend()
local default_options = {
	cond = function()
		return state ~= nil and #state.adapter_ids() > 0
	end,
	-- color = { bg = "blue" }, -- causes the separator to not render?
}

---@class lualine.Component
---@field create_hl function
---@field super self
function M:init(options)
	M.super.init(self, options)
	self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
	self.highlights = {
		total = self:create_hl({ fg = "#f0e130" }, false),
		passed = self:create_hl({ fg = "#a6e3a1" }, false),
		failed = self:create_hl({ fg = "#ff0038" }, false),
		running = self:create_hl({ fg = "#a6e3a1" }, false),
	}
end

---@class lualine.Component
---@field format_hl function
function M:update_status(_)
	if state == nil then
		return "󰂭 tests…" -- adapters still loading
	end
	-- return Snacks.util.spinner()

	local result = ""

	-- TODO: memoize this and update only on/after neotest task run
	for _, adapter in pairs(state.adapter_ids()) do
		result = result
			.. " "
			.. self:format_hl(self.highlights.total)
			.. neotest_config.icons.test
			.. " "
			.. state.status_counts(adapter).total
		result = result
			.. " "
			.. self:format_hl(self.highlights.passed)
			.. neotest_config.icons.passed
			.. " "
			.. state.status_counts(adapter).passed
		result = result
			.. " "
			.. self:format_hl(self.highlights.failed)
			.. neotest_config.icons.failed
			.. " "
			.. state.status_counts(adapter).failed
		if state.status_counts(adapter).running > 0 then
			result = result
				.. " "
				.. self:format_hl(self.highlights.running)
				.. Snacks.util.spinner()
				.. " "
				.. state.status_counts(adapter).running
			-- parts = parts .. hl(, state.status_counts(adapter).running, "NeotestRunning")
		end
	end

	if result == "" then
		return "󰂭 tests"
	end

	return result
end

return M
