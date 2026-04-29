local luasnip = require("luasnip")
local s = luasnip.snippet
local i = luasnip.insert_node
local f = luasnip.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function last_path_part(args)
	local url = args[1][1] or ""

	-- remove query/hash
	url = url:gsub("[?#].*$", "")
	-- remove trailing slash(es)
	url = url:gsub("/+$", "")

	return url:match("([^/]+)$") or "title"
end

return {
	s(
		{
			trig = "linka",
			name = "Auto link",
			dscr = "Auto link",
		},
		fmt("[{}]({}){}", {
			f(last_path_part, { 1 }),
			i(1),
			i(0),
		})
	),
}
