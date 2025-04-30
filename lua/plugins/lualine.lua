-- local navic = require("nvim-navic")
local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
        }
    end
end
require("lualine").setup({
    options = {
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_b = { { 'b:gitsigns_head', icon = '' }, { 'diff', source = diff_source }, 'diagnostics' },
    },
    extensions = {
        "oil",
        "nvim-dap-ui",
        "overseer",
        "trouble"
    },
    --[[ sections = {
		lualine_c = {
			{ navic.get_location, cond = navic.is_available },
		},
	}, ]]
})
