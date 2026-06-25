local M = {}

local Source = {}

local defaults = {
    max_item_chars = 200,
    max_items = 32,
    label_max_chars = 70,
    root_markers = { ".git" },
    registers = {
        enabled = true,
        include = { "0", "+", "*", '"' },
        include_numeric = false,
        include_named = true,
        max_items = 6,
        score_offset = -8,
    },
    trim = {
        enabled = true,
        selection = true,
        registers = false,
        mode = "both",
    },
    auto_trigger = {
        manual = true,
        register = true,
        luasnip = false,
    },
    score_offset = {
        manual = 8,
        luasnip_selection = 4,
        register = -8,
    },
}

local state = {
    opts = vim.deepcopy(defaults),
    projects = {},
    next_seq = 0,
    did_setup = false,
    force_all_next_request = false,
    force_all_context_id = nil,
}

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO, { title = "Crank" })
end

local function char_count(text)
    return vim.fn.strchars(text)
end

local function truncate(text, max_chars)
    if char_count(text) <= max_chars then
        return text
    end
    return vim.fn.strcharpart(text, 0, math.max(max_chars - 3, 0)) .. "..."
end

local function normalize_text(text)
    if type(text) == "table" then
        text = table.concat(text, "\n")
    end
    if type(text) ~= "string" then
        return nil
    end
    text = text:gsub("\r\n", "\n"):gsub("\r", "\n")
    return text
end

local function trim_text(text, mode)
    if mode == "before" then
        return text:gsub("^%s+", "")
    elseif mode == "after" then
        return text:gsub("%s+$", "")
    elseif mode == "both" or mode == "outer" then
        return vim.trim(text)
    end

    if mode == "lines" then
        local lines = vim.split(text, "\n", { plain = true })
        for index, line in ipairs(lines) do
            lines[index] = vim.trim(line)
        end
        return table.concat(lines, "\n")
    end

    return vim.trim(text)
end

local function trim_mode_for(source, opts)
    if opts.trim == false then
        return nil
    elseif type(opts.trim) == "string" then
        return opts.trim
    elseif opts.trim == true then
        return state.opts.trim.mode
    end

    local trim = state.opts.trim
    if not trim.enabled then
        return nil
    elseif source == "register" then
        return trim.registers and trim.mode or nil
    end

    return trim.selection and trim.mode or nil
end

local function validate_text(text, opts)
    text = normalize_text(text)
    local trim_mode = trim_mode_for(opts.source, opts)
    if text and trim_mode then
        text = trim_text(text, trim_mode)
    end

    if not text or text == "" or not text:match("%S") then
        return nil, "empty"
    end

    local limit = opts.max_item_chars or state.opts.max_item_chars
    if limit and char_count(text) > limit then
        return nil, ("over %d characters"):format(limit)
    end

    return text
end

local function project_key(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    if vim.fs and vim.fs.root then
        local ok, root = pcall(vim.fs.root, bufnr, state.opts.root_markers)
        if ok and root and root ~= "" then
            return root
        end
    end

    local name = vim.api.nvim_buf_get_name(bufnr)
    if name ~= "" then
        return vim.fs.dirname(name)
    end

    return vim.uv.cwd() or vim.fn.getcwd()
end

local function bucket_for(bufnr)
    local key = project_key(bufnr)
    if not state.projects[key] then
        state.projects[key] = { items = {}, by_text = {} }
    end
    return state.projects[key], key
end

local function remove_item(bucket, item)
    for index, existing in ipairs(bucket.items) do
        if existing == item then
            table.remove(bucket.items, index)
            return
        end
    end
end

local function add_item(bucket, item)
    local existing = bucket.by_text[item.text]
    if existing then
        remove_item(bucket, existing)
        existing.source = item.source
        existing.seq = item.seq
        item = existing
    else
        bucket.by_text[item.text] = item
    end

    table.insert(bucket.items, 1, item)

    while #bucket.items > state.opts.max_items do
        local removed = table.remove(bucket.items)
        if removed then
            bucket.by_text[removed.text] = nil
        end
    end
end

function M.add(text, opts)
    opts = opts or {}
    opts.source = opts.source or "manual"
    local valid, reason = validate_text(text, opts)
    if not valid then
        if opts.notify ~= false then
            notify("Skipped item: " .. reason, vim.log.levels.WARN)
        end
        return false
    end

    local bucket = bucket_for(opts.bufnr)
    state.next_seq = state.next_seq + 1
    add_item(bucket, {
        text = valid,
        source = opts.source,
        seq = state.next_seq,
    })

    if opts.notify ~= false then
        notify(("Added %d characters"):format(char_count(valid)))
    end

    return true
end

local function selection_positions()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "v" or mode == "V" or mode == "\022" then
        return vim.fn.getpos("v"), vim.fn.getpos("."), mode
    end

    return vim.fn.getpos("'<"), vim.fn.getpos("'>"), vim.fn.visualmode()
end

local function operator_type_to_selection_type(operator_type)
    if operator_type == "line" then
        return "V"
    elseif operator_type == "block" then
        return "\022"
    end
    return "v"
end

local function fallback_region(start_pos, end_pos, selection_type)
    local start_row, start_col = start_pos[2] - 1, start_pos[3] - 1
    local end_row, end_col = end_pos[2] - 1, end_pos[3]

    if start_row > end_row or (start_row == end_row and start_col > end_col) then
        start_row, end_row = end_row, start_row
        start_col, end_col = end_col - 1, start_col + 1
    end

    if selection_type == "V" then
        return table.concat(vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false), "\n")
    end

    return table.concat(vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {}), "\n")
end

local function region_text(start_pos, end_pos, selection_type)
    local ok, lines = pcall(vim.fn.getregion, start_pos, end_pos, { type = selection_type })
    if ok and type(lines) == "table" then
        return table.concat(lines, "\n")
    end

    return fallback_region(start_pos, end_pos, selection_type)
end

function M.add_visual(opts)
    opts = vim.tbl_extend("force", { source = "manual" }, opts or {})
    local start_pos, end_pos, selection_type = selection_positions()
    return M.add(region_text(start_pos, end_pos, selection_type), opts)
end

function M.add_operator(operator_type)
    local selection_type = operator_type_to_selection_type(operator_type)
    local start_pos = vim.fn.getpos("'[")
    local end_pos = vim.fn.getpos("']")
    return M.add(region_text(start_pos, end_pos, selection_type), { source = "manual" })
end

function M.operator_add()
    _G.CrankAddOperator = function(operator_type)
        require("completion.crank").add_operator(operator_type)
    end
    vim.go.operatorfunc = "v:lua.CrankAddOperator"
    return "g@"
end

function M.clear(opts)
    opts = opts or {}
    if opts.all then
        state.projects = {}
        notify("Cleared all projects")
        return
    end

    local _, key = bucket_for(opts.bufnr)
    state.projects[key] = nil
    notify("Cleared current project")
end

function M.project_items(bufnr)
    local bucket = bucket_for(bufnr)
    return vim.deepcopy(bucket.items)
end

local function display_text(text)
    local label = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if label == "" then
        label = "[blank]"
    end
    return truncate(label, state.opts.label_max_chars)
end

local source_names = {
    manual = "manual",
    luasnip_selection = "luasnip",
    register = "register",
}

local function source_label(entry)
    if entry.source == "register" and entry.register then
        return "reg " .. entry.register
    end

    return source_names[entry.source] or entry.source
end

local function auto_trigger_enabled(source)
    local config = state.opts.auto_trigger
    if source == "luasnip_selection" then
        return config.luasnip == true or config.luasnip_selection == true
    end

    return config[source] == true
end

local function item_score_offset(source)
    if source == "register" and state.opts.registers.score_offset then
        return state.opts.registers.score_offset
    end
    return state.opts.score_offset[source] or 0
end

local function sort_group(source)
    if source == "manual" then
        return "0"
    elseif source == "luasnip_selection" then
        return "1"
    elseif source == "register" then
        return "9"
    end
    return "5"
end

local function completion_range(ctx)
    local start_col = math.max((ctx.bounds and ctx.bounds.start_col or (ctx.cursor[2] + 1)) - 1, 0)
    return {
        start = { line = ctx.cursor[1] - 1, character = start_col },
        ["end"] = { line = ctx.cursor[1] - 1, character = ctx.cursor[2] },
    }
end

local function completion_item(entry, ctx, index)
    local kind = require("blink.cmp.types").CompletionItemKind.Reference
    return {
        label = display_text(entry.text),
        filterText = entry.text,
        sortText = sort_group(entry.source) .. string.format("%04d", index),
        kind = kind,
        kind_icon = "󰓹",
        labelDetails = {
            description = source_label(entry),
        },
        textEdit = {
            newText = entry.text,
            range = completion_range(ctx),
        },
        insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
        documentation = {
            kind = vim.lsp.protocol.MarkupKind.PlainText,
            value = entry.text,
        },
        score_offset = item_score_offset(entry.source),
    }
