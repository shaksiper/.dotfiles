local Snacks = require("snacks")
local lib = require("neotest.lib")
local config = require("neotest.config")
local nio = require("nio")
local Tree = require("neotest.types").Tree

---@class neotest.select
local M = {}

---@type neotest.Client?
local client
local last_marked_run
local run_last_patched = false
local stock_run_last
local marked_roots = {}

local function is_leaf_test(node)
	local position = node:data()
	return position.type == "test" and #node:children() == 0
end

local function status_for(adapter_id, position)
	local result = client:get_results(adapter_id)[position.id]
	if result then
		return result.status
	elseif client:is_running(position.id, { adapter = adapter_id }) then
		return "running"
	end
	return position.type
end

local function node_scope(node)
	local parts = {}
	for parent in node:iter_parents() do
		local position = parent:data()
		if position.type ~= "dir" and position.type ~= "file" and position.name ~= "" then
			table.insert(parts, 1, position.name)
		end
	end
	return table.concat(parts, " > ")
end

local function item_location(node, position)
	local path = position.path
	local range = position.range or node:closest_value_for("range")
	local row = range and range[1] + 1 or nil
	local col = range and range[2] + 1 or nil
	local location = path and nio.fn.fnamemodify(path, ":.") or position.id

	if row then
		location = ("%s:%d"):format(location, row)
	end

	return location, row, col
end

local function test_item(adapter_id, node, index)
	local position = node:data()
	local status = status_for(adapter_id, position)
	local icon = config.icons[status] or config.icons.test or " "
	local status_hl = config.highlights[status] or config.highlights.test
	local location, row, col = item_location(node, position)
	local scope = node_scope(node)

	return {
		idx = index,
		id = position.id,
		adapter_id = adapter_id,
		position = position,
		status = status,
		status_icon = icon,
		status_hl = status_hl,
		name = position.name,
		scope = scope,
		location = location,
		file = position.path,
		pos = row and { row, col or 1 } or nil,
		text = table.concat({
			position.name,
			scope,
			location,
			status,
			adapter_id,
		}, " "),
	}
end

---@param opts? {adapter?: string}
local function collect_items(opts)
	opts = opts or {}
	local adapters = opts.adapter and { opts.adapter } or client:get_adapters()
	local items = {}

	for _, adapter_id in ipairs(adapters) do
		local tree = client:get_position(nil, { adapter = adapter_id })
		if tree then
			for _, node in tree:iter_nodes() do
				if is_leaf_test(node) then
					items[#items + 1] = test_item(adapter_id, node, #items + 1)
				end
			end
		end
	end

	return items
end

local function format_test(item)
	local ret = {}

	ret[#ret + 1] = { item.status_icon, item.status_hl }
	ret[#ret + 1] = { " " }
	ret[#ret + 1] = { item.name, config.highlights.test }

	if item.scope ~= "" then
		ret[#ret + 1] = { " " }
		ret[#ret + 1] = { item.scope, config.highlights.namespace }
	end

	ret[#ret + 1] = { " " }
	ret[#ret + 1] = { item.location, "Comment" }

	return ret
end

local function augment_args(tree, args)
	args = vim.deepcopy(args or {})

	local aug = config.run.augment
	if not aug then
		return args
	end

	nio.scheduler()
	return aug(tree, args)
end

local function marked_groups(items)
	local groups = {}

	for _, item in ipairs(items) do
		groups[item.adapter_id] = groups[item.adapter_id] or {}
		table.insert(groups[item.adapter_id], item.id)
	end

	return groups
end

local function marked_tree(adapter_id, ids)
	local positions = {}
	local missing = {}
	local first_parent

	for _, id in ipairs(ids) do
		local node = client:get_position(id, { adapter = adapter_id })
		if node and is_leaf_test(node) then
			first_parent = first_parent or node:parent()
			positions[#positions + 1] = vim.deepcopy(node:data())
		else
			missing[#missing + 1] = id
		end
	end

	if #missing > 0 then
		lib.notify(("Skipped %d stale marked test(s)"):format(#missing), vim.log.levels.WARN)
	end

	if #positions == 0 then
		return
	end

	if #positions == 1 then
		return client:get_position(positions[1].id, { adapter = adapter_id })
	end

	local tree = Tree.from_list(positions, function(position)
		return position.id
	end)
	-- Keep Neotest's original root for project-level config lookup while running only marked leaves.
	tree._parent = first_parent
	return tree
end

local function store_marked_run(groups, run_args)
	last_marked_run = {
		groups = vim.deepcopy(groups),
		run_args = vim.deepcopy(run_args or {}),
	}
end

local function run_marked_groups(groups, run_args, opts)
	opts = opts or {}
	run_args = vim.deepcopy(run_args or {})

	if opts.store ~= false then
		store_marked_run(groups, run_args)
	end

	for adapter_id, ids in pairs(groups) do
		local tree = marked_tree(adapter_id, ids)
		if tree then
			local args = vim.tbl_extend("force", vim.deepcopy(run_args), {
				adapter = adapter_id,
			})
			marked_roots[tree:data().id] = true
			client:run_tree(tree, augment_args(tree, args))
		end
	end
end

local run_marked_groups_async = nio.create(run_marked_groups, 3)

local function patch_run_last()
	if run_last_patched then
		return
	end

	local neotest = require("neotest")
	if not (neotest.run and neotest.run.run_last) then
		return
	end

	stock_run_last = neotest.run.run_last
	neotest.run.run_last = function(args)
		if last_marked_run then
			run_marked_groups_async(
				last_marked_run.groups,
				vim.tbl_extend("keep", args or {}, last_marked_run.run_args or {}),
				{ store = false }
			)
			return
		end

		return stock_run_last(args)
	end

	run_last_patched = true
end

local function run_items(items, opts)
	if #items > 1 then
		local groups = marked_groups(items)
		local run_args = vim.deepcopy(opts.run_args or {})
		patch_run_last()
		run_marked_groups_async(groups, run_args)
		return
	end

	local run_args = vim.deepcopy(opts.run_args or {})
	for _, item in ipairs(items) do
		require("neotest").run.run(vim.tbl_extend("force", run_args, {
			item.id,
			adapter = item.adapter_id,
		}))
	end
end

---@class neotest.select.OpenArgs : snacks.picker.Config
---@field adapter? string Only list tests for a specific adapter id
---@field run_args? neotest.run.RunArgs Extra args passed to neotest.run.run
---@field mappings? neotest.select.Mappings

---@class neotest.select.Mappings
---@field debug? string|false Debug selected tests with DAP (default: `<C-d>`)

---Open a Snacks picker for discovered leaf tests.
---@param opts? neotest.select.OpenArgs
function M.open(opts)
	opts = opts or {}
	local items = collect_items(opts)
	local mappings = vim.tbl_extend("force", {
		debug = "<C-d>",
	}, opts.mappings or {})

	nio.scheduler()

	if #items == 0 then
		lib.notify("No leaf tests found", vim.log.levels.WARN)
		return
	end

	local picker_opts = vim.deepcopy(opts)
	picker_opts.adapter = nil
	picker_opts.mappings = nil
	picker_opts.run_args = nil

	local debug_keys = {}
	if mappings.debug then
		debug_keys[mappings.debug] = { "debug", mode = { "n", "i" }, desc = "Debug selected tests" }
	end

	picker_opts = vim.tbl_deep_extend("force", {
		title = "Neotest",
		items = items,
		format = format_test,
		layout = { preset = "select" },
		main = { current = true },
		auto_confirm = false,
		formatters = {
			selected = {
				show_always = true,
			},
		},
		actions = {
			debug = function(picker)
				local selected = picker:selected({ fallback = true })
				picker:close()
				local debug_opts = vim.deepcopy(opts)
				debug_opts.run_args = vim.tbl_extend("force", debug_opts.run_args or {}, {
					strategy = "dap",
				})
				run_items(selected, debug_opts)
			end,
		},
		win = {
			input = { keys = debug_keys },
			list = { keys = debug_keys },
		},
		confirm = function(picker)
			local selected = picker:selected({ fallback = true })
			picker:close()
			run_items(selected, opts)
		end,
	}, picker_opts)

	Snacks.picker(picker_opts)
end

M.open = nio.create(M.open, 1)

setmetatable(M, {
	---@param client_ neotest.Client
	__call = function(_, client_)
		client = client_
		client.listeners.run = function(_, root_id)
			if marked_roots[root_id] then
				marked_roots[root_id] = nil
				return
			end

			last_marked_run = nil
		end
		return M
	end,
})

return M
