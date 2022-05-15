let mapleader=" "
nnoremap  <silent> <m-]>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <m-[>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprev<CR>
" start new change before deleting an entire line
inoremap <c-u> <c-g>u<c-u>
" Some language specific mappings
au FileType go imap <buffer> <M-;> :=
au FileType javascript imap <buffer> <M-;> =>
autocmd FileType markdown noremap <leader>p :Glow<CR>
" Reselect the last pastedtext
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

map <silent> <leader>ww :lua require('nvim-window').pick()<CR>
nnoremap <C-t> :NeoTreeRevealToggle<CR>
" " -- TELESCOPE -- Find files using Telescope command-line sugar.
lua<<EOF
-- local map = vim.keymap.set
local default_opts = {noremap = true}

-- FAILED REMAP FOR ORGMODE
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "org",
--     callback = function() vim.keymap.set('i', '<C-CR>', '<ESC><leader><CR>i', defaul_opts) end,-- Or myvimfun
--     })

-- TODO make mappings with newly added vim.keymap
-- See : https://github.com/neovim/neovim/pull/16591
vim.keymap.set('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git'}, file_ignore_patterns = { 'node%_modules/.*' }})<cr>", default_opts)
vim.keymap.set('n', '<leader>fb', "<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>", default_opts)
vim.keymap.set('n', '<leader>fk', "<cmd>lua require'telescope.builtin'.keymaps()<cr>", default_opts)
vim.keymap.set('n', '<leader>fo', "<cmd>lua require'telescope.builtin'.oldfiles()<cr>", default_opts)
vim.keymap.set('n', '<leader>fh', "<cmd>lua require'telescope.builtin'.help_tags()<cr>", default_opts)
vim.keymap.set('n', '<leader>/', ":silent grep ", default_opts)
vim.keymap.set('n', '<leader>fg', "<cmd>lua require'telescope.builtin'.live_grep()<cr>", default_opts)
vim.keymap.set('n', '<leader>fe', "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>", default_opts)
vim.keymap.set('n', '<leader>fz', "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find({preview = {hide_on_startup = true, title = 'Fuzzy Find Buffer'}, layout_config={width=0.65}})<cr>", default_opts)
vim.keymap.set('n', '<leader>fj', "<cmd>lua require'telescope.builtin'.jumplist()<cr>", default_opts)
-- vim.keymap.set('v', '<leader>fc', "<cmd>Telescope lsp_range_code_actions<cr>", default_opts)
vim.keymap.set('n', '<leader>fm', "<cmd>lua require'telescope.builtin'.marks()<cr>", default_opts)
vim.keymap.set('n', '<leader>fsw', "<cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols()<cr>", default_opts)
vim.keymap.set('n', '<leader>fsd', "<cmd>lua require'telescope.builtin'.lsp_document_symbols(require('telescope.themes').get_ivy({}))<cr>", default_opts)
vim.keymap.set('n', '<leader>fdd', "<cmd>Telescope diagnostics bufnr=0<cr>", default_opts)
vim.keymap.set('n', '<leader>fdw', "<cmd>Telescope diagnostics<cr>", default_opts)
vim.keymap.set('n', '<leader>fp', "<cmd>Telescope projects theme=dropdown<cr>", default_opts)
vim.keymap.set('n', '<leader>fl', "<cmd>Telescope resume<cr>", default_opts)
-- map('n', '<leader>fs', ":SearchSession<cr>", default_opts)
vim.keymap.set('n', '<leader>th', "<cmd>lua require'close_buffers'.delete({type = 'hidden'})<cr>", {noremap = true, silent = true})
vim.keymap.set('n', '<leader>tu', "<cmd>lua require'close_buffers'.delete({type = 'nameless'})<cr>", {noremap = true, silent = true})
vim.keymap.set('n', '<leader>tc', "<cmd>lua require'close_buffers'.delete({type = 'this'})<cr>", {noremap = true, silent = true})
vim.keymap.set('n', '<leader>tt', ":bd<cr>", {noremap = true, silent = true})
-- map('n', '<M-t>', "<cmd>lua require('rose-pine.functions').toggle_variant()<cr>", {noremap = true, silent = true})
-- Syntax Tree Surfer
-- Normal Mode Swapping
vim.api.nvim_set_keymap("n", "vd", '<cmd>lua require("syntax-tree-surfer").move("n", false)<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "vu", '<cmd>lua require("syntax-tree-surfer").move("n", true)<cr>', {noremap = true, silent = true})
-- .select() will show you what you will be swapping with .move(), you'll get used to .select() and .move() behavior quite soon!
vim.api.nvim_set_keymap("n", "vx", '<cmd>lua require("syntax-tree-surfer").select()<cr>', {noremap = true, silent = true})
-- .select_current_node() will select the current node at your cursor
vim.api.nvim_set_keymap("n", "vn", '<cmd>lua require("syntax-tree-surfer").select_current_node()<cr>', {noremap = true, silent = true})

-- NAVIGATION: Only change the keymap to your liking. I would not recommend changing anything about the .surf() parameters!
vim.api.nvim_set_keymap("x", "J", '<cmd>lua require("syntax-tree-surfer").surf("next", "visual")<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", "K", '<cmd>lua require("syntax-tree-surfer").surf("prev", "visual")<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", "H", '<cmd>lua require("syntax-tree-surfer").surf("parent", "visual")<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", "L", '<cmd>lua require("syntax-tree-surfer").surf("child", "visual")<cr>', {noremap = true, silent = true})

-- SWAPPING WITH VISUAL SELECTION: Only change the keymap to your liking. Don't change the .surf() parameters!
vim.api.nvim_set_keymap("x", "<A-j>", '<cmd>lua require("syntax-tree-surfer").surf("next", "visual", true)<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", "<A-k>", '<cmd>lua require("syntax-tree-surfer").surf("prev", "visual", true)<cr>', {noremap = true, silent = true})
-- TROUBLE
-- Lua
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)

-- focus.nvim toggle thingy
-- map('n', '<m-BS>', ":lua require('focus').focus_toggle()<CR>", default_opts)
-- Outline symbols toggle
vim.keymap.set('n', '<m-o>', ":SymbolsOutline<CR>", default_opts)
vim.keymap.set('n', '<m-u>', ":UndotreeToggle<CR>", default_opts)
-- Sniprun
vim.keymap.set('n', '<leader>rr', '<Plug>SnipRun', {silent = true})
vim.keymap.set('v', '<leader>rr', '<Plug>SnipRun', {silent = true})

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n><C-W>p]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-w>', [[<C-\><C-n><C-W>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
EOF
" mfussenegger/nvim-ts-hint-textobject TreeSitter plugin for highlightingg parts of the code using sytax tree
omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
vnoremap <silent> m :lua require('tsht').nodes()<CR>
nnoremap <silent> <leader>m :lua require('tsht').jump_nodes()<CR>
nnoremap <M-m> :MinimapToggle<CR>
" " Experimental insert mode surround functionality
" imap <C-S> <Plug>Isurround
" Replace word without affecting buffer.
vnoremap <leader>rp "_dP
nnoremap <leader>rp viw"_dP
" Buffer pick
nnoremap <leader>bb :BufferLinePick<CR>
let g:winresizer_start_key="<leader>ws"
nnoremap <leader>sw :ToggleAlternate<CR>

let g:lightspeed_last_motion = ''
augroup lightspeed_last_motion
    autocmd!
    autocmd User LightspeedSxEnter let g:lightspeed_last_motion = 'sx'
    autocmd User LightspeedFtEnter let g:lightspeed_last_motion = 'ft'
augroup end
map <expr> ; g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"
map <expr> , g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"

nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
nmap <silent> <leader>td :lua require('dap-go').debug_test()<CR>

" Pounce
" nmap <C-s> <cmd>Pounce<CR>
" vmap <C-S> <cmd>Pounce<CR>
" omap gs <cmd>Pounce<CR>  " 's' is used by vim-surround
