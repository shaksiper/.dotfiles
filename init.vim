" -- Do not source the default filetype.vim
let g:did_load_filetypes = 1
let g:python3_host_prog = '/usr/bin/python3'
let g:plug_home = stdpath('data').'/plugged' 
" filetype off
set confirm
set title titlestring=NeoVim\ 🧠\ %(%{expand(\"%:~:.:h\")}%)/%t
set encoding=utf-8
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
" autocmd! CursorHoldI * put=&buftype
" autocmd! CursorHoldI * put=&filetype
let g:cursorhold_updatetime = 500
syntax on
set completeopt=menuone,noinsert,noselect
let g:rose_pine_variant = 'moon'
colorscheme rose-pine
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_focuslost_inactive = 1
let g:airline_stl_path_style = 'short'
let g:airline_section_b = "%{get(b:,'gitsigns_status','')}  %{get(b:,'gitsigns_head','')} 🌱"
" vimscript
func! NvimGps() abort
    return luaeval("require'nvim-gps'.is_available()") ?
                \ luaeval("require'nvim-gps'.get_location()") : ''
endf
let g:airline_section_c = '%t %{NvimGps()}'
