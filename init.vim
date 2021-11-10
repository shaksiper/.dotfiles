" -- Do not source the default filetype.vim
lua require('impatient.lua.impatient')
let g:did_load_filetypes = 1
let g:python3_host_prog = '/usr/bin/python3'
let g:plug_home = stdpath('data').'/plugged' 
set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h12
" filetype off
set confirm
set title titlestring=NeoVim\ 🧠\ %(%{expand(\"%:~:.:h\")}%)/%t
set encoding=utf-8
set spelllang=en_us
set number relativenumber
set clipboard+=unnamedplus
set noerrorbells
set smartindent
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
set incsearch nohlsearch
" set nowrap
set linebreak
set showbreak=›››\     " there's a trailing <Space>, here.
set breakindent
set smartcase ignorecase
" set vb t_vb=
set scrolloff=4
set signcolumn=yes
set cul
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile
set hidden
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
set termguicolors
runtime plugins.vim
lua require('init')
runtime maps.vim
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
" function! SaveWithTS(filename) range
"     let l:extension = '.' . fnamemodify( a:filename, ':e' )
"     if len(l:extension) == 1
"         let l:extension = '.sql'
"     endif

"     let l:filename = escape( fnamemodify(a:filename, ':r') . strftime("_%Y_%m_%d_%H_%M") . l:extension, ' ' )

"     execute "write " . l:filename
" endfunction
" command! -nargs=1 SWT call SaveWithTS( <q-args> )
set completeopt=menu,menuone,noselect
let g:cursorhold_updatetime = 500
" Live preview of Ex commands
set inccommand=nosplit
let g:rose_pine_variant = 'moon'
colorscheme rose-pine
