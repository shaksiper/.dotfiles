local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local lspkind = require "lspkind"
lspkind.init()
local luasnip = require("luasnip")
local cmp = require('cmp')
local WIDE_HEIGHT = 40
-- TABNINE setup
local tabnine = require('cmp_tabnine.config')
tabnine:setup({
    max_lines = 1000;
    max_num_results = 20;
    sort = true;
    run_on_every_keystroke = true;
    snippet_placeholder = '..';
})
cmp.setup {
    experimental = {
        ghost_text = true,
    },
    -- You can set mappings if you want
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        -- ['<CR>'] = cmp.mapping.confirm({
        --     behavior = cmp.ConfirmBehavior.Insert,
        --     select = true,
        -- }),
        ['<CR>'] = cmp.mapping({
            -- i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
            c = cmp.mapping.confirm({ select = false }),
            -- c = function(fallback)
            --     if cmp.visible() then
            --         cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
            --     else
            --         fallback()
            --     end
            -- end,
        }),
        ['<C-J>'] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
        }),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip and luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, { "i", "s", 'c'}),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip and luasnip.jumpable(-1) then
                luasnip.jump(-1)
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s", 'c'}),
    },
    snippet = {
        expand = function(args)
            require'luasnip'.lsp_expand(args.body)
        end
    },
    -- You should specify your *installed* sources.
    sources = {
        { name = 'nvim_lsp' },
        { name = 'cmp_tabnine' },
        { name = 'buffer', keyword_length = 4, max_item_count = 15},
        { name = 'luasnip' },
        { name = 'treesitter' },
        -- { name = 'neorg' },
        -- { name = 'tags' },
        { name = 'path' },
        { name = 'nvim_lua' },
        -- { name = 'look' },
        { name = 'calc' },
    },
    documentation = {
        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        winhighlight = 'NormalFloat:CmpDocumentation,FloatBorder:CmpDocumentationBorder',
        maxwidth = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
        maxheight = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
    },
    formatting = {
        -- format = function(entry, vim_item)
        --     -- vim_item.abbr = require("lspkind").presets.default[vim_item.kind] .." ".. vim_item.abbr
        --     -- fancy icons and a name of kind
        --     vim_item.kind = require("lspkind").presets.default[vim_item.kind]
        --         .. " "
        --         .. vim_item.kind
        --     -- set a name for each source
        --     vim_item.menu = ({
        --         buffer = "[Buffer]",
        --         nvim_lsp = "[LSP]",
        --         luasnip = "[LuaSnip]",
        --         nvim_lua = "[Lua]",
        --         treesitter = "[TS]",
        --     })[entry.source.name]
        --     return vim_item
        -- end,
        format = lspkind.cmp_format {
            with_text = true,
            menu = {
                buffer = "[buf]",
                cmp_tabnine = "[T9]",
                nvim_lsp = "[lsp]",
                nvim_lua = "[nlua]",
                path = "[path]",
                luasnip = "[snip]",
                treesitter = '[tsit]',
            }
        }
    },
}
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
            { name = 'cmdline' }
        })
})
local cmp_search_config = {
    sources = cmp.config.sources({
        { name = 'nvim_lsp_document_symbol' }
    }, {
            { name = 'buffer' }
        })
}
cmp.setup.cmdline('/', cmp_search_config)
cmp.setup.cmdline('?', cmp_search_config)
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done())

require("luasnip/loaders/from_vscode").load() --friendly-snippts should work after this
-- you need setup cmp first put this after cmp.setup()
-- require("nvim-autopairs.completion.cmp").setup({
--   map_cr = true, --  map <CR> on insert mode
--   map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
--   auto_select = true, -- automatically select the first item
--   insert = true, -- use insert confirm behavior instead of replace
--   map_char = { -- modifies the function or method delimiter by filetypes
--     all = '(',
--     tex = '{'
--   }
-- })
