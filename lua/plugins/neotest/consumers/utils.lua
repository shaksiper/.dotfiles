---@class run_history.Utils
local M = {}

function M.now_ms()
	return os.time()
end

function M.fmt_time(ts_ms)
	return os.date("%Y-%m-%d %H:%M:%S", ts_ms)
end

return M
