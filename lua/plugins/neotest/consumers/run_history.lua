local nio = require("nio")
local lib = require("neotest.lib")
local utils = require("plugins.neotest.consumers.utils")

local M = {}

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
		for _, result in pairs(results or {}) do
			test_counter(result and result.status or "unknown")
		end
	end

	return worst, counts
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

	local node = client:get_position(position_ids[1], { adapter = adapter_id })
	if node then
		local data = node:data()
		return string.format("%s (+%d)", data.name or data.path or "Multiple", #position_ids - 1)
	end
	return string.format("Multiple (%d)", #position_ids)
end

local function split_preserving_current_behavior(text)
	if type(text) == "table" then
		text = table.concat(text, "\n")
	end
	if not text or text == "" then
		return {}
	end
	return vim.split(text, "[\r\n]+")
end

local function spinner_provider()
	local ok_snacks, snacks = pcall(require, "snacks.util")
	if ok_snacks and type(snacks.spinner) == "function" then
		return function(i)
			return snacks.spinner(i)
		end
	end

	local ok_neotest_lib, neotest_lib = pcall(require, "neotest.lib")
	if ok_neotest_lib and type(neotest_lib.spinner) == "function" then
		return function(i)
			return neotest_lib.spinner(i)
		end
	end

	local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
	return function(i)
		return frames[((i - 1) % #frames) + 1]
	end
end

local get_spinner_frame = spinner_provider()

-- ---------- UI state ----------
local state = {
	runs = {},
	pending_by_adapter = {},
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
		section = "Special",
	},

	_render_scheduled = false,
	_spinner_index = 1,
	_spinner_timer = nil,
	_line_actions = {},
	_expanded = {},
}

local function ensure_hls() end

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

	pcall(function()
		vim.bo[buf].modifiable = false
	end)

	if not ok then
		vim.schedule(function()
			vim.notify(("run_history: failed to render buffer: %s"):format(err), vim.log.levels.ERROR)
		end)
	end
end

local function apply_line_hl(buf, lnum0, hl)
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

		table.insert(
			lines,
			string.format(
				"%s [%s] %s  (%s)  %s",
				utils.fmt_time(run.started_at_ms),
				tag,
				run.target_label or "(unknown)",
				run.adapter_id ~= nil and ("adapter " .. tostring(run.adapter_id)) or "adapter ?",
				count_str
			)
		)
	end

	if #lines == 0 then
		lines = { "No runs yet. Trigger a test run, then reopen." }
	end

	set_buf_lines(state.buf_left, lines)

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

	if state.win_left and vim.api.nvim_win_is_valid(state.win_left) then
		local row = math.max(1, math.min(state.selected, #state.runs))
		pcall(vim.api.nvim_win_set_cursor, state.win_left, { row, 0 })
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

local function output_key(run_id, test_id)
	return ("%s::%s"):format(run_id, test_id)
end

local function is_output_expanded(run_id, test_id)
	local key = output_key(run_id, test_id)
	local value = state._expanded[key]
	if value == nil then
		return true
	end
	return value
end

local function toggle_output_expanded(run_id, test_id)
	local key = output_key(run_id, test_id)
	state._expanded[key] = not is_output_expanded(run_id, test_id)
	request_render()
end

local function any_loading_outputs()
	for _, run in ipairs(state.runs) do
		for _, result in pairs(run.results or {}) do
			if result._output_state == "loading" then
				return true
			end
		end
	end
	return false
end

local function ensure_spinner_running()
	if state._spinner_timer or not any_loading_outputs() then
		return
	end

	local uv = vim.uv or vim.loop
	local timer = uv.new_timer()
	state._spinner_timer = timer

	timer:start(
		0,
		100,
		vim.schedule_wrap(function()
			if not any_loading_outputs() then
				if state._spinner_timer then
					state._spinner_timer:stop()
					state._spinner_timer:close()
					state._spinner_timer = nil
				end
				request_render()
				return
			end

			state._spinner_index = state._spinner_index + 1
			request_render()
		end)
	)
end

local function stop_spinner_if_idle()
	if state._spinner_timer and not any_loading_outputs() then
		state._spinner_timer:stop()
		state._spinner_timer:close()
		state._spinner_timer = nil
	end
end

local function request_output_read(result)
	if not result or not result.output then
		return
	end
	if result._output_state == "loading" or result._output_state == "ready" then
		return
	end

	result._output_state = "loading"
	ensure_spinner_running()

	nio.run(function()
		local ok, content = pcall(lib.files.read, result.output)
		vim.schedule(function()
			if ok and content and content ~= "" then
				result._output_state = "ready"
				result._output_text = content
			else
				result._output_state = "error"
				result._output_text = nil
			end
			stop_spinner_if_idle()
			request_render()
		end)
	end)
end

function render_output()
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
	local hl_lines = {}
	state._line_actions = {}

	local function add_line(text, hl, action)
		table.insert(lines, text)
		local lnum0 = #lines - 1
		if hl then
			table.insert(hl_lines, { lnum0, hl })
		end
		if action then
			state._line_actions[lnum0 + 1] = action
		end
	end

	add_line(
		string.format(
			"Run: %s\tElapsed: %s s",
			utils.fmt_time(run.started_at_ms),
			(run.finished_at_ms or utils.now_ms()) - run.started_at_ms
		),
		state.hl.title
	)
	add_line(string.format("Target: %s", run.target_label or "(unknown)"), state.hl.dim)
	add_line(string.format("Status: %s", run.status or "unknown"), state.hl.dim)

	local counts = run.counts or { passed = 0, failed = 0, skipped = 0, unknown = 0 }
	add_line(
		string.format(
			"Counts: passed=%d failed=%d skipped=%d unknown=%d",
			counts.passed,
			counts.failed,
			counts.skipped,
			counts.unknown
		),
		state.hl.dim
	)
	add_line(string.rep("-", 80), state.hl.dim)

	local results = run.results or {}
	local order = {}

	for id, result in pairs(results) do
		if result and result.status == "failed" then
			table.insert(order, id)
		end
	end
	for id, result in pairs(results) do
		if not (result and result.status == "failed") then
			table.insert(order, id)
		end
	end

	local hl_by_status = {
		passed = state.hl.passed,
		failed = state.hl.failed,
		skipped = state.hl.skipped,
		unknown = state.hl.unknown,
	}

	local function add_output_section(test_id, result)
		local expanded = is_output_expanded(run.id, test_id)
		local prefix = expanded and "▼" or "▶"

		if result and result.output and result._output_state == nil then
			result._output_state = "idle"
		end

		if result and result.output and result._output_state == "idle" then
			request_output_read(result)
		end

		local function toggle()
			toggle_output_expanded(run.id, test_id)
		end

		if result and result.output then
			if result._output_state == "loading" then
				add_line(
					("  %s Output %s"):format(prefix, get_spinner_frame(state._spinner_index)),
					state.hl.section,
					toggle
				)
				if expanded then
					table.insert(lines, "    Loading output...")
				end
				return
			end

			if result._output_state == "error" then
				add_line(("  %s Output [read error]"):format(prefix), state.hl.failed, toggle)
				if expanded then
					table.insert(lines, "    Could not read output file.")
					table.insert(lines, "    " .. tostring(result.output))
				end
				return
			end

			if result._output_state == "ready" and result._output_text and result._output_text ~= "" then
				add_line(("  %s Output"):format(prefix), state.hl.section, toggle)
				if expanded then
					vim.list_extend(lines, split_preserving_current_behavior(result._output_text))
					-- vim.iter(split_preserving_current_behavior(result._output_text)):each(function(line)
					-- 	table.insert(lines, line)
					-- end)
				end
				return
			end
		end

		local out = result and safe(result, "short", nil) or nil
		if out and out ~= "" then
			add_line(("  %s Output"):format(prefix), state.hl.section, toggle)
			if expanded then
				vim.list_extend(lines, split_preserving_current_behavior(out))
				-- vim.iter(split_preserving_current_behavior(out)):each(function(line)
				-- 	table.insert(lines, line)
				-- end)
			end
		end
	end

	local function add_test_block(id, result)
		local status = (result and result.status) or "unknown"
		local name = id

		local node = run.client and run.client:get_position(id, { adapter = run.adapter_id })
		if node then
			local data = node:data()
			name = data.name or data.path or id
		end

		add_line(string.format("[%s] %s", status:upper(), name), hl_by_status[status] or state.hl.unknown)

		if result and result.errors and #result.errors > 0 then
			for _, err in ipairs(result.errors) do
				local msg = err.message or "(error)"
				vim.list_extend(lines, split_preserving_current_behavior("  ✖ " .. msg))
				-- vim.iter(split_preserving_current_behavior("  ✖ " .. msg)):each(function(line)
				-- 	table.insert(lines, line)
				-- end)
			end
		end

		add_output_section(id, result)
		table.insert(lines, "")
	end

	local max_blocks = 2000
	local n = 0
	for _, id in ipairs(order) do
		n = n + 1
		if n > max_blocks then
			table.insert(lines, string.format("… truncated (%d tests shown)", max_blocks))
			break
		end
		add_test_block(id, results[id])
	end

	set_buf_lines(state.buf_right, lines)

	vim.api.nvim_buf_clear_namespace(state.buf_right, state.ns, 0, -1)
	for _, pair in ipairs(hl_lines) do
		apply_line_hl(state.buf_right, pair[1], pair[2])
	end
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

local function close_ui()
	if is_win_valid(state.win_left) then
		pcall(vim.api.nvim_win_close, state.win_left, true)
	end
	if is_win_valid(state.win_right) then
		pcall(vim.api.nvim_win_close, state.win_right, true)
	end
	state.win_left, state.win_right = nil, nil
	state.buf_left, state.buf_right = nil, nil
end

-- TODO: refactor these out
local function open_ui()
	vim.schedule(function()
		if is_win_valid(state.win_left) and is_win_valid(state.win_right) then
			render_history()
			render_output()
			pcall(vim.api.nvim_set_current_win, state.win_left)
			return
		end

		close_ui()

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
		vim.bo[state.buf_left].modifiable = false
		vim.bo[state.buf_right].modifiable = false

		local prev_win = vim.api.nvim_get_current_win()
		local dock_height = math.max(10, math.min(18, math.floor(vim.o.lines * 0.25)))
		vim.cmd("botright " .. dock_height .. "split")

		state.win_right = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(state.win_right, state.buf_right)
		vim.wo[state.win_right].winfixheight = true
		vim.wo[state.win_right].number = false
		vim.wo[state.win_right].relativenumber = false
		vim.wo[state.win_right].signcolumn = "no"
		vim.wo[state.win_right].wrap = true

		vim.cmd("vsplit")
		state.win_left = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(state.win_left, state.buf_left)
		vim.wo[state.win_left].winfixheight = true
		vim.wo[state.win_left].number = false
		vim.wo[state.win_left].relativenumber = false
		vim.wo[state.win_left].signcolumn = "no"
		vim.wo[state.win_left].wrap = false

		vim.cmd("wincmd h")
		state.win_left = vim.api.nvim_get_current_win()

		local list_width = math.max(40, math.min(60, math.floor(vim.o.columns * 0.30)))
		pcall(vim.api.nvim_win_set_width, state.win_left, list_width)
		vim.wo[state.win_left].winfixwidth = true

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
		map(state.buf_right, "<CR>", function()
			local row = vim.api.nvim_win_get_cursor(state.win_right)[1]
			local action = state._line_actions[row]
			if action then
				action()
			end
		end, "Toggle output section")
		map(state.buf_right, "za", function()
			local row = vim.api.nvim_win_get_cursor(state.win_right)[1]
			local action = state._line_actions[row]
			if action then
				action()
			end
		end, "Toggle output section")

		state.selected = math.max(1, math.min(state.selected, #state.runs))
		render_history()
		render_output()

		pcall(vim.api.nvim_set_current_win, prev_win)
	end)
end

-- ---------- consumer init ----------
local function init(client)
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
		state._expanded = {}
		stop_spinner_if_idle()
		if state.win_left and vim.api.nvim_win_is_valid(state.win_left) then
			render_history()
			render_output()
		end
	end, {})

	client.listeners.run = function(adapter_id, _, position_ids)
		local run_id = tostring(utils.now_ms()) .. ":" .. tostring(math.random(1000, 9999))
		state.pending_by_adapter[adapter_id] = run_id

		local target_label = resolve_target_label(client, adapter_id, position_ids)
		local run = {
			id = run_id,
			adapter_id = adapter_id,
			started_at_ms = utils.now_ms(),
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
		request_render()
	end

	client.listeners.results = function(adapter_id, results, partial)
		if partial then
			return
		end

		local run_id = state.pending_by_adapter[adapter_id]
		if not run_id then
			return
		end

		local run = vim.iter(state.runs):find(function(item)
			return item.id == run_id
		end)
		if not run then
			return
		end

		local tree = client:get_position(nil, { adapter = adapter_id })
		assert(tree, "No tree for adapter " .. adapter_id)

		run.results = vim.iter(results or {})
			:filter(function(pos_id)
				local key = tree:get_key(pos_id)
				return key and key:data().type == "test"
			end)
			:fold({}, function(acc, key, value)
				acc[key] = value
				return acc
			end)

		run.finished_at_ms = utils.now_ms()
		run.status, run.counts = compute_aggregate(run.results, run.position_ids)
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
