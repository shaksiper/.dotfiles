call plug#begin()
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " We recommend updating the parsers on update
Plug 'tpope/vim-repeat'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'nvim-treesitter/nvim-treesitter', {'branch' : '0.5-compat', 'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'branch' : '0.5-compat'}
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-treesitter/playground'
Plug 'mfussenegger/nvim-ts-hint-textobject'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'romgrk/nvim-treesitter-context'
" Plug 'lewis6991/spellsitter.nvim'
" Plug 'justinmk/vim-sneak' " Changed for lightspeed
Plug 'ggandor/lightspeed.nvim'
Plug 'abecodes/tabout.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'phpactor/phpactor', { 'do': ':call phpactor#Update()', 'for': 'php'}
" Plug 'kosayoda/nvim-lightbulb' " ditched for the convenience of lspsaga
" Plug 'RRethy/vim-illuminate'
Plug 'glepnir/lspsaga.nvim'
" Install nvim-cmp
Plug 'hrsh7th/nvim-cmp'
" Install the buffer completion source
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'ray-x/cmp-treesitter'
" Plug 'octaltree/cmp-look'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-calc'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'saadparwaiz1/cmp_luasnip'
" Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
Plug 'dense-analysis/ale'
Plug 'stephpy/vim-php-cs-fixer'
Plug 'rmagatti/auto-session'
Plug 'rmagatti/session-lens'
Plug 'kazhala/close-buffers.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'kyazdani42/nvim-tree.lua'
" Plug 'lambdalisue/fern.vim' |
"     \ Plug 'lambdalisue/fern-git-status.vim' |
"     \ Plug 'lambdalisue/fern-bookmark.vim' |
"     \ Plug 'lambdalisue/fern-mapping-project-top.vim' |
"     \ Plug 'lambdalisue/nerdfont.vim' |
"     \ Plug 'lambdalisue/fern-renderer-nerdfont.vim' |
"     \ Plug 'yuki-yano/fern-preview.vim' |
"     \ Plug 'csch0/vim-startify-renderer-nerdfont'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-telescope/telescope.nvim' |
            \ Plug 'nvim-telescope/telescope-fzy-native.nvim' |
            \ Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons' |
            \ Plug 'yamatsum/nvim-nonicons'
" Plug 'ryanoasis/vim-devicons'
" Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
" Plug 'mhinz/vim-signify' " ditched for gitsign which occupies less space in
" sign clumn and is minimalist
Plug 'ahmedkhalf/lsp-rooter.nvim'
"Plug 'jiangmiao/auto-pairs' breaks compe with <CR> mapping. Might fix the
"defaults or look for alternatives
Plug 'tmsvg/pear-tree'
Plug 'folke/which-key.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tweekmonster/startuptime.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'rose-pine/neovim'
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
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'nvim-neorg/neorg'
Plug 'nvim-neorg/neorg-telescope'
Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}
call plug#end()
filetype plugin indent on    " required
let g:ale_fixers={'php': ['php_cs_fixer']}
let g:ale_linters={'php': ['psalm']}
let g:ale_php_psalm_use_global = 1
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'always'
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = '😈> '

let g:minimap_auto_start = 1
let g:minimap_git_colors = 1
let g:minimap_highlight_search = 1
let g:minimap_diffadd_color = "GitSignsAdd"
let g:minimap_diffremove_color = 'GitSignsDelete'
let g:minimap_diff_color = 'GitSignsChange'
hi MinimapCurrentLine ctermfg=Green guifg=#50FA7B guibg=#32302f
let g:minimap_highlight = 'MinimapCurrentLine'

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
