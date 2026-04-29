local M = {}

local api = vim.api
local protocol = vim.lsp.protocol

M.ns = {
	transient = api.nvim_create_namespace("my.lsp.document_highlight.transient"),
	sticky = api.nvim_create_namespace("my.lsp.document_highlight.sticky"),
}

local seq = {}

local hl_group_by_kind = {
	[protocol.DocumentHighlightKind.Text] = "LspReferenceText",
	[protocol.DocumentHighlightKind.Read] = "LspReferenceRead",
	[protocol.DocumentHighlightKind.Write] = "LspReferenceWrite",
}

local function bump(bufnr, ns)
	seq[bufnr] = seq[bufnr] or {}
	seq[bufnr][ns] = (seq[bufnr][ns] or 0) + 1
	return seq[bufnr][ns]
end

local function current_token(bufnr, ns)
	return seq[bufnr] and seq[bufnr][ns] or 0
end

local function pos_to_byte_col(bufnr, pos, offset_encoding)
	local line = api.nvim_buf_get_lines(bufnr, pos.line, pos.line + 1, false)[1] or ""
	return vim.str_byteindex(line, offset_encoding, pos.character, false)
end

local function apply_references(bufnr, ns, refs, offset_encoding)
	for _, ref in ipairs(refs or {}) do
		local range = ref.range
		local kind = ref.kind or protocol.DocumentHighlightKind.Text

		vim.hl.range(
			bufnr,
			ns,
			hl_group_by_kind[kind] or "LspReferenceText",
			{ range.start.line, pos_to_byte_col(bufnr, range.start, offset_encoding) },
			{ range["end"].line, pos_to_byte_col(bufnr, range["end"], offset_encoding) },
			{ priority = vim.hl.priorities.user }
		)
	end
end

function M.clear(ns, bufnr)
	bufnr = bufnr or api.nvim_get_current_buf()
	bump(bufnr, ns) -- invalidate any in-flight request for this namespace
	api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

function M.request(ns, bufnr)
	bufnr = bufnr or api.nvim_get_current_buf()

	local clients = vim.lsp.get_clients({
		bufnr = bufnr,
		method = "textDocument/documentHighlight",
	})
	if vim.tbl_isempty(clients) then
		return
	end

	local token = bump(bufnr, ns)
	api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	local win = api.nvim_get_current_win()

	for _, client in ipairs(clients) do
		local offset_encoding = client.offset_encoding
		local params = vim.lsp.util.make_position_params(win, offset_encoding)

		client:request("textDocument/documentHighlight", params, function(err, result, ctx)
			if err or not result then
				return
			end

			if not api.nvim_buf_is_valid(ctx.bufnr) then
				return
			end

			-- Ignore stale replies.
			if current_token(ctx.bufnr, ns) ~= token then
				return
			end

			apply_references(ctx.bufnr, ns, result, offset_encoding)
		end, bufnr)
	end
end

return M
