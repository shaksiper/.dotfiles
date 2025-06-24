local actions = require("telescope.actions")
local telescope = require("telescope")
local transform_mod = require("telescope.actions.mt").transform_mod
local action_layout = require("telescope.actions.layout")
local action_state = require("telescope.actions.state")

local function multiopen(prompt_bufnr, method)
    local edit_file_cmd_map = {
        vertical = "vsplit",
        horizontal = "split",
        tab = "tabedit",
        default = "edit",
    }
    local edit_buf_cmd_map = {
        vertical = "vert sbuffer",
        horizontal = "sbuffer",
        tab = "tab sbuffer",
        default = "buffer",
    }
    local picker = action_state.get_current_picker(prompt_bufnr)
    local multi_selection = picker:get_multi_selection()

    if #multi_selection > 1 then
        require("telescope.pickers").on_close_prompt(prompt_bufnr)
        pcall(vim.api.nvim_set_current_win, picker.original_win_id)

        for i, entry in ipairs(multi_selection) do
            local filename, row, col

            if entry.path or entry.filename then
                filename = entry.path or entry.filename

                row = entry.row or entry.lnum
                col = vim.F.if_nil(entry.col, 1)
            elseif not entry.bufnr then
                local value = entry.value
                if not value then
                    return
                end

                if type(value) == "table" then
                    value = entry.display
                end

                local sections = vim.split(value, ":")

                filename = sections[1]
                row = tonumber(sections[2])
                col = tonumber(sections[3])
            end

            local entry_bufnr = entry.bufnr

            if entry_bufnr then
                if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
                    vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
                end
                local command = i == 1 and "buffer" or edit_buf_cmd_map[method]
                pcall(vim.cmd, string.format("%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)))
            else
                local command = i == 1 and "edit" or edit_file_cmd_map[method]
                if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
                    filename = require("plenary.path"):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
                    pcall(vim.cmd, string.format("%s %s", command, filename))
                end
            end

            if row and col then
                pcall(vim.api.nvim_win_set_cursor, 0, { row, col - 1 })
            end
        end
    else
        actions["select_" .. method](prompt_bufnr)
    end
end

local custom_actions = transform_mod({
    multi_selection_open_vertical = function(prompt_bufnr)
        multiopen(prompt_bufnr, "vertical")
    end,
    multi_selection_open_horizontal = function(prompt_bufnr)
        multiopen(prompt_bufnr, "horizontal")
    end,
    multi_selection_open_tab = function(prompt_bufnr)
        multiopen(prompt_bufnr, "tab")
    end,
    multi_selection_open = function(prompt_bufnr)
        multiopen(prompt_bufnr, "default")
    end,
})

local function stopinsert(callback)
    return function(prompt_bufnr)
        vim.cmd.stopinsert()
        vim.schedule(function()
            callback(prompt_bufnr)
        end)
    end
end
-- Another solution REF: https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1407046929
-- local actions = require("telescope.actions")
-- local action_state = require("telescope.actions.state")

-- local mm = { -- my mappings
--   ["<CR>"] = function(pb)
--     local picker = action_state.get_current_picker(pb)
--     local multi = picker:get_multi_selection()
--     actions.select_default(pb) -- the normal enter behaviour
--     for _, j in pairs(multi) do
--       if j.path ~= nil then -- is it a file -> open it as well:
--         vim.cmd(string.format("%s %s", "edit", j.path))
--       end
--     end
--   end,
-- }

-- return { defaults = { mappings = { i = mm,  n = mm },  }, }

-- -- NOTE: Telescope opens file in insert mode after neovim commit: d52cc66
-- -- Ref: https://github.com/nvim-telescope/telescope.nvim/issues/2501#issuecomment-1541009573
-- -- Neovim commit pull request: https://github.com/neovim/neovim/pull/22984
-- -- Workaround: Leave insert mode when leaving Telescope prompt.
-- -- Ref: https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1510001730
-- vim.api.nvim_create_augroup("my_telescope", { clear = true })
-- vim.api.nvim_create_autocmd({ "WinLeave" }, {
-- 	group = "my_telescope",
-- 	pattern = "*",
-- 	callback = function()
-- 		if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
-- 			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
-- 		end
-- 	end,
-- })

telescope.setup({
    defaults = {
        cache_picker = {
            num_pickers = 3,
            limit_entries = 3,
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
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
                ["<C-J>"] = stopinsert(custom_actions.multi_selection_open),
                -- ["<CR>"] = stopinsert(custom_actions.multi_selection_open),
                ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-k>"] = actions.toggle_selection,
                ["<c-v>"] = stopinsert(custom_actions.multi_selection_open_vertical),
                ["<c-s>"] = stopinsert(custom_actions.multi_selection_open_horizontal),
                ["<c-t>"] = stopinsert(custom_actions.multi_selection_open_tab),
                ["<c-b>"] = action_layout.toggle_preview,
                ["<C-/>"] = "which_key",
                ["<C-h>"] = function(prompt_bufnr)
                    telescope.extensions.hop.hop(prompt_bufnr)
                    actions.select_default(prompt_bufnr)
                end, -- hop.hop_toggle_selection
                -- -- custom hop loop to multi selects and sending selected entries to quickfix list
                ["<C-space>"] = function(prompt_bufnr)
                    local opts = {
                        callback = actions.toggle_selection,
                        -- loop_callback = custom_actions.multi_selection_open,
                    }
                    require("telescope").extensions.hop._hop_loop(prompt_bufnr, opts)
                end,
            },
            n = {
                ["<C-v>"] = custom_actions.multi_selection_open_vertical,
                ["<C-s>"] = custom_actions.multi_selection_open_horizontal,
                ["<C-t>"] = custom_actions.multi_selection_open_tab,
                -- ["<CR>"] = custom_actions.multi_selection_open,
                ["<C-J>"] = custom_actions.multi_selection_open,
            },
        },
    },
    pickers = {
        -- Your special builtin config goes in here
        buffers = {
            -- layout_strategy = 'bottom_pane',
            sort_lastused = true,
            theme = "dropdown",
            -- previewer = require("telescope.previewers").vim_buffer_cat.new,
            mappings = {
                i = {
                    ["<c-d>"] = actions.delete_buffer,
                },
                n = {
                    ["<c-d>"] = actions.delete_buffer,
                },
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,          -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        file_browser = {
            file_ignore_patterns = { ".git/" },
            hidden = true,
            -- no_ignore = true,
            theme = "ivy",
            hijack_netrw = true,
            grouped = true,
            initial_browser = "tree",
            -- auto switch to `telescope.builtin.find_files` style finder if there is a prompt
            auto_depth = true,
            depth = 1,
        },
        hop = {
            -- the shown `keys` are the defaults, no need to set `keys` if defaults work for you ;)
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
        persisted = {
            layout_config = { width = 0.55, height = 0.55 },
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown{}
        }
    },
})
telescope.load_extension("fzf")
telescope.load_extension("projects")
telescope.load_extension("file_browser")
telescope.load_extension("hop")
telescope.load_extension("undo")
telescope.load_extension("dap")
telescope.load_extension("persisted")
-- require("telescope").load_extension("projections")
-- vim.keymap.set("n", "<leader>fp", function()
-- 	vim.cmd("Telescope projections")
-- end)

-- -- Autostore session on VimExit
-- local Session = require("projections.session")
-- vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
-- 	callback = function()
-- 		Session.store(vim.loop.cwd())
-- 	end,
-- })

-- -- Switch to project if vim was started in a project dir
-- local switcher = require("projections.switcher")
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
-- 	callback = function()
-- 		if vim.fn.argc() == 0 then
-- 			switcher.switch(vim.loop.cwd())
-- 		end
-- 	end,
-- })
telescope.load_extension("ui-select")