end

local function configured_registers()
    local cfg = state.opts.registers
    local registers = vim.deepcopy(cfg.include or {})

    if cfg.include_numeric then
        for i = 1, 9 do
            table.insert(registers, tostring(i))
        end
    end

    if cfg.include_named then
        for byte = string.byte("a"), string.byte("z") do
            table.insert(registers, string.char(byte))
        end
    end

    local seen = {}
    local result = {}
    for _, register in ipairs(registers) do
        if not seen[register] then
            table.insert(result, register)
            seen[register] = true
        end
    end

    return result
end

local function register_entries(seen_text)
    local cfg = state.opts.registers
    if not cfg.enabled then
        return {}
    end

    local entries = {}
    for _, register in ipairs(configured_registers()) do
        if #entries >= cfg.max_items then
            break
        end

        local ok, value = pcall(vim.fn.getreg, register)
        if ok then
            local text = normalize_text(value)
            text = text and text:gsub("\n$", "")
            if text then
                local valid = validate_text(text, {
                    max_item_chars = state.opts.max_item_chars,
                    source = "register",
                })
                if valid and not seen_text[valid] then
                    table.insert(entries, {
                        text = valid,
                        source = "register",
                        register = register,
                        seq = 0,
                    })
                    seen_text[valid] = true
                end
            end
        end
    end

    return entries
end

function Source:get_completions(ctx, callback)
    local items = {}
    local seen_text = {}
    local force_all = state.force_all_context_id == ctx.id
    if state.force_all_next_request then
        state.force_all_context_id = ctx.id
        state.force_all_next_request = false
        force_all = true
    end

    for index, entry in ipairs(M.project_items(ctx.bufnr)) do
        if force_all or auto_trigger_enabled(entry.source) then
            table.insert(items, completion_item(entry, ctx, index))
            seen_text[entry.text] = true
        end
    end

    local register_start_index = #items + 1
    if force_all or auto_trigger_enabled("register") then
        for index, entry in ipairs(register_entries(seen_text)) do
            table.insert(items, completion_item(entry, ctx, register_start_index + index - 1))
        end
    end

    callback({
        items = items,
        is_incomplete_backward = true,
        is_incomplete_forward = true,
    })
end

function M.new(opts)
    M.setup(opts)
    return setmetatable({}, { __index = Source })
end

function M.show()
    state.force_all_next_request = true
    return require("blink.cmp").show({
        providers = { "crank", "lsp", "path", "snippets", "luasnip_choice", "buffer", "nvim_lua", "lazydev" },
    })
end

function M.attach_luasnip_select()
    local ok, select = pcall(require, "luasnip.util.select")
    if not ok or select._crank_patched then
        return
    end

    local post_yank = select.post_yank
    select.post_yank = function(yank_register, ...)
        local reg = yank_register or "z"
        local captured = vim.fn.getreg(reg):gsub("\n$", "")
        M.add(captured, { source = "luasnip_selection", notify = false })
        return post_yank(yank_register, ...)
    end

    select._crank_patched = true
end

local function list_current_project()
    local items = M.project_items(0)
    if #items == 0 then
        notify("No items for current project")
        return
    end

    local lines = {}
    for index, item in ipairs(items) do
        table.insert(lines, ("%d. [%s] %s"):format(index, source_label(item), display_text(item.text)))
    end
    notify(table.concat(lines, "\n"))
end

local function create_commands()
    vim.api.nvim_create_user_command("CrankAdd", function(command)
        M.add(command.args, { source = "manual" })
    end, {
        nargs = "+",
        force = true,
        desc = "Add text to Crank",
    })

    vim.api.nvim_create_user_command("CrankClear", function(command)
        M.clear({ all = command.bang })
    end, {
        bang = true,
        force = true,
        desc = "Clear Crank items for the current project. Use bang to clear all projects.",
    })

    vim.api.nvim_create_user_command("CrankList", function()
        list_current_project()
    end, {
        force = true,
        desc = "List Crank items for the current project",
    })
end

function M.setup(opts)
    state.opts = vim.tbl_deep_extend("force", state.opts, opts or {})
    if state.did_setup then
        return
    end

    create_commands()
    state.did_setup = true
end

return M
