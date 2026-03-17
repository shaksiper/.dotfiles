local lib = require("neotest.lib")

local M = {}

-- ---------- utils ----------
local function now_ms()
	return os.time()
end

local function fmt_time(ts_ms)
	-- local sec = math.floor(ts_ms / 1000)
	return os.date("%Y-%m-%d %H:%M:%S", ts_ms) -- FIXED: correct time and time unit
end

local function safe(tbl, key, default)
	local v = tbl and tbl[key]
	if v == nil then
		return default
	end
	return v
end

local function status_rank(status)
	if status == "failed" then
		return 3
	end
	if status == "skipped" then
		return 2
	end
	if status == "passed" then
		return 1
	end
	return 0
end

local function compute_aggregate(results, position_ids)
	local counts = { passed = 0, failed = 0, skipped = 0, unknown = 0 }
	local worst = "unknown"

	local function test_counter(st)
		if st == "passed" then
			counts.passed = counts.passed + 1
		elseif st == "failed" then
			counts.failed = counts.failed + 1
		elseif st == "skipped" then
			counts.skipped = counts.skipped + 1
		else
			counts.unknown = counts.unknown + 1
		end
		if status_rank(st) > status_rank(worst) then
			worst = st
		end
	end

	if position_ids and #position_ids > 0 then
		for _, id in ipairs(position_ids) do
			local result = results[id]
			test_counter(result and result.status or "unknown")
		end
	else
		-- fallback: aggregate all results
		for _, result in pairs(results or {}) do
			test_counter(result and result.status or "unknown")
		end
	end

	return worst, counts
end

local function read_output_file(path)
	if not path then
		return nil
	end
	local ok, content = pcall(lib.files.read, path)
	if not ok then
		return nil
	end
	return content
end

