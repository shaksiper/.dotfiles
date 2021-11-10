local color = require("plugins.feline-colors")
local c = color[color.status_color]
local cc = color[color.status_color].colors
local vi_mode_utils = require("feline.providers.vi_mode")
local icons = require("feline.defaults").separators.default_value
local _if = require("feline.providers.lsp")

local components = {
    active = {},
    inactive = {}
}
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.inactive, {})
table.insert(components.inactive, {})

-- active[1]
-- =======================================
table.insert(
    components.active[1],
    {
        provider = function()
            return '  ' .. vi_mode_utils.get_vim_mode()
        end,
        hl = function()
            local val = {}
            val.bg = vi_mode_utils.get_mode_color()
            val.fg = "dark"
            val.style = "bold"
            return val
        end
    }
)

table.insert(
    components.active[1],
    {
        provider = icons.slant_right .. ' ',
        hl = function()
            local val = {}
            val.fg = vi_mode_utils.get_mode_color()
            val.bg = "bg2"
            return val
        end
    }
)
table.insert(
    components.active[1],
    {
        provider = "file_info",
        opts = {
            type = 'unique-short'
        },
        hl = {fg = "dark", bg = "bg2", style = "bold"}
    }
)
table.insert(
    components.active[1],
    {
        provider = icons.slant_left,
        hl = {bg = "bg2", fg = "dark"},
        enabled = function()
            return vim.b.gitsigns_status_dict
        end,
        right_sep = ""
    }
)
table.insert(
    components.active[1],
    {
        provider = icons.slant_left,
        hl = {fg = "bg", bg = "bg2"},
        enabled = function()
            return not vim.b.gitsigns_status_dict
        end,
        right_sep = ""
    }
)
table.insert(
    components.active[1],
    {
        provider = "git_branch",
        hl = {bg = "dark", fg = "light", style = "bold"},
        enabled = function()
            return vim.b.gitsigns_status_dict
        end
    }
)
table.insert(
    components.active[1],
    {
        provider = "git_diff_added",
        hl = {fg = "green", style = "bold", bg = "dark"},
        enabled = function()
            return vim.b.gitsigns_status_dict
        end
    }
)
table.insert(
    components.active[1],
    {
        provider = "git_diff_changed",
        hl = {fg = "yellow", style = "bold", bg = "dark"},
        enabled = function()
            return vim.b.gitsigns_status_dict
        end
    }
)
table.insert(
    components.active[1],
    {
        provider = "git_diff_removed",
        hl = {fg = "red", style = "bold", bg = "dark"},
        enabled = function()
            return vim.b.gitsigns_status_dict
        end
    }
)
table.insert(
    components.active[1],
    {
        provider = icons.slant_right,
        hl = {fg = "dark"},
        enabled = function()
            return vim.b.gitsigns_status_dict
        end
    }
)
local gps = require("nvim-gps")
table.insert(
    components.active[1],
    {
        provider = function()
            return gps.get_location()
        end,
        enabled = function()
            return gps.is_available()
        end,
        left_sep = {
            str = icons.slant_left_2 ..icons.block.. icons.right_filled.. ' ',
            hl = { fg = "cyan"  },
        }
    }
)

