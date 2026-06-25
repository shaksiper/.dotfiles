local M = {}
local leap_select_key_ns = vim.api.nvim_create_namespace("snacks_leap_select_key")

local function is_list(value)
	return (vim.islist or vim.tbl_islist)(value)
end

local function normalize_pick_list_args(items, opts)
	if opts == nil and type(items) == "table" and items.items ~= nil and not is_list(items) then
		opts = vim.deepcopy(items)
		items = opts.items
		opts.items = nil
	end
	opts = opts or {}
	vim.validate("items", items, "table")
	return items, opts
end

local function pick_item_text(value, index, opts)
	if opts.format_item then
		local text = opts.format_item(value, index)
		if text ~= nil then
			return tostring(text)
		end
	end
	if type(value) == "table" then
		return tostring(value.text or value.label or value.name or value.title or vim.inspect(value))
	end
	return tostring(value)
end

local function pick_item(value, index, opts)
	local item = type(value) == "table" and value.text ~= nil and vim.deepcopy(value) or {}
	item.text = item.text and tostring(item.text) or pick_item_text(value, index, opts)
	if item.value == nil then
		item.value = value
	end
	item.raw = value
	item.index = item.index or index
	return item
end

local function visible_picker_targets(picker)
	local list = picker.list
	if not (list and list.win and list.win:valid()) then
		return {}
	end

	list:update({ force = true })

	local win = list.win.win
	local wininfo = vim.fn.getwininfo(win)[1]
	if not wininfo then
		return {}
	end

	local targets = {}
	for row = 1, vim.api.nvim_win_get_height(win) do
		local idx = list:row2idx(row)
		if list:get(idx) then
			targets[#targets + 1] = {
				wininfo = wininfo,
				pos = { row, 1 },
				idx = idx,
			}
		end
	end
	return targets
end

function M.leap_select(picker, _, action)
	action = type(action) == "table" and action or {}
	local close_on_cancel = action.close_on_cancel
	if close_on_cancel == nil then
		close_on_cancel = true
	end

	return picker:norm(function()
		local ok, leap = pcall(require, "leap")
		if not ok then
			require("snacks").notify.warn("leap.nvim is not available")
			return
		end

		local targets = visible_picker_targets(picker)
		if #targets == 0 then
			require("snacks").notify.warn("No visible picker items")
			return
		end

		local last_key
		local selected = false
		vim.on_key(function(key)
			last_key = key
		end, leap_select_key_ns)

		local leap_opts = vim.tbl_deep_extend("force", {
			keys = {
				next_target = "<C-n>",
				prev_target = "<C-p>",
			},
		}, action.leap_opts or {})

		vim.api.nvim_create_autocmd("User", {
			pattern = "LeapLeave",
			once = true,
			callback = function()
				vim.on_key(nil, leap_select_key_ns)
				if selected or picker.closed or last_key == vim.keycode("<CR>") or not close_on_cancel then
					return
				end
				vim.schedule(function()
					if not picker.closed then
						picker:action(action.cancel_action or "cancel")
					end
				end)
			end,
		})

		leap.leap({
			windows = { picker.list.win.win },
			targets = targets,
			opts = leap_opts,
			action = function(target)
				if picker.closed then
					return
				end
				local idx = target.idx or picker.list:row2idx(target.pos[1])
				if not picker.list:get(idx) then
					return
				end
				selected = true
				picker.list:_move(idx, true, true)
				local select_action = action.select_action
				if select_action == nil then
					select_action = "confirm"
				end
				if select_action == false then
					return
				end
				if type(select_action) == "function" then
					return select_action(picker, picker:current(), target)
				end
				picker:action(select_action)
			end,
		})
	end)
end

--- Picker through leap
---@param items snacks.picker.Item[]
---@param opts snacks.picker.util.cmd.Opts
---@return snacks.Picker
function M.pick_list(items, opts)
	items, opts = normalize_pick_list_args(items, opts)

	local on_select = opts.on_select
	local format_item = opts.format_item
	local auto_leap = opts.auto_leap
	local leap_opts = opts.leap
	local close = opts.close

	local picker_opts = vim.deepcopy(opts)
	picker_opts.auto_leap = nil
	picker_opts.close = nil
	picker_opts.format_item = nil
	picker_opts.leap = nil
	picker_opts.on_select = nil

	local normalized = {}
	for index, value in ipairs(items) do
		normalized[#normalized + 1] = pick_item(value, index, { format_item = format_item })
	end

	local user_on_show = picker_opts.on_show
	picker_opts = vim.tbl_deep_extend("force", {
		title = "Select",
		items = normalized,
		format = "text",
		preview = "none",
		main = { current = true },
		layout = { preset = "select" },
		auto_confirm = false,
	}, picker_opts)
	picker_opts.items = normalized

	if on_select then
		picker_opts.confirm = function(picker, item)
			if close ~= false then
				picker:close()
			end
			if item then
				return on_select(item.value, item, picker)
			end
		end
	elseif picker_opts.confirm == nil then
		picker_opts.confirm = function(picker)
			if close ~= false then
				picker:close()
			end
		end
	end

	picker_opts.on_show = function(picker)
		if user_on_show then
			user_on_show(picker)
		end
		if auto_leap ~= false then
			vim.schedule(function()
				if not picker.closed then
					M.leap_select(picker, nil, { leap_opts = leap_opts })
				end
			end)
		end
	end

	return require("snacks").picker(picker_opts)
end

--- Opens `paths` with the system default handler (macOS `open`, Windows `explorer.exe`, Linux
--- `xdg-open`, …), or returns (but does not show) an error message on failure.
---
--- Can also be invoked with `:Open`. [:Open]()
---
--- Expands "~/" and environment variables in filesystem paths.
---
--- Examples:
---
--- ```lua
--- -- Asynchronous.
--- vim.ui.multi_open({"https://neovim.io/", "http://github.com"})
--- vim.ui.open({"~/path/to/file", "~/path/to/another/file"})
--- -- Use the "osurl" command to handle the path or URL.
--- vim.ui.open({"gh#neovim/neovim!29490", "gh#neovim/neovim!29490"}, { cmd = { 'osurl' } })
--- -- Synchronous (wait until the process exits).
--- local cmd, err = vim.ui.open("$VIMRUNTIME")
--- if cmd then
---   cmd:wait()
--- end
--- ```
---
---@param paths string[] Path or URL to open
---@param opt? vim.ui.open.Opts Options
---
---@return vim.SystemObj|nil # Command object, or nil if not found.
---@return nil|string # Error message on failure, or nil on success.
---
---@see vim.system |vim.system()|
function M.multi_open(paths, opt)
	vim.validate("paths", paths, "table")
	vim.iter(paths):map(function(path)
		local is_uri = path:match("%w+:")
		if not is_uri then
			path = vim.fs.normalize(path)
		end
	end)

	opt = opt or {}
	local cmd ---@type string[]
	local job_opt = { text = true, detach = true } --- @type vim.SystemOpts

	if opt.cmd then
		cmd = vim.list_extend(opt.cmd --[[@as string[] ]], paths)
	else
		local open_cmd, err = vim.ui._get_open_cmd()
		if err then
			return nil, err
		end
		---@cast open_cmd string[]
		if open_cmd[1] == "xdg-open" then
			job_opt.stdout = false
			job_opt.stderr = false
		end
		cmd = vim.list_extend(open_cmd, paths)
	end
	return vim.system(cmd, job_opt), nil
end

return M