local function resolve_target_label(client, adapter_id, position_ids)
	if not position_ids or #position_ids == 0 then
		return "(unknown)"
	end
	if #position_ids == 1 then
		local node = client:get_position(position_ids[1], { adapter = adapter_id })
		if node then
			local data = node:data()
			return data.name or data.path or position_ids[1]
		end
		return position_ids[1]
	end
	-- multiple ids: try to show file / root
	local node = client:get_position(position_ids[1], { adapter = adapter_id })
	if node then
		local data = node:data()
		return string.format("%s (+%d)", data.name or data.path or "Multiple", #position_ids - 1)
	end
	return string.format("Multiple (%d)", #position_ids)
end

-- ---------- UI state ----------
local state = {
	runs = {}, -- newest first
	pending_by_adapter = {}, -- adapter_id -> run_id
	selected = 1,

	win_left = nil,
	win_right = nil,
	buf_left = nil,
	buf_right = nil,

	ns = vim.api.nvim_create_namespace("neotest_run_history"),
	hl = {
		title = "Title",
		dim = "Comment",
		passed = "DiffAdd",
		failed = "DiffDelete",
		skipped = "DiffChange",
		unknown = "Normal",
	},
}

state._render_scheduled = false

local function ensure_hls()
	-- You can customize these in your colorscheme; we just map to common groups.
	-- No-op: state.hl already references built-in highlight groups.
end

-- local function close_ui()
-- 	local wins = { state.win_left, state.win_right }
-- 	for _, w in ipairs(wins) do
-- 		if w and vim.api.nvim_win_is_valid(w) then
-- 			pcall(vim.api.nvim_win_close, w, true)
-- 		end
-- 	end
-- 	state.win_left, state.win_right = nil, nil
-- end
local function set_buf_lines(buf, lines)
	if not (buf and vim.api.nvim_buf_is_valid(buf)) then
		return
	end
	local ok_mod = pcall(function()
		vim.bo[buf].modifiable = true
	end)
	if not ok_mod then
		return
	end

	local ok, err = pcall(vim.api.nvim_buf_set_lines, buf, 0, -1, false, lines)

	-- Always restore
	pcall(function()
		vim.bo[buf].modifiable = false
	end)

	if not ok then
		-- Optional: log
		vim.schedule(function()
			vim.notify(("run_history: failed to render buffer: %s"):format(err), vim.log.levels.ERROR)
		end)
	end
end
-- local function set_buf_lines(buf, lines)
-- 	-- vim.api.nvim_buf_set_option(buf, "modifiable", true)
-- 	vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
-- 	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
-- 	-- vim.api.nvim_buf_set_option(buf, "modifiable", false)
-- 	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
-- end

local function apply_line_hl(buf, lnum0, hl)
	-- pcall(vim.api.nvim_buf_add_highlight, buf, state.ns, hl, lnum0, 0, -1)
	pcall(vim.hl.range, buf, state.ns, hl, { lnum0, 0 }, { lnum0, -1 })
end

local function render_history()
	if not (state.buf_left and vim.api.nvim_buf_is_valid(state.buf_left)) then
		return
	end

	ensure_hls()

	local lines = {}
	for _, run in ipairs(state.runs) do
		local status = run.status or "unknown"
		local tag
		if status == "passed" then
			tag = "PASS"
		elseif status == "failed" then
			tag = "FAIL"
		elseif status == "skipped" then
			tag = "SKIP"
		else
			tag = "----"
		end

		local counts = run.counts or { passed = 0, failed = 0, skipped = 0, unknown = 0 }
		local count_str = string.format("P:%d F:%d S:%d", counts.passed, counts.failed, counts.skipped)

		lines[#lines + 1] = string.format(
			"%s [%s] %s  (%s)  %s",
			fmt_time(run.started_at_ms),
			tag,
			run.target_label or "(unknown)",
			run.adapter_id ~= nil and ("adapter " .. tostring(run.adapter_id)) or "adapter ?",
			count_str
		)
	end

	if #lines == 0 then
		lines = { "No runs yet. Trigger a test run, then reopen." }
	end

	set_buf_lines(state.buf_left, lines)

	-- highlights
	vim.api.nvim_buf_clear_namespace(state.buf_left, state.ns, 0, -1)
	for i, run in ipairs(state.runs) do
		local hl = state.hl.unknown
		if run.status == "passed" then
			hl = state.hl.passed
		elseif run.status == "failed" then
			hl = state.hl.failed
		elseif run.status == "skipped" then
			hl = state.hl.skipped
		end
		apply_line_hl(state.buf_left, i - 1, hl)
	end

	-- cursor selection
	if state.win_left and vim.api.nvim_win_is_valid(state.win_left) then
		local row = math.max(1, math.min(state.selected, #state.runs))
		pcall(vim.api.nvim_win_set_cursor, state.win_left, { row, 0 })
	end
end

local function render_output()
	if not (state.buf_right and vim.api.nvim_buf_is_valid(state.buf_right)) then
		return
	end

	ensure_hls()

	local run = state.runs[state.selected]
	if not run then
		set_buf_lines(state.buf_right, { "No run selected." })
		return
	end

	local lines = {}
	lines[#lines + 1] = string.format(
		"Run: %s\tElapsed: %s ms",
		fmt_time(run.started_at_ms),
		(run.finished_at_ms or now_ms()) - run.started_at_ms
	)
	lines[#lines + 1] = string.format("Target: %s", run.target_label or "(unknown)")
	lines[#lines + 1] = string.format("Status: %s", run.status or "unknown")

	local counts = run.counts or { passed = 0, failed = 0, skipped = 0, unknown = 0 }
	lines[#lines + 1] = string.format(
		"Counts: passed=%d failed=%d skipped=%d unknown=%d",
		counts.passed,
		counts.failed,
		counts.skipped,
		counts.unknown
	)
	lines[#lines + 1] = string.rep("-", 80)

	local results = run.results or {}
	local order = {}

	-- TODO: rework this?
	-- Put failed first, then others
	for id, r in pairs(results) do
		if r and r.status == "failed" then
			order[#order + 1] = id
		end
	end
	for id, _ in pairs(results) do
		local r = results[id]
		if not (r and r.status == "failed") then
			order[#order + 1] = id
		end
	end

	local hl_by_status = {
		passed = state.hl.passed,
		failed = state.hl.failed,
		skipped = state.hl.skipped,
		unknown = state.hl.unknown,
	}

	local hl_lines = {} -- {lnum0, hl}
	local function add_test_block(id, r)
		local status = (r and r.status) or "unknown"
		local name = id

		local node = run.client and run.client:get_position(id, { adapter = run.adapter_id })
		if node then
			local data = node:data()
			name = data.name or data.path or id
		end

		lines[#lines + 1] = string.format("[%s] %s", status:upper(), name)
		hl_lines[#hl_lines + 1] = { #lines - 1, hl_by_status[status] or state.hl.unknown }

		-- errors
		if r and r.errors and #r.errors > 0 then
			for _, e in ipairs(r.errors) do
				local msg = e.message or "(error)"

				-- msg = msg:gsub("\r\n?", "\n")
				-- for _, l in ipairs(vim.split("  ✖ " .. msg, "[\r\n]+")) do
				-- 	lines[#lines + 1] = "    " .. l
				-- end
				vim.iter(vim.split("  ✖ " .. msg, "[\r\n]+")):map(function(line)
					table.insert(lines, line)
				end)
				-- lines[#lines + 1] = "  ✖ " .. msg
			end
		end

		-- output (short if available, else full output file)
		local out = nil
		if r then
			out = safe(r, "short", nil) -- this preserves summary output for passed
			if not out then
				out = read_output_file(r.output)
			end
		end
		if out and #out > 0 then
			lines[#lines + 1] = "  Output:"

			-- out = out:gsub("\r\n?", "\n")

			-- for _, l in ipairs(vim.split(out, "[\r\n]+")) do
			-- 	lines[#lines + 1] = "    " .. l
			-- end
			vim.iter(vim.split(out, "[\r\n]+")):map(function(line)
				table.insert(lines, line)
			end)
		end

		lines[#lines + 1] = ""
	end

	local max_blocks = 2000 -- guard against huge runs
	local n = 0
	for _, id in ipairs(order) do
		n = n + 1
		if n > max_blocks then
			lines[#lines + 1] = string.format("… truncated (%d tests shown)", max_blocks)
			break
		end
		add_test_block(id, results[id])
	end

	set_buf_lines(state.buf_right, lines)

	vim.api.nvim_buf_clear_namespace(state.buf_right, state.ns, 0, -1)
	apply_line_hl(state.buf_right, 0, state.hl.title)
	apply_line_hl(state.buf_right, 1, state.hl.dim)
	apply_line_hl(state.buf_right, 2, state.hl.dim)
	apply_line_hl(state.buf_right, 3, state.hl.dim)

	for _, pair in ipairs(hl_lines) do
		apply_line_hl(state.buf_right, pair[1], pair[2])
	end
end

local function request_render()
	if state._render_scheduled then
		return
	end
	state._render_scheduled = true
	vim.schedule(function()
		state._render_scheduled = false
		if state.win_left and vim.api.nvim_win_is_valid(state.win_left) then
			render_history()
		end
		if state.win_right and vim.api.nvim_win_is_valid(state.win_right) then
			render_output()
		end
	end)
end

local function select_run(delta)
	if #state.runs == 0 then
		return
	end
	state.selected = math.max(1, math.min(state.selected + delta, #state.runs))
	render_history()
	render_output()
end

local function is_win_valid(win)
	return win and vim.api.nvim_win_is_valid(win)
end

-- local function is_buf_valid(buf)
-- 	return buf and vim.api.nvim_buf_is_valid(buf)
-- end

local function close_ui()
	-- Close only our UI windows; don't wipe unrelated windows.
	if is_win_valid(state.win_left) then
		pcall(vim.api.nvim_win_close, state.win_left, true)
	end
	if is_win_valid(state.win_right) then
		pcall(vim.api.nvim_win_close, state.win_right, true)
	end
	state.win_left, state.win_right = nil, nil
	-- buffers are scratch with bufhidden=wipe, so closing windows is enough
	state.buf_left, state.buf_right = nil, nil
end

local function open_ui()
	vim.schedule(function()
		-- If already open, just re-render and focus list
		if is_win_valid(state.win_left) and is_win_valid(state.win_right) then
			render_history()
			render_output()
			pcall(vim.api.nvim_set_current_win, state.win_left)
			return
		end

		close_ui()

		-- Create fresh scratch buffers
		state.buf_left = vim.api.nvim_create_buf(false, true)
		state.buf_right = vim.api.nvim_create_buf(false, true)

		vim.bo[state.buf_left].filetype = "neotest-run-history"
		vim.bo[state.buf_right].filetype = "neotest-run-details"
		vim.bo[state.buf_left].buftype = "nofile"
		vim.bo[state.buf_right].buftype = "nofile"
		vim.bo[state.buf_left].bufhidden = "wipe"
		vim.bo[state.buf_right].bufhidden = "wipe"
		vim.bo[state.buf_left].swapfile = false
		vim.bo[state.buf_right].swapfile = false

		-- ---- Create bottom dock (single window) ----
		-- Save current win to return focus later if you want
		local prev_win = vim.api.nvim_get_current_win()

		-- Create a bottom split with a fixed height
		local dock_height = math.max(10, math.min(18, math.floor(vim.o.lines * 0.25)))
		vim.cmd("botright " .. dock_height .. "split")

		state.win_right = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(state.win_right, state.buf_right)

		-- Ensure the right window inherits the dock height behavior
		vim.wo[state.win_right].winfixheight = true
		vim.wo[state.win_right].number = false
		vim.wo[state.win_right].relativenumber = false
		vim.wo[state.win_right].signcolumn = "no"
		vim.wo[state.win_right].wrap = false

		-- This is the dock base window (we'll turn it into the LEFT pane)
		-- ---- Split the dock vertically into list (left) and details (right) ----
		vim.cmd("vsplit")
		state.win_left = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(state.win_left, state.buf_left)

		-- Fix dock height; keep it a "drawer"
		vim.wo[state.win_left].winfixheight = true
		vim.wo[state.win_left].number = false
		vim.wo[state.win_left].relativenumber = false
		vim.wo[state.win_left].signcolumn = "no"
		vim.wo[state.win_left].wrap = false

		-- Go back to left list window (the other split)
		vim.cmd("wincmd h")
		state.win_left = vim.api.nvim_get_current_win()

		-- Make list narrower and fixed width
		local list_width = math.max(40, math.min(60, math.floor(vim.o.columns * 0.30)))
		pcall(vim.api.nvim_win_set_width, state.win_left, list_width)
		vim.wo[state.win_left].winfixwidth = true

		-- Keymaps
		local function map(buf, lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, noremap = true, desc = desc })
		end

		map(state.buf_left, "q", close_ui, "Close")
		map(state.buf_right, "q", close_ui, "Close")

		map(state.buf_left, "j", function()
			select_run(1)
		end, "Next run")
		map(state.buf_left, "k", function()
			select_run(-1)
		end, "Prev run")
		map(state.buf_left, "<CR>", function()
			render_output()
		end, "Refresh details")
		map(state.buf_left, "r", function()
			render_history()
			render_output()
		end, "Refresh")
		map(state.buf_left, "<Tab>", function()
			if is_win_valid(state.win_right) then
				vim.api.nvim_set_current_win(state.win_right)
			end
		end, "Focus details")

		map(state.buf_right, "J", function()
			select_run(1)
		end, "Next run")
		map(state.buf_right, "K", function()
			select_run(-1)
		end, "Prev run")
		map(state.buf_right, "<Tab>", function()
			if is_win_valid(state.win_left) then
				vim.api.nvim_set_current_win(state.win_left)
			end
		end, "Focus list")

		-- Render
		state.selected = math.max(1, math.min(state.selected, #state.runs))
		render_history()
		render_output()

		-- Optional: focus list pane; or return focus to previous window
		-- pcall(vim.api.nvim_set_current_win, state.win_left)
		-- If you prefer keeping focus in editor: uncomment
		pcall(vim.api.nvim_set_current_win, prev_win)
	end)
end
-- ---------- consumer init ----------
local function init(client)
	-- Create user commands
	vim.api.nvim_create_user_command("NeotestRunHistoryOpen", open_ui, {})
	vim.api.nvim_create_user_command("NeotestRunHistoryToggle", function()
		if state.win_left and vim.api.nvim_win_is_valid(state.win_left) then
			close_ui()
		else
			open_ui()
		end
	end, {})
	vim.api.nvim_create_user_command("NeotestRunHistoryClear", function()
		state.runs = {}
		state.pending_by_adapter = {}
		state.selected = 1
		if state.win_left and vim.api.nvim_win_is_valid(state.win_left) then
			render_history()
			render_output()
		end
	end, {})

	-- Hook into neotest client events (same mechanism used by built-in consumers) :contentReference[oaicite:1]{index=1}
	client.listeners.run = function(adapter_id, _, position_ids)
		local run_id = tostring(now_ms()) .. ":" .. tostring(math.random(1000, 9999)) -- TODO: better identification
		state.pending_by_adapter[adapter_id] = run_id

		local target_label = resolve_target_label(client, adapter_id, position_ids)
		local run = {
			id = run_id,
			adapter_id = adapter_id,
			started_at_ms = now_ms(),
			finished_at_ms = nil,
			position_ids = position_ids,
			target_label = target_label,
			status = "unknown",
			counts = { passed = 0, failed = 0, skipped = 0, unknown = 0 },
			results = {},
			client = client,
		}

		table.insert(state.runs, 1, run)
		state.selected = 1

		-- if state.win_left and vim.api.nvim_win_is_valid(state.win_left) then
		-- 	render_left()
		-- 	render_right()
		-- end
		request_render()
	end

	client.listeners.results = function(adapter_id, results, partial)
		if partial then
			return
		end

		local run_id = state.pending_by_adapter[adapter_id]
		if not run_id then
			-- Could be results from earlier discovery or other consumer; ignore.
			return
		end

		-- local run
		-- for _, r in ipairs(state.runs) do
		-- 	if r.id == run_id then
		-- 		run = r
		-- 		break
		-- 	end
		-- end

		local run = vim.iter(state.runs):find(function(run)
			return run.id == run_id
		end)

		if not run then
			return
		end

		local tree = client:get_position(nil, { adapter = adapter_id })
		assert(tree, "No tree for adapter " .. adapter_id)

		-- run.results = results or {}
		run.results = vim.iter(results or {})
			:filter(function(pos_id, result)
				if result.output and tree:get_key(pos_id) and tree:get_key(pos_id):data().type == "test" then -- TODO: print this hierarchy with map? IntegrationTests > *SetTests >  *.cs > method
					return true
				end
				return false
			end)
			:fold({}, function(acc, k, v)
				acc[k] = v
				return acc
			end)

		-- print("Results:\n")
		-- print(vim.inspect(results))
		-- print("Deneme:\n")
		-- print(vim.inspect(run.results))

		run.finished_at_ms = now_ms()
		run.status, run.counts = compute_aggregate(run.results, run.position_ids)

		-- If UI open, refresh
		-- if state.win_left and vim.api.nvim_win_is_valid(state.win_left) then
		-- 	render_left()
		-- 	render_right()
		-- end
		request_render()
	end

	return {
		open = open_ui,
		toggle = function()
			vim.cmd("NeotestRunHistoryToggle")
		end,
		clear = function()
			vim.cmd("NeotestRunHistoryClear")
		end,
	}
end

M.run_history = setmetatable({}, {
	__call = function(_, ...)
		return init(...)
	end,
})

return M.run_history