-- active[2]
-- =======================================
table.insert(
    components.active[2],
    {
        provider = icons.slant_left,
        enabled = function ()
            return _if.diagnostic_errors() == ''
        end,
        hl = {fg = "red", style = "bold"},
    }
)
table.insert(
    components.active[2],
    {
        provider = "diagnostic_errors",
        hl = {fg = "bg", bg = "red", style = "bold"},
        left_sep = {str = icons.left_filled, hl = {fg = "red"}},
    }
)
table.insert(
    components.active[2],
    {
        provider = icons.left_filled,
        hl = function()
            local val = {}
            val.bg = "red"
            val.fg = "yellow"
            return val
        end
    }
)
table.insert(
    components.active[2],
    {
        provider = "diagnostic_warnings",
        hl = {fg = "bg", bg = "yellow", style = "bold"},
    }
)
table.insert(
    components.active[2],
    {
        provider = icons.left_filled,
        hl = function()
            local val = {}
            val.bg = "yellow"
            val.fg = "cyan"
            return val
        end
    }
)
table.insert(
    components.active[2],
    {
        provider = "diagnostic_info",
        hl = {fg = "bg", bg = "cyan", style = "bold"},
    }
)
table.insert(
    components.active[2],
    {
        provider = icons.left_filled,
        hl = function()
            local val = {}
            val.bg = "cyan"
            val.fg = "oceanblue"
            return val
        end
    }
)
table.insert(
    components.active[2],
    {
        provider = 'diagnostic_hints',
        hl = {bg = "oceanblue", style = "bold"},
        enabled = true,
    }
)
table.insert(
    components.active[2],
    {
        provider = "file_encoding",
        upper = false,
        hl = {style = "bold", bg = "dark"},
        left_sep = {str = icons.left_filled, hl = {fg = "dark", bg = "oceanblue"}},
        right_sep = {str = "|", hl = {bg = "dark"}}
    }
)
table.insert(
    components.active[2],
    {
        provider = "file_type",
        upper = false,
        hl = {style = "bold", bg = "dark", fg = "op"}
    }
)
table.insert(
    components.active[2],
    {
        provider = icons.slant_right,
        hl = function()
            local val = {}
            val.bg = vi_mode_utils.get_mode_color()
            val.fg = "dark"
            return val
        end
    }
)
table.insert(
    components.active[2],
    {
        provider = "position",
        icon = "",
        hl = function()
            local val = {}
            val.bg = vi_mode_utils.get_mode_color()
            val.fg = "dark"
            val.style = "bold"
            return val
        end
    }
)
table.insert(
    components.active[2],
    {
        provider = function()
            local curr_line = vim.fn.line(".")
            local lines = vim.fn.line("$")
            return string.format("| %3d%%%% ", vim.fn.round(curr_line / lines * 100))
        end,
        hl = function()
            local val = {}
            val.bg = vi_mode_utils.get_mode_color()
            val.fg = "dark"
            val.style = "bold"
            return val
        end
    }
)
table.insert(
    components.active[2],
    {
        provider = 'scroll_bar',
        hl = {
            fg = 'orange',
            style = 'bold'
        }
    }
)
-- inactive[1]
-- =======================================
table.insert(
    components.inactive[1],
    {
        provider = "file_type",
        left_sep = {str = " ", hl = {bg = "normal"}},
        hl = {fg = "dark", bg = "normal", style = "bold"},
        right_sep = {str = icons.right_filled, hl = {fg = "normal"}}
    }
)
-- inactive[2]
-- =======================================
table.insert(
    components.inactive[2],
    {
        provider = "position",
        hl = {bg = "normal", fg = "dark", style = "bold"},
        icon = "",
        left_sep = {str = icons.left_filled, hl = {fg = "normal"}}
    }
)

require("feline").setup({
    default_fg = c.default_fg,
    default_bg = c.default_bg,
    colors = {
        bg1 = cc.bg1,
        bg2 = cc.bg2,
        dark = cc.dark,
        light = cc.light,
        normal = cc.normal,
        visual = cc.visual,
        insert = cc.insert,
        replace = cc.replace,
        command = cc.command,
        op = cc.op
    },
    vi_mode_colors = {
        NORMAL = "normal",
        OP = "op",
        INSERT = "insert",
        VISUAL = "visual",
        BLOCK = "visual",
        REPLACE = "replace",
        ["V-REPLACE"] = "replace",
        ENTER = "op",
        MORE = "dark",
        SELECT = "light",
        COMMAND = "command",
        SHELL = "light",
        TERM = "op",
        NONE = "dark"
    },
    components = components
})
