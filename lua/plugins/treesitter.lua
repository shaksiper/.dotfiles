require("tsht").config.hint_keys = { "h", "j", "f", "d", "n", "v", "s", "l", "a" }
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'main',
    files = {'src/parser.c', 'src/scanner.cc'},
  },
  filetype = 'org',
}
require'nvim-treesitter.configs'.setup {
    ensure_installed = "php", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    rainbow = {
        enable = true,
        extended_mode = true, -- also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 1000, -- do not enable for files with more than 1000 lines, int
    },
    highlight = {
        enable = true,              -- false will disable the whole extension
        -- setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- using this option may slow down your editor, and you may see some duplicate highlights.
        -- instead of true it can also be a list of languages
        additional_vim_regex_highlighting = {'org'}, -- for org mode treesitter highlight
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
            init_selection = "<leader>v",
            node_incremental = "<cr>",
            scope_incremental = "<tab>",
            node_decremental = "<s-tab>",
        },
    },
    indent = {
        enable = true
    },
    refactor = {
        navigation = {
            enable = true,
            keymaps = {
                list_definitions = "gld",
                list_definitions_toc = "go",
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

            -- automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- you can use the capture groups defined in textobjects.scm
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
                ["]m"] = "@function.outer",
                ["]e"] = "@parameter.inner",
                ["]s"] = "@statement.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[e"] = "@parameter.inner",
                ["[s"] = "@statement.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[m"] = "@function.outer",
                ["[e"] = "@parameter.inner",
                ["[s"] = "@statement.outer",
                ["[]"] = "@class.outer",
            },
        },
        lsp_interop = {
            enable = false,
            border = 'single',
            peek_definition_code = {
                ["<leader>df"] = "@function.outer",
                ["<leader>dp"] = "@class.outer",
            },
        },
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'i',
            focus_language = 'f',
            unfocus_language = 'f',
            update = 'r',
            goto_node = '<cr>',
            show_help = '?',
        },
    },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = {"bufwrite", "cursorhold"},
    },
}
