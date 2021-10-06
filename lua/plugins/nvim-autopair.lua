local npairs = require("nvim-autopairs")
npairs.setup({
    check_ts = true,
    ts_config = {
        php = {'comment'},
        lua = {'string'},-- it will not add a pair on that treesitter node
        javascript = {'template_string'},
        java = false,-- don't check treesitter on java
    },
    map_c_w = true,
})
