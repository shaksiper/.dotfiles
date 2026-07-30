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

local function strip_ansi(text)
	if type(text) == "table" then
		local ok_ansi, ansi = pcall(require, "baleia.ansi")
		if ok_ansi and type(ansi.strip) == "function" then
			return ansi.strip(text)
		end

		local stripped = {}
		for _, line in ipairs(text) do
			table.insert(stripped, (line:gsub("\27%[[:;0-9]*m", "")))
		end
		return stripped
	end

	local ok_ansi, ansi = pcall(require, "baleia.ansi")
	if ok_ansi and type(ansi.strip) == "function" then
		return ansi.strip(text)
	end
	return (text:gsub("\27%[[:;0-9]*m", ""))
end

local function trim(s)
	return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function is_absolute_path(path)
	return path:sub(1, 1) == "/" or path:match("^%a:[/\\]") ~= nil
end

local function stat_file(path)
	local uv = vim.uv or vim.loop
	local stat = path and uv.fs_stat(path) or nil
	return stat and stat.type == "file"
end

local function clean_path(path)
	path = trim(path)
	path = path:gsub("^['\"`<]+", ""):gsub("[>'\"`,.;]+$", "")
	if not path:match("^%a:[/\\]") then
		path = path:gsub("\\", "/")
	end
	return path
end

local function path_candidates(path, context_path)
	path = clean_path(path)
	if path == "" or path:match("^https?://") then
		return {}
	end
	if path:sub(1, 1) == "~" then
		path = vim.fn.expand(path)
	end
	if is_absolute_path(path) then
		return { vim.fs.normalize(path) }
	end

	local candidates = {}
	local seen = {}
	local function add(candidate)
		candidate = vim.fs.normalize(candidate)
		if not seen[candidate] then
			table.insert(candidates, candidate)
			seen[candidate] = true
		end
	end

	add(vim.fs.joinpath(vim.fn.getcwd(), path))

	local dir = context_path and vim.fs.dirname(vim.fs.normalize(context_path)) or nil
	while dir and dir ~= "" do
		add(vim.fs.joinpath(dir, path))
		local parent = vim.fs.dirname(dir)
		if parent == dir then
			break
		end
		dir = parent
	end

	return candidates
end

local function resolve_file(path, context_path)
	local candidates = path_candidates(path, context_path)
	for _, candidate in ipairs(candidates) do
		if stat_file(candidate) then
			return candidate
		end
	end
	return candidates[1]
end

local function uri_for_location(location)
	if not location or not location.filename then
		return nil
	end
	local uri = vim.uri_from_fname(location.filename)
	if location.lnum then
		uri = ("%s#L%d"):format(uri, location.lnum)
	end
	return uri
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
	parent_win = nil,

	ns = vim.api.nvim_create_namespace("neotest_run_history"),
	hl = {
		title = "Title",
		dim = "Comment",
		passed = "DiffAdd",
		failed = "DiffDelete",
		skipped = "DiffChange",
		unknown = "Normal",
		section = "Special",
		output_error = "NeotestRunHistoryError",
		output_warn = "NeotestRunHistoryWarn",
		output_info = "NeotestRunHistoryInfo",
		stack = "NeotestRunHistoryStack",
		file = "NeotestRunHistoryFile",
		expected = "NeotestRunHistoryExpected",
		actual = "NeotestRunHistoryActual",
	},

	_render_scheduled = false,
	_spinner_index = 1,
	_spinner_timer = nil,
	_line_actions = {},
	_line_links = {},
	_line_locations = {},
	_expanded = {},
}

local function ensure_hls()
	local links = {
		NeotestRunHistoryError = "DiagnosticError",
		NeotestRunHistoryWarn = "DiagnosticWarn",
		NeotestRunHistoryInfo = "DiagnosticInfo",
		NeotestRunHistoryStack = "Comment",
		NeotestRunHistoryExpected = "DiffDelete",
		NeotestRunHistoryActual = "DiffAdd",
	}

	for group, target in pairs(links) do
		pcall(vim.api.nvim_set_hl, 0, group, { link = target, default = true })
	end
	pcall(vim.api.nvim_set_hl, 0, "NeotestRunHistoryFile", { underline = true, default = true })
