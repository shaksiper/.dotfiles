let mapleader=" "
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
nnoremap  <silent> <m-]>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <m-[>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprev<CR>

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
map('n', '<leader>fs', ":SearchSession<cr>", default_opts)
map('n', '<leader>th', "<cmd>lua require'close_buffers'.delete({type = 'hidden'})<cr>", {noremap = true, silent = true})
map('n', '<leader>tu', "<cmd>lua require'close_buffers'.delete({type = 'nameless'})<cr>", {noremap = true, silent = true})
map('n', '<leader>tc', "<cmd>lua require'close_buffers'.delete({type = 'this'})<cr>", {noremap = true, silent = true})
map('n', '<leader>tt', ":bd<cr>", {noremap = true, silent = true})

-- focus.nvim toggle thingy
map('n', '<m-BS>', ":lua require('focus').focus_toggle()<CR>", default_opts)
-- Outline symbols toggle
map('n', '<m-o>', ":SymbolsOutline<CR>", default_opts)
-- Sniprun
vim.api.nvim_set_keymap('n', '<leader>rr', '<Plug>SnipRun', {silent = true})
vim.api.nvim_set_keymap('v', '<leader>rr', '<Plug>SnipRun', {silent = true})
EOF
" mfussenegger/nvim-ts-hint-textobject TreeSitter plugin for highlightingg parts of the code using sytax tree
omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
vnoremap <silent> m :lua require('tsht').nodes()<CR>
" Phpactor keymappings
" nnoremap <leader>pp :PhpactorContextMenu<CR> no longer using it
nnoremap <M-m> :MinimapToggle<CR>
