let g:plug_home = stdpath('data').'/plugged' 
" filetype off
set encoding=utf-8
set number relativenumber
set clipboard+=unnamedplus
set noerrorbells
"set smartindent
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

syntax on
set completeopt=menuone,noinsert,noselect
colorscheme NeoSolarized
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
let g:indent_guides_enable_on_vim_startup = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
