local actions = require("telescope.actions")
local telescope = require('telescope')
telescope.setup({
    defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case'
        },
        -- file_sorter = require("telescope.sorters").get_fzy_sorter,
        prompt_prefix = " 🔭>",
        color_devicons = true,

        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-J>"] = actions.file_edit,
                ["<C-q>"] = actions.send_to_qflist,
                -- ["<C-h>"] = R("telescope").extensions.hop.hop,  -- hop.hop_toggle_selection
                -- -- custom hop loop to multi selects and sending selected entries to quickfix list
                ["<C-space>"] = function(prompt_bufnr)
                    local opts = {
                        callback = actions.toggle_selection,
                        loop_callback = actions.send_selected_to_qflist,
                    }
                    require("telescope").extensions.hop._hop_loop(prompt_bufnr, opts)
                end,
            },
        },
    },
    pickers = {
        -- Your special builtin config goes in here
        buffers = {
            -- layout_strategy = 'bottom_pane',
            path_display = {
                'smart',
                -- 'truncate',
                -- 'shorten',
            },
            sort_lastused = true,
            theme = "dropdown",
            -- previewer = require("telescope.previewers").vim_buffer_cat.new,
            mappings = {
                i = {
                    ["<c-d>"] = actions.delete_buffer,
                },
                n = {
                    ["<c-d>"] = actions.delete_buffer,
                }
            }
        },
    },
    extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                           -- the default case_mode is "smart_case"
        },
        file_browser = {
            theme = "ivy",
            -- mappings = {
            --     ["i"] = {
            --         -- your custom insert mode mappings
            --     },
            --     ["n"] = {
            --         -- your custom normal mode mappings
            --     },
            -- },
        },
        hop = {
            -- the shown `keys` are the defaults, no need to set `keys` if defaults work for you ;)
            keys = {"a", "s", "d", "f", "g", "h", "j", "k", "l", ";",
                "q", "w", "e", "r", "t", "y", "u", "i", "o", "p",
                "A", "S", "D", "F", "G", "H", "J", "K", "L", ":",
                "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", },
            -- Highlight groups to link to signs and lines; the below configuration refers to demo
            -- sign_hl typically only defines foreground to possibly be combined with line_hl
            sign_hl = { "WarningMsg", "Title" },
            -- optional, typically a table of two highlight groups that are alternated between
            line_hl = { "CursorLine", "Normal" },
            -- options specific to `hop_loop`
            -- true temporarily disables Telescope selection highlighting
            clear_selection_hl = false,
            -- highlight hopped to entry with telescope selection highlight
            -- note: mutually exclusive with `clear_selection_hl`
            trace_entry = true,
            -- jump to entry where hoop loop was started from
            reset_selection = true,
        },
    },
})
telescope.load_extension('fzf')
telescope.load_extension('projects')
telescope.load_extension('file_browser')
telescope.load_extension('hop')
