let mapleader=' '
" start new change before deleting an entire line
inoremap <c-u> <c-g>u<c-u>
" Some language specific mappings
" au FileType go imap <buffer> <M-;> :=
" au FileType javascript imap <buffer> <M-;> =>
" autocmd FileType markdown noremap <leader>p :Glow<CR>
" Reselect the last pastedtext
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" map <silent> <leader>ww :lua require('nvim-window').pick()<CR>
" nnoremap <C-t> :NeoTreeRevealToggle<CR>
" " -- TELESCOPE -- Find files using Telescope command-line sugar.
lua << EOF


vim.keymap.set("n", "<leader>ot", "<CMD>ObsidianToday<CR>", {desc = "Obsidian Today"})
vim.keymap.set("n", "<C-w>gt", "<CMD>tab split<CR>", {desc = "Open current buffer in new tab"})

require("maps.detour")
require("maps.hydras")

-- LEAP
vim.keymap.set({'n', 'o'}, '<leader>gs', function ()
  require('leap.remote').action()
end)
vim.keymap.set({ "n", "x", "o" }, "<leader><leader>s", function()
    require("leap-ast").leap()
end, {})
vim.keymap.set("n", "<leader>ss", function()
    require("leap").leap({
        target_windows = vim.tbl_filter(function(win)
            return vim.api.nvim_win_get_config(win).focusable
        end, vim.api.nvim_tabpage_list_wins(0)),
    })
end)
-- local map = vim.keymap.set
local default_opts = { noremap = true }

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "markdown",
    callback = function()
        vim.keymap.set("n", "<leader>p", "<cmd>Glow<CR>", default_opts)
    end,
})
-- FAILED REMAP FOR ORGMODE
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "org",
--     callback = function() vim.keymap.set('i', '<C-CR>', '<ESC><leader><CR>i', default_opts) end,-- Or myvimfun
--     })

