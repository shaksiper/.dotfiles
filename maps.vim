let mapleader=" "
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <leader>t :Fern . -reveal=% -drawer -width=30 -toggle<CR>
nnoremap <silent> <Leader>ee :<C-u>Fern <C-r>=<SID>init_fern()<CR><CR>
function! s:init_fern() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-expand-or-enter)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-open-or-expand)",
        \   "\<Plug>(fern-open-or-enter)",
        \ )
  nmap <buffer><expr>
        \ <Plug>(fern-my-collapse-or-leave)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-action-collapse)",
        \   "\<Plug>(fern-action-leave)",
        \ )
  nmap <buffer><nowait> l <Plug>(fern-my-expand-or-enter)
  nmap <buffer><nowait> h <Plug>(fern-my-collapse-or-leave)
endfunction
let g:fern#renderer = "nerdfont"
function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END
" -- TELESCOPE -- Find files using Telescope command-line sugar.
lua<<EOF
local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true}

map('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", default_opts)
map('n', '<leader>fr', "<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>", default_opts)
map('n', '<leader>fm', "<cmd>lua require'telescope.builtin'.keymaps()<cr>", default_opts)
map('n', '<leader>fb', "<cmd>lua require'telescope.builtin'.buffers()<cr>", default_opts)
map('n', '<leader>fh', "<cmd>lua require'telescope.builtin'.help_tags()<cr>", default_opts)
map('n', '<leader>/', ":silent grep ", default_opts)
map('n', '<leader>fg', "<cmd>lua require'telescope.builtin'.live_grep()<cr>", default_opts)
map('n', '<leader>fe', "<cmd>lua require'telescope.builtin'.file_browser()<cr>", default_opts)
EOF
" mfussenegger/nvim-ts-hint-textobject TreeSitter plugin for highlightingg parts of the code using sytax tree
omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
vnoremap <silent> m :lua require('tsht').nodes()<CR>
" Default rules for matching:
let g:pear_tree_pairs = {
            \ '(': {'closer': ')'},
            \ '[': {'closer': ']'},
            \ '{': {'closer': '}'},
            \ "'": {'closer': "'"},
            \ '"': {'closer': '"'}
            \ }
" See pear-tree/after/ftplugin/ for filetype-specific matching rules

" Pear Tree is enabled for all filetypes by default:
let g:pear_tree_ft_disabled = []

" Pair expansion is dot-repeatable by default:
let g:pear_tree_repeatable_expand = 1

" Smart pairs are disabled by default:
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1

" If enabled, smart pair functions timeout after 60ms:
let g:pear_tree_timeout = 60

" Automatically map <BS>, <CR>, and <Esc>
let g:pear_tree_map_special_keys = 0

" Default mappings:
" imap <BS> <Plug>(PearTreeBackspace)
" imap <CR> <Plug>(PearTreeExpand)
" imap <Esc> <Plug>(PearTreeFinishExpansion)
" Pear Tree also makes <Plug> mappings for each opening and closing string.
"     :help <Plug>(PearTreeOpener)
"     :help <Plug>(PearTreeCloser)

" Not mapped by default:
" <Plug>(PearTreeSpace)
" <Plug>(PearTreeJump)
" <Plug>(PearTreeExpandOne)
" <Plug>(PearTreeJNR)
