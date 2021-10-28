local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
require("tsht").config.hint_keys = { "h", "j", "f", "d", "n", "v", "s", "l", "a" }
parser_configs.norg = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main"
    },
}
require'nvim-treesitter.configs'.setup {
    --[[ element_textobject = {
        enable = false,
        set_jumps = false,
        keymaps = {
            ['e'] = 'goto_next_element',
            ['E'] = 'goto_prev_element',
            [']e'] = 'swap_next_element',
            ['[e'] = 'swap_prev_element',
            ['ie'] = 'inner_element',
            ['ae'] = 'an_element',
        }
    }, --]]
    --[[ scope_textobject = {
        enable = false,
        set_jumps = true,
        keymaps = {
            ['s'] = 'incremental_outer_scope',
            [']s'] = 'goto_next_scope',
            ['[s'] = 'goto_prev_scope',
            ['as'] = 'a_scope',
        }
    }, --]]
    ensure_installed = "php", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },
    highlight = {
        enable = true,              -- false will disable the whole extension
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    context_commentstring = {
        enable = true
    },
    autotag = {
        enable = true,
        filetypes = { "html" , "xml", "php", "javascript"},
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gsn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    indent = {
        enable = true
    },
    refactor = {
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "gtd",
                list_definitions = "gld",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
            },
        },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "grr",
            },
        },
        highlight_definitions = { enable = true },
    },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["ae"] = "@parameter.outer",
                ["ie"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]e"] = "@parameter.inner",
                ["]s"] = "@statement.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]E"] = "@parameter.inner",
                ["]S"] = "@statement.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[e"] = "@parameter.inner",
                ["[s"] = "@statement.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[E"] = "@parameter.inner",
                ["[S"] = "@statement.outer",
                ["[]"] = "@class.outer",
            },
        },
        lsp_interop = {
            enable = false,
            border = 'single',
            peek_definition_code = {
                ["df"] = "@function.outer",
                ["dF"] = "@class.outer",
            },
        },

    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = {"BufWrite", "CursorHold"},
    },
}
-- local ts_utils = require 'nvim-treesitter.ts_utils'
require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    throttle = true, -- Throttles plugin updates (may improve performance)
}
-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.vimL = {
--   install_info = {
--     url = "~/Documents/tree-sitter-viml", -- local path or git repo
--     files = {"src/parser.c"}
--   },
--   filetype = "vim", -- if filetype does not agrees with parser name
--   -- used_by = {"bar", "baz"} -- additional filetypes that use this parser
-- }
