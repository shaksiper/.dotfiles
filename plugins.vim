call plug#begin()
Plug 'nathom/filetype.nvim'
Plug 'tpope/vim-repeat'
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
Plug 'rcarriga/nvim-notify'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" Plug 'nvim-treesitter/nvim-treesitter', {'branch' : '0.5-compat', 'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'Jason-M-Chan/ts-textobjects'
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-treesitter/playground'
Plug 'mfussenegger/nvim-treehopper'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'romgrk/nvim-treesitter-context'
Plug 'SmiteshP/nvim-gps' " we need to provide treesitter queries for the
" languages
Plug 'lewis6991/spellsitter.nvim' " Not working for some reason
Plug 'matze/vim-move'
Plug 'ggandor/lightspeed.nvim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
" Plug 'mg979/vim-visual-multi' " There is a learning curve for this and
" vanilla vim macros and motions *may* suffice as they say
" plug 'chrisbra/NrrwRgn' " Again it might be useful to edit a region in a
" narrow window of its own
Plug 'abecodes/tabout.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
" Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'ray-x/go.nvim'
Plug 'mfussenegger/nvim-jdtls'
Plug 'tami5/lspsaga.nvim' " Changed from glepnir to a more active fork
" Plug 'weilbith/nvim-code-action-menu' " couldn't get it work
" Plug 'sisodiaa/lspsaga.nvim'
" Install nvim-cmp
Plug 'hrsh7th/nvim-cmp'
" Install the buffer completion source
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'ray-x/cmp-treesitter'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
" Plug 'octaltree/cmp-look'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-calc'
Plug 'f3fora/cmp-spell'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
" Plug 'tom-doerr/vim_codex'
" DAP
" Plug 'mfussenegger/nvim-dap'
" Plug 'rcarriga/nvim-dap-ui'
" Plug 'Pocco81/DAPInstall.nvim'

" Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
" Plug 'dense-analysis/ale'
" Plug 'stephpy/vim-php-cs-fixer'
" Plug 'rmagatti/auto-session'
" Plug 'rmagatti/session-lens'
Plug 'kazhala/close-buffers.nvim'
Plug 'karb94/neoscroll.nvim'
" Plug 'beauwilliams/focus.nvim' " Causes unwanted side effects with telescope
" and not useful anymore?
Plug 'simeji/winresizer' " Would be better orginizer than focus.nvim?
Plug 'https://gitlab.com/yorickpeterse/nvim-pqf.git'
" Buffer select. The preview over extends form the borders to window
Plug 'https://gitlab.com/yorickpeterse/nvim-window.git'
" Plug 'folke/lsp-colors.nvim'
Plug 'ray-x/lsp_signature.nvim'
" Plug 'rmagatti/goto-preview' lspsaga provides a better and more consistent
" ui, also won't cause weird behaviour due to being prompt rather that being
" buffer-like
Plug 'simrat39/symbols-outline.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
" Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-hop.nvim'
" \ Plug 'nvim-telescope/telescope-fzy-native.nvim' |
" Plug 'romgrk/fzy-lua-native', { 'do': 'make' } " not working 
" Plug 'tzachar/cmp-fzy-buffer'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
" Plug 'yamatsum/nvim-nonicons'
" Plug 'ryanoasis/vim-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'ahmedkhalf/project.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'rmagatti/alternate-toggler'
Plug 'folke/which-key.nvim'
Plug 'norcalli/nvim-colorizer.lua'
" Plug 'axlebedev/footprints'
Plug 'tweekmonster/startuptime.vim'
" Plug 'b3nj5m1n/kommentary'
Plug 'numToStr/Comment.nvim'
" Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
" Let there be colorful schemes
Plug 'rose-pine/neovim'
" Plug 'wuelnerdotexe/vim-enfocado'
" Plug 'rktjmp/lush.nvim'
" Plug 'olimorris/onedarkpro.nvim'
" Plug 'EdenEast/nightfox.nvim'
" Plug 'mcchrish/zenbones.nvim'
" Plug 'nxvu699134/vn-night.nvim'
" Plug 'Mangeshrex/uwu.vim'
" Plug 'shaunsingh/moonlight.nvim'
" Plug 'nxvu699134/vn-night.nvim'
" Plug 'yonlu/omni.vim'
" Plug 'novakne/kosmikoa.nvim'
" Plug 'folke/tokyonight.nvim'
" Plug 'morhetz/gruvbox'
" Plug 'lifepillar/vim-solarized8'
" Plug 'altercation/vim-colors-solarized'
" Plug 'marko-cerovac/material.nvim'
" Plug 'dracula/vim', { 'as': 'dracula' } 
" Plug 'overcache/NeoSolarized'
" Plug 'lifepillar/vim-gruvbox8'

" Plug 'vim-airline/vim-airline'
Plug 'famiu/feline.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'levouh/specs.nvim'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'akinsho/toggleterm.nvim'
" Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'nvim-neorg/neorg'
" Plug 'nvim-neorg/neorg-telescope'
Plug 'kristijanhusak/orgmode.nvim'
Plug 'lukas-reineke/headlines.nvim'
Plug 'akinsho/org-bullets.nvim'
Plug 'wfxr/minimap.vim', {'branch': 'stateful_lines', 'do': ':!cargo install --locked code-minimap'}
call plug#end()
filetype plugin indent on    " required

let g:VM_leader = {'default': '\', 'visual': '\', 'buffer': 'z'}
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<M-d>'
let g:VM_maps['Find Subword Under'] = '<M-d>'

let g:surround_no_insert_mappings = 1

let g:nvim_tree_quit_on_open = 1
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
let g:minimap_git_colors = 1
let g:minimap_highlight_search = 1
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
let g:startify_bookmarks = [ {'c': '~/.config/nvim/'}, '~/.zshrc' ]
let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Configs']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]
