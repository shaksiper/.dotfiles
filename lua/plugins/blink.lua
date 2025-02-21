require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } }) -- added to scissors
require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
    enabled = function() return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false end,
    keymap = {
        preset = 'enter',
    },
    cmdline = {
        keymap = {
            preset = "default",
            -- ['<CR>'] = { 'accept', 'fallback' },
            ['<TAB>'] = { 'select_and_accept', 'fallback' },
            -- ['<S-TAB>'] = { 'select_prev', 'fallback' },
        },
    },
    -- appearance = {
    --     use_nvim_cmp_as_default = true,
    --     nerd_font_variant = 'mono',
    -- },

    -- Experimental signature help support
    signature = {
        enabled = true,
        trigger = {
            -- When true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
            show_on_insert_on_trigger_character = true,
        },
        window = {
            -- winblend = 60,
            border = 'single'
        }
    },
    completion = {
        list = {
            selection = {
                -- preselect = true,
                --   auto_insert = true,
                preselect = function(ctx)
                    return ctx.mode ~= 'cmdline' -- and not require('blink.cmp').snippet_active({ direction = 1 })
                end,
            },
        },
        documentation = {
            -- Controls whether the documentation window will automatically show when selecting a completion item
            auto_show = true,
            -- Delay before showing the documentation window
            auto_show_delay_ms = 500,
            -- Delay before updating the documentation window when selecting a new item,
            -- while an existing item is still visible
            update_delay_ms = 50,
            -- Whether to use treesitter highlighting, disable if you run into performance issues
            treesitter_highlighting = true,
            window = {
                -- winblend = 60,
                border = 'single'
            }
        },
        ghost_text = {
            enabled = true,
        },
        menu = {
            draw = {
                treesitter = { 'lsp' },
                columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
                components = {
                    kind_icon = {
                        ellipsis = false,
                        text = function(ctx)
                            local lspkind = require("lspkind")
                            local icon = ctx.kind_icon
                            if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                if dev_icon then
                                    icon = dev_icon
                                end
                            else
                                icon = require("lspkind").symbolic(ctx.kind, {
                                    mode = "symbol",
                                })
                            end

                            return icon .. ctx.icon_gap
                        end,

                        -- Optionally, use the highlight groups from nvim-web-devicons
                        -- You can also add the same function for `kind.highlight` if you want to
                        -- keep the highlight groups in sync with the icons.
                        highlight = function(ctx)
                            local hl = "BlinkCmpKind" .. ctx.kind
                                or require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
                            if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                if dev_icon then
                                    hl = dev_hl
                                end
                            end
                            return hl
                        end,
                    }
                }
            }
        },
        accept = {
            dot_repeat = true, -- causes bug, drops to background when snippet completion
            auto_brackets = { enabled = true }
        },
    },
    -- experimental auto-brackets support

    -- experimental signature help support
    -- trigger = { signature_help = { enabled = true } },
    snippets = { preset = 'luasnip' },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'luasnip_choice', 'buffer', 'nvim_lua' },
        providers = {
            -- create provider
            -- luasnip = {
            --     name = 'luasnip', -- IMPORTANT: use the same name as you would for nvim-cmp
            --     module = 'blink.compat.source',
            --     async = true,
            --     min_keyword_length = 1,
            --     -- all blink.cmp source config options work as normal:
            --     score_offset = -3,
            -- },
            nvim_lua = {
                name = 'nvim_lua',
                async = true,
                min_keyword_length = 2,
                module = 'blink.compat.source',
                score_offset = 0,
            },
            luasnip_choice =
            {
                name = 'luasnip_choice',
                async = true,
                min_keyword_length = 0,
                module = 'blink.compat.source',
                score_offset = -3,

            },
            buffer = {
                min_keyword_length = 2,
                async = true,
            }

        }
    }
}
)
