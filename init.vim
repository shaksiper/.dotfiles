lua require('impatient.lua.impatient')
let g:plug_home = stdpath('data') . '/plugged'
set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h11
set confirm
set title titlestring=NeoVim\ 🧠\ %(%{expand(\"%:~:.:h\")}%)/%t
set encoding=utf-8
set spelllang=en_us
set spell " we need this now?
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
set linebreak
set showbreak=›››\     " there's a trailing <Space>, here.
set breakindent
set smartcase ignorecase
set scrolloff=4
set signcolumn=yes
set cursorline
set undofile
set colorcolumn=80
set pumheight=8
set termguicolors
runtime plugins.vim
lua require('init')
runtime maps.vim
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
set completeopt=menu,menuone,noselect
" let g:cursorhold_updatetime = 500
set updatetime=500
colorscheme kanagawa