end

local function set_buf_lines(buf, lines, opts)
	if not (buf and vim.api.nvim_buf_is_valid(buf)) then
		return
	end
	opts = opts or {}

	local ok_mod = pcall(function()
		vim.bo[buf].modifiable = true
	end)
	if not ok_mod then
		return
	end

	local ok, err
	if opts.ansi and vim.g.baleia and type(vim.g.baleia.buf_set_lines) == "function" then
		ok, err = pcall(vim.g.baleia.buf_set_lines, buf, 0, -1, false, lines)
	else
		ok, err = pcall(vim.api.nvim_buf_set_lines, buf, 0, -1, false, opts.ansi and strip_ansi(lines) or lines)
	end

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
	if not (buf and vim.api.nvim_buf_is_valid(buf)) then
		return
	end
	local line = vim.api.nvim_buf_get_lines(buf, lnum0, lnum0 + 1, false)[1] or ""
	pcall(vim.api.nvim_buf_set_extmark, buf, state.ns, lnum0, 0, {
		end_col = #line,
		hl_eol = true,
		hl_group = hl,
		priority = 20,
	})
end

local function apply_range_hl(buf, lnum0, start_col, end_col, hl, opts)
	if not (buf and vim.api.nvim_buf_is_valid(buf)) or end_col <= start_col then
		return
	end
	opts = opts or {}
	pcall(vim.api.nvim_buf_set_extmark, buf, state.ns, lnum0, start_col, {
		end_col = end_col,
		hl_group = hl,
		priority = opts.priority or 120,
		url = opts.url,
	})
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

local known_source_extensions = {
	cs = true,
	cshtml = true,
	fs = true,
	fsx = true,
	js = true,
	jsx = true,
	lua = true,
	razor = true,
	ts = true,
	tsx = true,
	vb = true,
	xaml = true,
}

local function looks_like_source_path(path)
	path = clean_path(path)
	if path == "" or path:match("^https?://") then
		return false
	end
	if path:find("[/\\]") or path:match("^%.%.?[/\\]") then
		return true
	end
	local ext = path:match("%.([%w_]+)$")
	return ext and known_source_extensions[ext:lower()] or false
end

local function add_file_link(links, seen, line, start_idx, end_idx, raw_path, lnum, col, context_path)
	local path = clean_path(raw_path)
	if not looks_like_source_path(path) then
		return
	end

	local filename = resolve_file(path, context_path)
	if not filename then
		return
	end

	local location = {
		filename = filename,
		lnum = math.max(1, tonumber(lnum) or 1),
		col = math.max(1, tonumber(col) or 1),
	}
	local key = ("%d:%d:%s:%d:%d"):format(start_idx, end_idx, location.filename, location.lnum, location.col)
	if seen[key] then
		return
	end

	table.insert(links, {
		start_col = start_idx - 1,
		end_col = end_idx,
		target = location,
		url = uri_for_location(location),
		text = line:sub(start_idx, end_idx),
	})
	seen[key] = true
end

local function parse_dotnet_stack_links(line, links, seen, context_path)
	local search_start = 1
	while true do
		local _, in_end = line:find("%s+in%s+", search_start)
		if not in_end then
			return
		end

		local line_start, line_end, lnum = line:find(":line%s+(%d+)", in_end + 1)
		if not line_start then
			search_start = in_end + 1
		else
			add_file_link(
				links,
				seen,
				line,
				in_end + 1,
				line_end,
				line:sub(in_end + 1, line_start - 1),
				lnum,
				1,
				context_path
			)
			search_start = line_end + 1
		end
	end
end

