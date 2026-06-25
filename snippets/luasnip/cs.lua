local function get_node_at_cursor(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
	if not ok or not parser then
		return nil
	end

	parser:parse()

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1

	return vim.treesitter.get_node({
		bufnr = bufnr,
		pos = { row, col },
		ignore_injections = false,
	})
end

local function find_parent(node, wanted)
	while node do
		if node:type() == wanted then
			return node
		end
		node = node:parent()
	end

	return nil
end

local function inside_invocation_argument_list()
	local bufnr = vim.api.nvim_get_current_buf()
	local node = get_node_at_cursor(bufnr)

	if not node then
		return false
	end

	local arg_list = find_parent(node, "argument_list")
	if not arg_list then
		return false
	end

	local parent = arg_list:parent()
	if not parent then
		return false
	end

	return parent:type() == "invocation_expression"
end

local function argument_list_text_contains_lambda()
	local bufnr = vim.api.nvim_get_current_buf()
	local node = get_node_at_cursor(bufnr)
	local arg_list = find_parent(node, "argument_list")

	if not arg_list then
		return false
	end

	local text = vim.treesitter.get_node_text(arg_list, bufnr)
	return text:find("=>", 1, true) ~= nil
end

local function should_expand_predicate_snippet()
	return inside_invocation_argument_list() and not argument_list_text_contains_lambda()
end

local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node

local function selected_text(parent)
	local env = (parent and parent.snippet and parent.snippet.env) or (parent and parent.env) or {}

	-- LuaSnip commonly exposes visual selections through SELECT_RAW.
	local raw_selection = env.LS_SELECT_RAW or env.SELECT_RAW
	if type(raw_selection) == "table" and #raw_selection > 0 then
		return table.concat(raw_selection, "\n")
	elseif type(raw_selection) == "string" and raw_selection ~= "" then
		return raw_selection
	end

	-- Some setups/snippet formats expose TM_SELECTED_TEXT.
	local selected = env.TM_SELECTED_TEXT
	if type(selected) == "table" and #selected > 0 then
		return table.concat(selected, "\n")
	elseif type(selected) == "string" and selected ~= "" then
		return selected
	end

	return nil
end

local function selected_or_mirror(args, parent)
	local selected = selected_text(parent)
	local fallback = args[1] and args[1][1] or "x"

	if selected and selected ~= "" then
		return sn(nil, {
			i(1, selected),
		})
	end

	if fallback == "" then
		fallback = "x"
	end

	return sn(nil, {
		i(1, fallback),
	})
end

return {
	s({
		trig = "pred",
		name = "lambda predicate",
		dscr = "x => x",
		wordTrig = true,
	}, {
		i(1, "x"),
		t(" => "),
		d(2, selected_or_mirror, { 1 }),
		i(0),
	}, {
		show_condition = inside_invocation_argument_list,
		condition = should_expand_predicate_snippet,
	}),
}
