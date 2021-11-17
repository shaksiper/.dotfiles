let mapleader=" "
nnoremap  <silent> <m-]>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <m-[>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprev<CR>
" Reselect the last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]' 

map <silent> <leader>w :lua require('nvim-window').pick()<CR>
nnoremap <C-t> :NvimTreeToggle<CR>
" " -- TELESCOPE -- Find files using Telescope command-line sugar.
lua<<EOF
local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true}

map('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", default_opts)
map('n', '<leader>fr', "<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>", default_opts)
map('n', '<leader>fm', "<cmd>lua require'telescope.builtin'.keymaps()<cr>", default_opts)
map('n', '<leader>fb', "<cmd>lua require'telescope.builtin'.buffers()<cr>", default_opts)
map('n', '<leader>fo', "<cmd>lua require'telescope.builtin'.oldfiles()<cr>", default_opts)
map('n', '<leader>fh', "<cmd>lua require'telescope.builtin'.help_tags()<cr>", default_opts)
map('n', '<leader>/', ":silent grep ", default_opts)
map('n', '<leader>fg', "<cmd>lua require'telescope.builtin'.live_grep()<cr>", default_opts)
map('n', '<leader>fe', "<cmd>lua require'telescope.builtin'.file_browser()<cr>", default_opts)
map('n', '<leader>fz', "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<cr>", default_opts)
map('n', '<leader>fsw', "<cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols()<cr>", default_opts)
map('n', '<leader>fsd', "<cmd>lua require'telescope.builtin'.lsp_document_symbols(require('telescope.themes').get_ivy({}))<cr>", default_opts)
map('n', '<leader>fdd', "<cmd>lua require'telescope.builtin'.lsp_document_diagnostics()<cr>", default_opts)
map('n', '<leader>fdw', "<cmd>lua require'telescope.builtin'.lsp_workspace_diagnostics()<cr>", default_opts)
map('n', '<leader>fp', "<cmd>Telescope projects theme=dropdown<cr>", default_opts)
-- map('n', '<leader>fs', ":SearchSession<cr>", default_opts)
map('n', '<leader>th', "<cmd>lua require'close_buffers'.delete({type = 'hidden'})<cr>", {noremap = true, silent = true})
map('n', '<leader>tu', "<cmd>lua require'close_buffers'.delete({type = 'nameless'})<cr>", {noremap = true, silent = true})
map('n', '<leader>tc', "<cmd>lua require'close_buffers'.delete({type = 'this'})<cr>", {noremap = true, silent = true})
map('n', '<leader>tt', ":bd<cr>", {noremap = true, silent = true})

-- focus.nvim toggle thingy
-- map('n', '<m-BS>', ":lua require('focus').focus_toggle()<CR>", default_opts)
-- Outline symbols toggle
map('n', '<m-o>', ":SymbolsOutline<CR>", default_opts)
map('n', '<m-u>', ":UndotreeToggle<CR>", default_opts)
-- Sniprun
vim.api.nvim_set_keymap('n', '<leader>rr', '<Plug>SnipRun', {silent = true})
vim.api.nvim_set_keymap('v', '<leader>rr', '<Plug>SnipRun', {silent = true})

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
