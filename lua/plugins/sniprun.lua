require'sniprun'.setup({
    display = {
        "Classic",                    --# display results in the command-line  area
        "VirtualTextOk",              --# display ok results as virtual text (multiline is shortened)

        "VirtualTextErr",          --# display error results as virtual text
        "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText__
        "NvimNotify",              --# display with the nvim-notify plugin
    },
    -- interpreter_options = {
    --     Go_original = {
    --         compiler = "go"
    --     }
    -- },
})
