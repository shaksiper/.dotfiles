call plug#begin()
Plug '~/Documents/development/projects/neovim-plugin/minimap.nvim'
Plug 'tpope/vim-repeat'
Plug 'michaelb/sniprun', { 'do': 'bash install.sh'}
Plug 'rcarriga/nvim-notify'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
" Plug 'Jason-M-Chan/ts-textobjects'
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-treesitter/playground'
Plug 'mfussenegger/nvim-treehopper'
Plug 'ziontee113/syntax-tree-surfer'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'romgrk/nvim-treesitter-context' " seems not very useful, gps and
" outline works better for its purpose
" Plug 'SmiteshP/nvim-gps' " we need to provide treesitter queries for the
" languages
" Plug 'lewis6991/spellsitter.nvim' " merged to nvim core
Plug 'matze/vim-move'
Plug 'ggandor/lightspeed.nvim'
Plug 'rlane/pounce.nvim'
Plug 'mg979/vim-visual-multi', { 'branch': 'master'}
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
Plug 'habamax/vim-godot'
Plug 'glepnir/lspsaga.nvim' " Changed from glepnir to a more active fork
" Plug 'SmiteshP/nvim-navic'
Plug 'stevearc/dressing.nvim'
" Install nvim-cmp
Plug 'hrsh7th/nvim-cmp'
" Install the buffer completion source
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'ray-x/cmp-treesitter'
" Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
Plug 'folke/trouble.nvim'
" Plug 'octaltree/cmp-look'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'folke/lua-dev.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-calc'
Plug 'f3fora/cmp-spell'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'saadparwaiz1/cmp_luasnip'

" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'leoluz/nvim-dap-go'
Plug 'mfussenegger/nvim-dap-python'
Plug 'nvim-telescope/telescope-dap.nvim'


" Plug 'tom-doerr/vim_codex'
Plug 'kazhala/close-buffers.nvim'
Plug 'karb94/neoscroll.nvim'
" Plug 'beauwilliams/focus.nvim' " Causes unwanted side effects with telescope
" and not useful anymore?
" Would be better orginizer than focus.nvim?
" Plug 'simeji/winresizer' " ditched for hydrafied solution
Plug 'https://gitlab.com/yorickpeterse/nvim-pqf.git'
Plug 'chentoast/marks.nvim'
" Plug 'tversteeg/registers.nvim'
" Plug 'AckslD/nvim-neoclip.lua'
" Buffer select. The preview over extends form the borders to window
Plug 'ray-x/lsp_signature.nvim'
" buffer-like
Plug 'simrat39/symbols-outline.nvim'
" Plug 'narutoxy/dim.lua'
Plug 'zbirenbaum/neodim'
" Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'mong8se/actually.nvim'
" TODO: one of this is redundant
Plug 's1n7ax/nvim-window-picker'
" Plug 'https://gitlab.com/yorickpeterse/nvim-window.git'
Plug 'sindrets/winshift.nvim'
Plug 'mrjones2014/smart-splits.nvim'
Plug 'kwkarlwang/bufresize.nvim'
Plug 'MunifTanjim/nui.nvim'
" Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
" Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-hop.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'ahmedkhalf/project.nvim'
Plug 'rmagatti/auto-session'
Plug 'rmagatti/session-lens'
Plug 'windwp/nvim-autopairs'
" TODO: change this for monaqa/dial.nvim or zegervdv/nrpattern.nvim for more
" versatile alternations
Plug 'rmagatti/alternate-toggler'
" Plug 'kevinhwang91/promise-async'
" Plug 'kevinhwang91/nvim-ufo'
" Plug 'lewis6991/satellite.nvim'
Plug 'folke/which-key.nvim'
Plug 'anuvyklack/hydra.nvim'
Plug 'NvChad/nvim-colorizer.lua'
" Plug 'axlebedev/footprints'
Plug 'tweekmonster/startuptime.vim'
Plug 'numToStr/Comment.nvim'
" Plug 'tpope/vim-surround' " TODO: change for kylechui/nvim-surround
Plug 'kylechui/nvim-surround'
" Let there be colorful schemes
Plug 'rebelot/kanagawa.nvim'

Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'levouh/specs.nvim'
Plug 'mvllow/modes.nvim'
Plug 'mbbill/undotree' " TODO: Change for simnalamburt/vim-mundo
Plug 'mhinz/vim-startify'
" Plug 'akinsho/toggleterm.nvim'
" Markdown/Org-mode
Plug 'jakewvincent/mkdnflow.nvim'
Plug 'AckslD/nvim-FeMaco.lua'
" Plug 'iamcco/markdown-preview.nvim'
Plug 'ellisonleao/glow.nvim'
Plug 'kristijanhusak/orgmode.nvim'
Plug 'lukas-reineke/headlines.nvim'
Plug 'akinsho/org-bullets.nvim', { 'for': 'org'}
" Plug 'dhruvasagar/vim-table-mode' "we can use mkdnflow's build in table-mode
Plug 'wfxr/minimap.vim', { 'do': ':!cargo install --locked code-minimap'}
call plug#end()

" Multi Cursor Plugin Configs
let g:VM_leader = {'default': '\', 'visual': '\', 'buffer': 'z'}
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<M-d>'
let g:VM_maps['Find Subword Under'] = '<M-d>'

" let g:minimap_auto_start = 1
let g:minimap_git_colors = 1
let g:minimap_highlight_search = 1
" let g:minimap_auto_start_win_enter = 1
let g:minimap_diffadd_color = 'GitSignsAdd'
let g:minimap_diffremove_color = 'GitSignsDelete'
let g:minimap_diff_color = 'GitSignsChange'
hi MinimapCurrentLine ctermfg=Green guifg=#50FA7B guibg=#32302f
let g:minimap_highlight = 'MinimapCurrentLine'
let g:minimap_block_filetypes = ['neo-tree', 'startify']
" let minimap_close_buftypes = ["nofile"]

function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction
" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction
let g:startify_bookmarks = [ {'c': '~/.config/nvim/'}, {'O': '~/Documents/Org/'}, {'N': '~/Documents/Obsidasion/'}, '~/.zshrc' ]
let g:startify_session_dir = stdpath('data') . '/sessions'
let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU ' . getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Configs']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]