local function parse_pattern_links(line, links, seen, context_path)
	local patterns = {
		{
			pattern = "([%w%._%-%+~/%\\:][%w%._%-%+~/%\\: ]-%.%w+)%((%d+),(%d+)%)",
			has_col = true,
		},
		{
			pattern = "([%w%._%-%+~/%\\:][%w%._%-%+~/%\\: ]-%.%w+)%((%d+)%)",
		},
		{
			pattern = "([%w%._%-%+~/%\\:][%w%._%-%+~/%\\: ]-%.%w+):(%d+):(%d+)",
			has_col = true,
		},
		{
			pattern = "([%w%._%-%+~/%\\:][%w%._%-%+~/%\\: ]-%.%w+):(%d+)",
		},
	}

	for _, matcher in ipairs(patterns) do
		local search_start = 1
		while true do
			local start_idx, end_idx, path, lnum, col = line:find(matcher.pattern, search_start)
			if not start_idx then
				break
			end
			add_file_link(links, seen, line, start_idx, end_idx, path, lnum, matcher.has_col and col or 1, context_path)
			search_start = end_idx + 1
		end
	end
end

local function parse_file_links(line, context_path)
	local links = {}
	local seen = {}
	parse_dotnet_stack_links(line, links, seen, context_path)
	parse_pattern_links(line, links, seen, context_path)
	table.sort(links, function(a, b)
		return a.start_col < b.start_col
	end)
	return links
end

local function output_line_hl(line)
	if line:match("^%s*Expected%s*:") or line:match("^%s*Expected%s") then
		return state.hl.expected
	end
	if line:match("^%s*Actual%s*:") or line:match("^%s*Actual%s") then
		return state.hl.actual
	end
	if line:match("^%s*at%s+") or line:match("^%s*%-%-%-%s") then
		return state.hl.stack
	end
	if line:match("[Ee]xception") or line:match("%f[%a][Ee]rror%f[%A]") or line:match("%f[%a][Ff]ailed%f[%A]") then
		return state.hl.output_error
	end
	if line:match("%f[%a][Ww]arn") then
		return state.hl.output_warn
	end
	return nil
end

local function error_location(node, err)
	if not node then
		return nil
	end

	local data = node:data()
	if not data or not data.path then
		return nil
	end

	local range = node.closest_value_for and node:closest_value_for("range") or data.range
	local line0 = err and err.line or (range and range[1]) or (data.range and data.range[1]) or 0
	local col0 = (range and range[2]) or (data.range and data.range[2]) or 0
	return {
		filename = vim.fs.normalize(data.path),
		lnum = math.max(1, line0 + 1),
		col = math.max(1, col0 + 1),
	}
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
	local range_hls = {}
	state._line_actions = {}
	state._line_links = {}
	state._line_locations = {}

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

	local function add_output_lines(text, opts)
		opts = opts or {}
		for _, raw_line in ipairs(split_preserving_current_behavior(text)) do
			table.insert(lines, raw_line)
			local lnum0 = #lines - 1
			local row = lnum0 + 1
			local visible_line = strip_ansi(raw_line)
			local line_hl = output_line_hl(visible_line) or opts.line_hl
			local links = parse_file_links(visible_line, opts.context_path)

			if line_hl then
				table.insert(hl_lines, { lnum0, line_hl })
			end
			if opts.default_location then
				state._line_locations[row] = opts.default_location
			end
			if #links > 0 then
				state._line_links[row] = links
				for _, link in ipairs(links) do
					table.insert(range_hls, {
						lnum0 = lnum0,
						start_col = link.start_col,
						end_col = link.end_col,
						hl = state.hl.file,
						url = link.url,
					})
				end
			end
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

	local function add_output_section(test_id, result, node)
		local expanded = is_output_expanded(run.id, test_id)
		local prefix = expanded and "▼" or "▶"
		local context_path = node and node:data() and node:data().path or nil

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
					add_output_lines(result._output_text, { context_path = context_path })
				end
				return
			end
		end

		local out = result and safe(result, "short", nil) or nil
		if out and out ~= "" then
			add_line(("  %s Output"):format(prefix), state.hl.section, toggle)
			if expanded then
				add_output_lines(out, { context_path = context_path })
			end
		end
	end

	local function add_test_block(id, result)
		local status = (result and result.status) or "unknown"
		local name = id

		local node = run.client and run.client:get_position(id, { adapter = run.adapter_id })
		local data
		if node then
			data = node:data()
			name = data.name or data.path or id
		end

		add_line(string.format("[%s] %s", status:upper(), name), hl_by_status[status] or state.hl.unknown)

		if result and result.errors and #result.errors > 0 then
			for _, err in ipairs(result.errors) do
				local msg = err.message or "(error)"
				add_output_lines("  ✖ " .. msg, {
					context_path = data and data.path or nil,
					default_location = error_location(node, err),
					line_hl = state.hl.output_error,
				})
			end
		end

		add_output_section(id, result, node)
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

	set_buf_lines(state.buf_right, lines, { ansi = true })

	vim.api.nvim_buf_clear_namespace(state.buf_right, state.ns, 0, -1)
	for _, pair in ipairs(hl_lines) do
		apply_line_hl(state.buf_right, pair[1], pair[2])
	end
	for _, item in ipairs(range_hls) do
		apply_range_hl(state.buf_right, item.lnum0, item.start_col, item.end_col, item.hl, { url = item.url })
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

