local M = {}

local BIG_WIDTH = 1000000
local UNIQUE_HL = "SnacksPickerPathUnique"
local snacks

---@class snacks.picker.formatters.file.Config
---@field smart? boolean keep and highlight the directory that distinguishes duplicate basenames

---@class snacks.smart_path.Info
---@field path string
---@field parts string[]
---@field unique integer

---@class snacks.smart_path.Token
---@field text string
---@field index? integer

---@param path string
---@return string
local function basename(path)
	return path:match("([^/\\]+)[/\\]*$") or path
end

---@param path string
---@return string[]
local function split(path)
	return vim.split(path, "/", { plain = true })
end

---@param paths string[] normalized display paths with the same basename
---@return table<string, integer>
local function unique_indices(paths)
	local counts = {}
	local parts = {}
	for _, path in ipairs(paths) do
		parts[path] = split(path)
		local prefix = ""
		for index = 1, #parts[path] - 1 do
			prefix = prefix .. "\0" .. parts[path][index]
			counts[prefix] = (counts[prefix] or 0) + 1
		end
	end

	local ret = {}
	for _, path in ipairs(paths) do
		local prefix = ""
		for index = 1, #parts[path] - 1 do
			prefix = prefix .. "\0" .. parts[path][index]
			if counts[prefix] == 1 then
				ret[path] = index
				break
			end
		end
		-- One directory can be a prefix of another. In that case its last
		-- directory is the useful landmark, while the longer path has a unique
		-- directory of its own.
		if not ret[path] and #parts[path] > 1 then
			ret[path] = #parts[path] - 1
		end
	end
	return ret
end

M._unique_indices = unique_indices

