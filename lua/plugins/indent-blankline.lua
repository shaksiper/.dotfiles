-- TODO: add blank indent char => ebedbed53690a53cd15b53c124eb29f9faffc1d2
vim.opt.list = true
vim.opt.listchars:append("trail:⋅")
-- vim.opt.listchars:append("tab:▸ ")
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

-- vim.g.rainbow_delimiters = { highlight = highlight }
local rainbow_delimiters = require("rainbow-delimiters")

vim.g.rainbow_delimiters = {
    highlight = highlight,
    priority = {
        c_sharp = 126
    }
}
local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)
require("ibl").setup({
    enabled = true,
    exclude = {
        filetypes = { "startify", "dashboard" },
        buftypes = { "terminal", "nofile" },
    },
    scope = {
        -- show_start = true,
        -- show_end = true,
        enabled = true,
        char = "│",
        highlight = highlight,
    },
    indent = {
        tab_char = { "│", "┊", "┆", "¦", "|", "⋅" },
        char = { "│", "┊", "┆", "¦", "|", "⋅" },
        -- highlight = highlight,
    },
})
