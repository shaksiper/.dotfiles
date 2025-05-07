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
-- TESTING
vim.keymap.set("n", "\\td", function()
    require("neotest").run.run({ strategy = "dap" })
end, { noremap = true, desc = "Test Debug" })
vim.keymap.set("n", "\\tt", function()
    require("neotest").run.run(vim.fn.expand("%"))
end, { noremap = true, desc = "Test Current Test File" })
vim.keymap.set("n", "\\ts", function()
    require("neotest").run.stop()
end, { noremap = true, desc = "Stop Test" })
vim.keymap.set("n", "\\T", function()
    require("neotest").run.run()
end, { noremap = true, desc = "Test Nearest" })
vim.keymap.set("n", "\\to", function()
    require("neotest").output.open({ enter = true })
end, { noremap = true, desc = "Test Output" })
vim.keymap.set("n", "<M-t>", function()
    require("neotest").summary.toggle()
end, { noremap = true, desc = "Toggle Test Summary" })

--LSP

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>fsw", "<cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols()<cr>", opts)
vim.keymap.set(
    "n",
    "<leader>fsd",
    "<cmd>lua require'telescope.builtin'.lsp_document_symbols(require('telescope.themes').get_ivy({}))<cr>",
    opts
)
vim.keymap.set("n", "<leader>fdd", "<cmd>Telescope diagnostics bufnr=0<cr>", opts)
vim.keymap.set("n", "<leader>fwd", "<cmd>Telescope diagnostics<cr>", opts)
-- vim.keymap.set("n", "<leader>fso", "<cmd>Telescope lsp_workspace_symbols<cr>", opts)
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "<leader>gdd", "<cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
vim.keymap.set("n", "<leader>gdf", "<cmd>DetourCurrentWindow<CR><cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
vim.keymap.set("n", "<leader>gds", "<C-w>s<cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
vim.keymap.set("n", "<leader>gdv", "<C-w>v<cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
vim.keymap.set("n", "<leader>gtd", "<Cmd>Telescope lsp_type_definitions theme=ivy<CR>", opts)
vim.keymap.set("n", "<leader>g>", "<Cmd>Telescope lsp_outgoing_calls theme=ivy<CR>", opts)
vim.keymap.set("n", "<leader>g<", "<Cmd>Telescope lsp_incoming_calls theme=ivy<CR>", opts)

vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
end, opts)
vim.keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations theme=ivy<CR>", opts)
vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, opts)
vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
-- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

vim.keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references theme=ivy<CR>", opts)
vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
vim.keymap.set("v", "<leader>ca", ":Telescope range_code_action<CR>", opts)

-- vim.keymap.set("n", "<leader>cla", "V:<C-U>Lspsaga range_code_action<CR>", opts) -- Code line action
vim.keymap.set("n", "gh", "<cmd>Lspsaga finder<CR>", opts)
vim.keymap.set("n", "<leader>gdp", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
vim.keymap.set("n", "<leader>gdP", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek type definition" })
-- Only jump to error
vim.keymap.set("n", "[D", function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
vim.keymap.set("n", "]D", function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
vim.keymap.set("n", "<leader>gf", "<cmd>lua vim.lsp.buf.format{ asyny = true }<CR>", opts)
vim.keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
-- vim.keymap.set("n", "<leader>glf", "V<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts) -- Code line formatting, for whatever it's worth.
vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float({ border = "rounded" })
end, opts)
vim.keymap.set("n", "<leader>ce", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", opts)
-- vim.keymap.set("n", "<leader>so", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
-- TROUBLE
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>", { desc = "Trouble" })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble WP Diagnostics" })
vim.keymap.set(
    "n",
    "<leader>xd",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    { desc = "Trouble WP Diagnostics" }
)
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble Buffer Diagnostics" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", { desc = "Trouble Quickfix" })
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "Trouble LSP Ref." })

-- DAP
local dap = require('dap')
vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "DAP Continue" })
vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "DAP Step Over" })
vim.keymap.set("n", "<M-Right>", function() dap.step_over() end, { desc = "DAP Step Over" })
vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "DAP Step Into" })
vim.keymap.set("n", "<M-Down>", function() dap.step_into() end, { desc = "DAP Step Into" })
vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "DAP Step Out" })
vim.keymap.set("n", "<M-Up>", function() dap.step_out() end, { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
    { desc = "DAP Conditional Breakpoint" })
vim.keymap.set("n", "<leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
    { desc = "DAP Log Breakpoint" })
vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "DAP REPL" })
vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "DAP Run Last" })
vim.keymap.set("n", "<leader>dt", function() require 'dapui'.toggle() end, { desc = "DAP Toggle UI" })
vim.keymap.set("n", "<leader>dT", function() dap.terminate() end, { desc = "DAP Terminate" })
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
    require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
    require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)

vim.keymap.set('n', '<leader>dw', function()
  local widgets = require"dap.ui.widgets"
  widgets.hover()
end)

vim.keymap.set('n', '\\dl', function()
  require"osv".launch({port = 8086})
end, { noremap = true })

vim.keymap.set("n", "<leader>ot", "<CMD>ObsidianToday<CR>", { desc = "Obsidian Today" })
vim.keymap.set("n", "<C-w>gt", "<CMD>tab split<CR>", { desc = "Open current buffer in new tab" })

-- require("maps.detour")
-- require("maps.hydras")

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
end, { desc = "Select symbol from drop bar" })

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

" Pounce
"nmap <leader><C-f> <cmd>Pounce<CR>
"vmap <leader><C-f> <cmd>Pounce<CR>
"" nmap <C-l> <cmd>PounceRepeat<CR>
"omap gs <cmd>Pounce<CR>  " 's' is used by vim-surround


