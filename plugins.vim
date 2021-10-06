call plug#begin()
Plug 'nathom/filetype.nvim'
Plug 'tpope/vim-repeat'
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
Plug 'rcarriga/nvim-notify'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'nvim-treesitter/nvim-treesitter', {'branch' : '0.5-compat', 'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'branch' : '0.5-compat'}
Plug 'Jason-M-Chan/ts-textobjects'
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-treesitter/playground'
Plug 'mfussenegger/nvim-ts-hint-textobject'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'romgrk/nvim-treesitter-context'
Plug 'SmiteshP/nvim-gps' " we need to provide treesitter queries for the
" languages
" Plug 'lewis6991/spellsitter.nvim' " Not working for some reason
Plug 'matze/vim-move'
Plug 'ggandor/lightspeed.nvim'
" Plug 'mg979/vim-visual-multi' " There is a learning curve for this and
" vanilla vim macros and motions *may* suffice as they say
" plug 'chrisbra/NrrwRgn' " Again it might be useful to edit a region in a
" narrow window of its own
Plug 'abecodes/tabout.nvim'
Plug 'neovim/nvim-lspconfig'
" Plug 'jose-elias-alvarez/null-ls.nvim'
" Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'ray-x/go.nvim'
Plug 'tami5/lspsaga.nvim' " Changed from glepnir to a more active fork
" Install nvim-cmp
Plug 'hrsh7th/nvim-cmp'
" Install the buffer completion source
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
" Plug 'ray-x/cmp-treesitter'
" Plug 'octaltree/cmp-look'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-calc'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'saadparwaiz1/cmp_luasnip'
" Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
" Plug 'dense-analysis/ale'
Plug 'stephpy/vim-php-cs-fixer'
Plug 'rmagatti/auto-session'
Plug 'rmagatti/session-lens'
Plug 'kazhala/close-buffers.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'beauwilliams/focus.nvim' " Causes unwanted side effects with telescope
" Plug 'simeji/winresizer' " Would be better orginizer than focus.nvim?
" Buffer select. The preview over extends form the borders to window
Plug 'https://gitlab.com/yorickpeterse/nvim-window.git'
Plug 'folke/lsp-colors.nvim'
Plug 'ray-x/lsp_signature.nvim'
" Plug 'rmagatti/goto-preview' lspsaga provides a better and more consistent
" ui, also won't cause weird behaviour due to being prompt rather that being
" buffer-like
Plug 'simrat39/symbols-outline.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-telescope/telescope.nvim' |
            \ Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" \ Plug 'nvim-telescope/telescope-fzy-native.nvim' |
Plug 'romgrk/fzy-lua-native'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
" Plug 'yamatsum/nvim-nonicons'
" Plug 'ryanoasis/vim-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'ahmedkhalf/lsp-rooter.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'folke/which-key.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tweekmonster/startuptime.vim'
Plug 'b3nj5m1n/kommentary'
" Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
" Let there be colorful schemes
Plug 'rose-pine/neovim'
Plug 'nxvu699134/vn-night.nvim'
Plug 'yonlu/omni.vim'
Plug 'novakne/kosmikoa.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'lifepillar/vim-solarized8'
Plug 'altercation/vim-colors-solarized'
Plug 'marko-cerovac/material.nvim'
Plug 'dracula/vim', { 'as': 'dracula' } 
Plug 'overcache/NeoSolarized'
Plug 'lifepillar/vim-gruvbox8'

Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'levouh/specs.nvim'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'nvim-neorg/neorg'
Plug 'nvim-neorg/neorg-telescope'
Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}
call plug#end()
filetype plugin indent on    " required
lua require('kommentary.config').use_extended_mappings()
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('pipeline', [
            \   wilder#branch(
            \     wilder#cmdline_pipeline({
            \       'fuzzy': 1,
            \       'set_pcre2_pattern': has('nvim'),
            \     }),
            \     wilder#python_search_pipeline({
            \       'pattern': 'fuzzy',
            \     }),
            \   ),
            \ ])
let s:highlighters = [
            \ wilder#pcre2_highlighter(),
            \ wilder#basic_highlighter(),
            \ ]
call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
            \   'highlighter': s:highlighters,
            \ 'empty_message': wilder#popupmenu_empty_message_with_spinner(),
            \ 'highlights': {
                \   'accent': wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#f4468f'}]),
                \   'border': 'Normal',
                \ },
                \ 'left': [
                    \   ' ', wilder#popupmenu_devicons(),
                    \ ],
                    \ 'right': [
                        \   ' ', wilder#popupmenu_scrollbar(),
                        \ ],
                        \ 'min_width': '20%',
                        \ 'reverse': 1,
                        \ 'border': 'rounded',
                        \ })))
" let g:ale_fixers={'php': ['php_cs_fixer']}
" let g:ale_linters={'php': ['psalm']}
" let g:ale_php_psalm_use_global = 1
" let g:ale_linters_explicit = 1
" let g:ale_fix_on_save = 1
" let g:ale_lint_on_text_changed = 'always'
" let g:ale_virtualtext_cursor = 1
" let g:ale_virtualtext_prefix = '😈> '

let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ]
let g:nvim_tree_gitignore = 1 
let g:nvim_tree_git_hl = 1
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_group_empty = 1
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'packer',
    \     'minimap',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
" let g:minimap_auto_start = 1
let g:minimap_git_colors = 1
" let g:minimap_highlight_search = 1
let g:minimap_diffadd_color = "GitSignsAdd"
let g:minimap_diffremove_color = 'GitSignsDelete'
let g:minimap_diff_color = 'GitSignsChange'
hi MinimapCurrentLine ctermfg=Green guifg=#50FA7B guibg=#32302f
let g:minimap_highlight = 'MinimapCurrentLine'
let g:minimap_block_filetypes = ['NerdTree', 'startify']

function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]