-- TODO make mappings with newly added vim.keymap
-- See : https://github.com/neovim/neovim/pull/16591
vim.keymap.set(
    "n",
    "<leader>ff",
    "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git'}, file_ignore_patterns = { 'node%_modules/.*' }})<cr>",
    default_opts
)
vim.keymap.set(
    "n",
    "<leader><TAB>",
    "<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>",
    default_opts
)
vim.keymap.set("n", "<leader>fsp", "<cmd>Telescope spell_suggest theme=cursor<cr>", default_opts)
vim.keymap.set("n", "<leader>fk", "<cmd>lua require'telescope.builtin'.keymaps()<cr>", default_opts)
vim.keymap.set("n", "<leader>fo", "<cmd>lua require'telescope.builtin'.oldfiles()<cr>", default_opts)
vim.keymap.set("n", "<leader>fh", "<cmd>lua require'telescope.builtin'.help_tags()<cr>", default_opts)
vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<CR>", default_opts)
vim.keymap.set("n", "<leader>fgr", "<cmd>lua require'telescope.builtin'.live_grep()<cr>", { desc = "Live Grep" })
-- Telescope Git actions
vim.keymap.set("n", "<leader>fgf", "<cmd>lua require'telescope.builtin'.git_files()<cr>", { desc = "Git Files" })
vim.keymap.set("n", "<leader>fgc", "<cmd>lua require'telescope.builtin'.git_commits()<cr>", { desc = "Git Commits" })
vim.keymap.set("n", "<leader>fgb", "<cmd>lua require'telescope.builtin'.git_branches()<cr>", { desc = "Git Branches" })
vim.keymap.set("n", "<leader>fgs", "<cmd>lua require'telescope.builtin'.git_status()<cr>", { desc = "Git Status" })
vim.keymap.set("n", "<M-g>", "<cmd>Neogit<cr>", { desc = "Neogit" })
vim.keymap.set(
    "n",
    "<leader>F",
    "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>",
    default_opts
)
vim.keymap.set(
    "n",
    "<leader>fe",
    "<cmd>lua require 'telescope'.extensions.file_browser.file_browser({path='%:p:h',select_buffer=true})<CR>",
    default_opts
)
vim.keymap.set(
    "n",
    "<leader>fz",
    "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find({preview = {hide_on_startup = true, title = 'Fuzzy Find Buffer'}, layout_config={width=0.65}})<cr>",
    default_opts
)
vim.keymap.set("n", "<leader>fj", "<cmd>lua require'telescope.builtin'.jumplist()<cr>", default_opts)
-- vim.keymap.set('v', '<leader>fc', "<cmd>Telescope lsp_range_code_actions<cr>", default_opts)
vim.keymap.set("n", "<leader>fm", "<cmd>lua require'telescope.builtin'.marks()<cr>", default_opts)
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects theme=dropdown<cr>", default_opts)
vim.keymap.set("n", "<leader>fl", "<cmd>Telescope resume<cr>", default_opts)
vim.keymap.set("n", "<leader>fdb", "<cmd>Telescope dap commands theme=dropdown<cr>", default_opts)
-- map('n', '<leader>fs', ":SearchSession<cr>", default_opts)
vim.keymap.set(
    "n",
    "<leader>th",
    "<cmd>lua require'close_buffers'.delete({type = 'hidden'})<cr>",
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>tu",
    "<cmd>lua require'close_buffers'.delete({type = 'nameless'})<cr>",
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>tc",
    "<cmd>lua require'close_buffers'.delete({type = 'this'})<cr>",
    { noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>tt", ":bd<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ts", ":OverseerRun<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>to", ":OverseerToggle bottom<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tr", ":OverseerRestartLast<cr>", { noremap = true, silent = true })
-- map('n', '<M-t>', "<cmd>lua require('rose-pine.functions').toggle_variant()<cr>", {noremap = true, silent = true})
-- Syntax Tree Surfer
-- Normal Mode Swapping
vim.api.nvim_set_keymap(
    "n",
    "vd",
    '<cmd>lua require("syntax-tree-surfer").move("n", false)<cr>',
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "vu",
    '<cmd>lua require("syntax-tree-surfer").move("n", true)<cr>',
    { noremap = true, silent = true }
)
-- .select() will show you what you will be swapping with .move(), you'll get used to .select() and .move() behavior quite soon!
vim.api.nvim_set_keymap(
    "n",
    "vx",
    '<cmd>lua require("syntax-tree-surfer").select()<cr>',
    { noremap = true, silent = true }
)
-- .select_current_node() will select the current node at your cursor
vim.api.nvim_set_keymap(
    "n",
    "vn",
    '<cmd>lua require("syntax-tree-surfer").select_current_node()<cr>',
    { noremap = true, silent = true }
)

-- NAVIGATION: Only change the keymap to your liking. I would not recommend changing anything about the .surf() parameters!
vim.api.nvim_set_keymap(
    "x",
    "L",
    '<cmd>lua require("syntax-tree-surfer").surf("next", "visual")<cr>',
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "x",
    "H",
    '<cmd>lua require("syntax-tree-surfer").surf("prev", "visual")<cr>',
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "x",
    "K",
    '<cmd>lua require("syntax-tree-surfer").surf("parent", "visual")<cr>',
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "x",
    "J",
    '<cmd>lua require("syntax-tree-surfer").surf("child", "visual")<cr>',
    { noremap = true, silent = true }
)

local sts = require("syntax-tree-surfer")
vim.keymap.set("n", "<A-n>", function()
    sts.filtered_jump("default", true) --> true means jump forward
end, opts)
vim.keymap.set("n", "<A-p>", function()
    sts.filtered_jump("default", false) --> false means jump backwards
end, opts)

-- SWAPPING WITH VISUAL SELECTION: Only change the keymap to your liking. Don't change the .surf() parameters!
vim.api.nvim_set_keymap(
    "x",
    "<A-J>",
    '<cmd>lua require("syntax-tree-surfer").surf("next", "visual", true)<cr>',
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "x",
    "<A-K>",
    '<cmd>lua require("syntax-tree-surfer").surf("prev", "visual", true)<cr>',
    { noremap = true, silent = true }
)

-- focus.nvim toggle thingy
-- map('n', '<m-BS>', ":lua require('focus').focus_toggle()<CR>", default_opts)
-- Outline symbols toggle
vim.keymap.set("n", "<m-o>", ":Outline<CR>", default_opts)
vim.keymap.set("n", "<m-u>", ":UndotreeToggle<CR>", default_opts)
-- Sniprun
vim.keymap.set("n", "<leader>rr", "<Plug>SnipRun", { silent = true })
vim.keymap.set("v", "<leader>rr", "<Plug>SnipRun", { silent = true })

function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n><C-W>p]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-w>", [[<C-\><C-n><C-W>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
-- vim.keymap.set("n", "<leader>sl", require('session-lens').search_session, default_opts) -- make this a user command and free the keymapping

vim.keymap.set("n", "\\e", "<cmd>FeMaco<CR>", default_opts)

--DAP
vim.keymap.set("n", "]b", require("goto-breakpoints").next, { desc = "Next Break Point" })
vim.keymap.set("n", "[b", require("goto-breakpoints").prev, { desc = "Previous Break Point" })
vim.keymap.set("n", "]B", require("goto-breakpoints").stopped, { desc = "Stopped Break Point" })

vim.keymap.set("n", "<leader>n", require("nvim-navbuddy").open, { desc = "Navbuddy" })

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
vim.keymap.set("n", "<leader>fy", "<CMD>YankyRingHistory<CR>")
vim.keymap.set("n", "<leader>ls", function()
    require("dropbar.api").pick()
end,  { desc = "Select symbol from drop bar" })

-- Markdown
vim.keymap.set("n", "\\mir", "<cmd>MkdnTableNewRowAbove<CR>", { desc = "Insert Row Before" })
vim.keymap.set("n", "\\mar", "<cmd>MkdnTableNewRowBelow<CR>", { desc = "Insert Row After" })
vim.keymap.set("n", "\\mic", "<cmd>MkdnTableNewColBefore<CR>", { desc = "Insert Column Before" })
vim.keymap.set("n", "\\mac", "<cmd>MkdnTableNewColAfter<CR>", { desc = "Insert Column After" })
vim.keymap.set("n", "\\mf", "<cmd>MkdnTableFormat<CR>", { desc = "Format Table" })

vim.api.nvim_create_user_command("PeekToggle", function()
    local peek = require("peek")
    if peek.is_open then
        peek.close()
    end
    peek.open()
end, {})
EOF

" mfussenegger/nvim-ts-hint-textobject TreeSitter plugin for highlighting parts of the code using sytax tree
" omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
" vnoremap <silent> m :lua require('tsht').nodes()<CR>
nnoremap <M-m> :MinimapToggle<CR>
" Replace word without affecting buffer.
vnoremap <leader>rp "_dP
nnoremap <leader>rp viw"_dP
" Buffer pick
nnoremap <leader>bb :BufferLinePick<CR>
" let g:winresizer_start_key="<leader>ws"
nnoremap <leader>sw :ToggleAlternate<CR>

nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
nnoremap <silent> <leader>dt :lua require'dapui'.toggle()<CR>

" nmap <silent> <leader>td :lua require('dap-go').debug_test()<CR>

" Pounce
nmap <leader><C-f> <cmd>Pounce<CR>
vmap <leader><C-f> <cmd>Pounce<CR>
" nmap <C-l> <cmd>PounceRepeat<CR>
omap gs <cmd>Pounce<CR>  " 's' is used by vim-surround
