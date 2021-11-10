require('Comment').setup({
    ignore = '^$',
    ---@param ctx Ctx
    pre_hook = function(ctx)
        local u = require('Comment.utils')
        if ctx.ctype == u.ctype.line or ctx.cmotion == u.cmotion.line then
            -- Only comment when we are doing linewise comment or up-down motion
            return require('ts_context_commentstring.internal').calculate_commentstring()
        end
    end,
})