---@param selected table<integer, boolean>
---@param parts string[]
---@return snacks.smart_path.Token[]
local function selected_tokens(selected, parts)
	local indices = {}
	for index in pairs(selected) do
		indices[#indices + 1] = index
	end
	table.sort(indices)

	local ret = {} ---@type snacks.smart_path.Token[]
	local previous = 0
	for _, index in ipairs(indices) do
		if index > previous + 1 then
			if #ret > 0 then
				ret[#ret + 1] = { text = "/" }
			end
			ret[#ret + 1] = { text = "…" }
		end
		if #ret > 0 then
			ret[#ret + 1] = { text = "/" }
		end
		ret[#ret + 1] = { text = parts[index], index = index }
		previous = index
	end
	return ret
end

---@param tokens snacks.smart_path.Token[]
---@return string
local function token_text(tokens)
	local ret = {}
	for _, token in ipairs(tokens) do
		ret[#ret + 1] = token.text
	end
	return table.concat(ret)
end

---@param display string
---@param full string[]
---@param kind "left"|"center"|"right"
---@return snacks.smart_path.Token[]
local function display_tokens(display, full, kind)
	local shown = split(display)
	local ret = {} ---@type snacks.smart_path.Token[]
	local ellipsis
	for index, part in ipairs(shown) do
		if part == "…" then
			ellipsis = index
			break
		end
	end

	for index, part in ipairs(shown) do
		if index > 1 then
			ret[#ret + 1] = { text = "/" }
		end
		local full_index
		if ellipsis then
			if index < ellipsis then
				full_index = index
			elseif index > ellipsis then
				full_index = #full - (#shown - index)
			end
		elseif #shown == #full then
			full_index = index
		elseif kind == "left" then
			full_index = #full - (#shown - index)
		elseif kind == "right" then
			full_index = index
		end
		ret[#ret + 1] = { text = part, index = full_index }
	end
	return ret
end

---@param tokens snacks.smart_path.Token[]
---@param info snacks.smart_path.Info
---@return boolean
local function contains_unique(tokens, info)
	for _, token in ipairs(tokens) do
		if token.index == info.unique and token.text == info.parts[info.unique] then
			return true
		end
	end
	return false
end

---@param info snacks.smart_path.Info
---@param width integer
---@param kind "left"|"center"|"right"
---@param default_path string
---@return snacks.smart_path.Token[]
local function smart_tokens(info, width, kind, default_path)
	local default = display_tokens(default_path, info.parts, kind)
	if contains_unique(default, info) then
		return default
	end

	local last = #info.parts
	local selected = { [info.unique] = true, [last] = true }
	if info.unique ~= 1 then
		selected[1] = true
	end

	local tokens = selected_tokens(selected, info.parts)
	if vim.api.nvim_strwidth(token_text(tokens)) > width and not selected[1] then
		return tokens
	elseif vim.api.nvim_strwidth(token_text(tokens)) > width and info.unique ~= 1 then
		selected[1] = nil
		tokens = selected_tokens(selected, info.parts)
	end

	-- Use spare room the same way center truncation does: favor context near
	-- the filename, without ever sacrificing the distinguishing directory.
	local candidates = {}
	for index = last - 1, 1, -1 do
		if not selected[index] then
			candidates[#candidates + 1] = index
		end
	end
	for _, index in ipairs(candidates) do
		selected[index] = true
		local expanded = selected_tokens(selected, info.parts)
		if vim.api.nvim_strwidth(token_text(expanded)) <= width then
			tokens = expanded
		else
			selected[index] = nil
		end
	end
	return tokens
end

M._smart_tokens = smart_tokens

---@param picker snacks.Picker
---@return table<snacks.picker.Item, snacks.smart_path.Info>
local function duplicate_info(picker)
	local list = picker.list
	local cache = picker._smart_path_cache
	local count = list:count()
	local tick = picker.matcher.tick
	if
		cache
		and cache.count == count
		and cache.tick == tick
		and cache.list_items == list.items
		and cache.finder_items == picker.finder.items
	then
		return cache.info
	end

	local groups = {}
	for index = 1, count do
		local item = list:get(index)
		if item and item.file then
			local name = basename(item.file)
			groups[name] = groups[name] or {}
			groups[name][#groups[name] + 1] = item
		end
	end

	local info = {}
	for _, items in pairs(groups) do
		if #items > 1 then
			local by_path = {}
			for _, item in ipairs(items) do
				local raw = snacks.picker.util.path(item) or item.file
				local path = snacks.picker.util.truncpath(raw, BIG_WIDTH, { cwd = picker:cwd(), kind = "center" })
				by_path[path] = by_path[path] or {}
				by_path[path][#by_path[path] + 1] = item
			end

			local paths = vim.tbl_keys(by_path)
			if #paths > 1 then
				local markers = unique_indices(paths)
				for path, path_items in pairs(by_path) do
					local unique = markers[path]
					if unique then
						local value = { path = path, parts = split(path), unique = unique }
						for _, item in ipairs(path_items) do
							info[item] = value
						end
					end
				end
			end
		end
	end

	picker._smart_path_cache = {
		count = count,
		tick = tick,
		list_items = list.items,
		finder_items = picker.finder.items,
		info = info,
	}
	return info
end

---@param tokens snacks.smart_path.Token[]
---@param info snacks.smart_path.Info
---@param filename_first boolean
---@param base_hl string|string[]?
---@param dir_hl string|string[]?
---@return snacks.picker.Highlight[]
local function highlight_tokens(tokens, info, filename_first, base_hl, dir_hl)
	local function highlight(token)
		local hl = token.index == info.unique and UNIQUE_HL or token.index == #info.parts and base_hl or dir_hl
		return { token.text, hl, field = "file" }
	end

	if not filename_first then
		return vim.tbl_map(highlight, tokens)
	end

	local base_index
	for index, token in ipairs(tokens) do
		if token.index == #info.parts then
			base_index = index
			break
		end
	end
	base_index = base_index or #tokens

	local ret = { highlight(tokens[base_index]), { " " } }
	local directory_end = base_index - 1
	if directory_end > 0 and tokens[directory_end].text == "/" then
		directory_end = directory_end - 1
	end
	for index = 1, directory_end do
		ret[#ret + 1] = highlight(tokens[index])
	end
	return ret
end

---@param Snacks snacks
function M.setup(Snacks)
	if M._original_filename then
		return
	end

	local function set_highlight()
		vim.api.nvim_set_hl(0, UNIQUE_HL, { link = "SnacksPickerSpecial", default = true })
	end
	set_highlight()
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("snacks_smart_path", { clear = true }),
		callback = set_highlight,
	})

	snacks = Snacks
	M._original_filename = Snacks.picker.format.filename
	Snacks.picker.format.filename = function(item, picker)
		local file_opts = picker.opts.formatters.file
		if not file_opts.smart or file_opts.filename_only or not item.file then
			return M._original_filename(item, picker)
		end

		local ret = M._original_filename(item, picker)
		local item_info = duplicate_info(picker)[item]
		if not item_info then
			return ret
		end

		for _, part in ipairs(ret) do
			if part.resolve then
				local fallback = part.resolve
				part.resolve = function(max_width)
					local width = math.max(max_width, file_opts.min_width or 20)
					local kind = file_opts.truncate or "center"
					local raw = snacks.picker.util.path(item) or item.file
					local default_path = snacks.picker.util.truncpath(raw, width, {
						cwd = picker:cwd(),
						kind = kind,
					})
					local tokens = smart_tokens(item_info, width, kind, default_path)

					local full = fallback(BIG_WIDTH)
					local base_part = file_opts.filename_first and full[1] or full[#full]
					local dir_part = file_opts.filename_first and full[3] or full[1]
					return highlight_tokens(
						tokens,
						item_info,
						file_opts.filename_first,
						base_part and base_part[2],
						dir_part and dir_part[2] or "SnacksPickerDir"
					)
				end
				break
			end
		end
		return ret
	end
end

return M
