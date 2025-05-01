local luasnip = require("luasnip")
local types = require("luasnip.util.types")
luasnip.config.setup({
    -- Remember the last snippet I was in
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "●", "TSString" } },
            },
        },
        [types.insertNode] = {
            active = {
                virt_text = { { "●", "TSKeyword" } },
            },
        },
    },
})
