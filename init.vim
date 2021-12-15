lua require('impatient.lua.impatient')
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
" set backupdir=~/.vim/backup//
" set directory=~/.vim/swap//
" set undodir=~/.vim/undo//
set undofile
set colorcolumn=80
set termguicolors
runtime plugins.vim
lua require('init')
runtime maps.vim
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
set completeopt=menu,menuone,noselect
let g:cursorhold_updatetime = 500
let g:rose_pine_variant = 'moon'
colorscheme rose-pine
