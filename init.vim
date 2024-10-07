lua vim.loader.enable()
let g:plug_home = stdpath('data') . '/plugged'
set guifont=JetBrainsMono\ NFM:h11
" set conceallevel=2 " no need for this globally
set confirm
set encoding=utf-8
set spelllang=en_us
set spell " we need this now?
set spelloptions=noplainbuffer,camel
set foldtext=
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
" set incsearch nohlsearch
set incsearch
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
set background=dark
" let g:codeium_enabled = v:false
highlight IndentBlanklineIndent1 guifg=#56B6C2 gui=nocombine
 highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine
 highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine
 highlight IndentBlanklineIndent4 guifg=#E06C75 gui=nocombine
 highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine
 highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine
