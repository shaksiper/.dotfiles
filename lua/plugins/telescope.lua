local actions = require("telescope.actions")
require("telescope").setup({
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
                ["<C-q>"] = actions.send_to_qflist,
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
                    ["<c-d>"] = require("telescope.actions").delete_buffer,
                },
                n = {
                    ["<c-d>"] = require("telescope.actions").delete_buffer,
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
    },
})
require('telescope').load_extension('fzf')
require('telescope').load_extension('projects')