local function is_run_history_win(win)
	if not is_win_valid(win) then
		return false
	end
	local buf = vim.api.nvim_win_get_buf(win)
	return buf == state.buf_left or buf == state.buf_right
end

local function find_parent_win()
	if is_win_valid(state.parent_win) and not is_run_history_win(state.parent_win) then
		return state.parent_win
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if not is_run_history_win(win) then
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].buftype == "" then
				return win
			end
		end
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if not is_run_history_win(win) then
			return win
		end
	end
end

local function jump_to_location(location)
	if not (location and location.filename) then
		return false
	end

	local win = find_parent_win()
	if win then
		pcall(vim.api.nvim_set_current_win, win)
	else
		pcall(vim.cmd, "aboveleft split")
		win = vim.api.nvim_get_current_win()
	end

	local ok, err = pcall(vim.cmd, "edit " .. vim.fn.fnameescape(location.filename))
	if not ok then
		vim.notify(("run_history: failed to open %s: %s"):format(location.filename, err), vim.log.levels.ERROR)
		return false
	end

	local lnum = math.max(1, tonumber(location.lnum) or 1)
	local line_count = vim.api.nvim_buf_line_count(0)
	lnum = math.min(lnum, line_count)
	local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
	local col = math.max(0, (tonumber(location.col) or 1) - 1)
	col = math.min(col, #line)
	pcall(vim.api.nvim_win_set_cursor, win or 0, { lnum, col })
	pcall(vim.cmd, "normal! zv")
	return true
end

local function details_location_under_cursor()
	if not is_win_valid(state.win_right) then
		return nil
	end

	local cursor = vim.api.nvim_win_get_cursor(state.win_right)
	local row = cursor[1]
	local col = cursor[2]
	local links = state._line_links[row] or {}
	for _, link in ipairs(links) do
		if col >= link.start_col and col < link.end_col then
			return link.target
		end
	end

	if #links == 1 then
		return links[1].target
	end
	return state._line_locations[row]
end

local function activate_details_line(prefer_location)
	local location = details_location_under_cursor()
	if location then
		jump_to_location(location)
		return
	end

	if not prefer_location and is_win_valid(state.win_right) then
		local row = vim.api.nvim_win_get_cursor(state.win_right)[1]
		local action = state._line_actions[row]
		if action then
			action()
		end
	end
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
	state.parent_win = nil
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
		if not is_run_history_win(prev_win) then
			state.parent_win = prev_win
		end
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
			activate_details_line(false)
		end, "Open location or toggle output section")
		map(state.buf_right, "za", function()
			local row = vim.api.nvim_win_get_cursor(state.win_right)[1]
			local action = state._line_actions[row]
			if action then
				action()
			end
		end, "Toggle output section")
		map(state.buf_right, "gf", function()
			activate_details_line(true)
		end, "Open file location")

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
