call plug#begin()
" Plug '~/Documents/development/projects/neovim-plugin/minimap.nvim'
Plug 'tpope/vim-repeat'
Plug 'michaelb/sniprun', { 'do': 'bash install.sh'}
Plug 'rcarriga/nvim-notify'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
" Plug 'chrisgrieser/nvim-various-textobjs' " not what i wantted
" Plug 'Jason-M-Chan/ts-textobjects'
" Plug 'https://gitlab.com/HiPhish/nvim-ts-rainbow2/'
Plug 'HiPhish/rainbow-delimiters.nvim'
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
" Plug 'matze/vim-move'
" Plug 'nvim-pack/nvim-spectre'
" Plug 'ggandor/lightspeed.nvim'
Plug 'ggandor/leap.nvim'
Plug 'ggandor/leap-spooky.nvim'
Plug 'ggandor/flit.nvim'
Plug 'ggandor/leap-ast.nvim'
Plug 'jake-stewart/multicursor.nvim'
" Plug 'folke/flash.nvim'
Plug 'rlane/pounce.nvim'
" Plug 'mg979/vim-visual-multi', { 'branch': 'master'}
" Plug 'mg979/vim-visual-multi' " There is a learning curve for this and
" vanilla vim macros and motions *may* suffice as they say
" plug 'chrisbra/NrrwRgn' " Again it might be useful to edit a region in a
" narrow window of its own
Plug 'abecodes/tabout.nvim'
Plug 'neovim/nvim-lspconfig'
" Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvimtools/none-ls.nvim'
Plug 'j-hui/fidget.nvim'
Plug 'vim-test/vim-test'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/nvim-nio'
Plug 'nvim-neotest/neotest-vim-test'
Plug 'Issafalcon/neotest-dotnet'
" Plug 'williamboman/mason.nvim'
" Plug 'williamboman/mason-lspconfig.nvim'
" Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
"Plug 'ray-x/go.nvim'
" Plug 'crusj/hierarchy-tree-go.nvim'
" Plug 'crusj/structrue-go.nvim'
Plug 'mfussenegger/nvim-jdtls'
Plug 'Hoffs/omnisharp-extended-lsp.nvim'
Plug 'jmederosalvarado/roslyn.nvim'
" Plug 'adamclerk/vim-razor'
" Plug 'habamax/vim-godot'
Plug 'nvimdev/lspsaga.nvim' " Changed from glepnir to a more active fork
Plug 'SmiteshP/nvim-navic'
Plug 'SmiteshP/nvim-navbuddy'
Plug 'Bekaboo/dropbar.nvim'
Plug 'VidocqH/lsp-lens.nvim'
Plug 'danymat/neogen'
Plug 'Fildo7525/pretty_hover'
Plug 'stevearc/dressing.nvim'
" Install nvim-cmp
"Plug 'hrsh7th/nvim-cmp'
" Install the buffer completion source
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
"Plug 'ray-x/cmp-treesitter'
"Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'rachartier/tiny-inline-diagnostic.nvim'
" Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
" Plug 'Exafunction/codeium.vim'
"Plug 'hrsh7th/cmp-cmdline'
"Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
Plug 'folke/trouble.nvim'
" Plug 'octaltree/cmp-look'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'folke/neodev.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-calc'
Plug 'f3fora/cmp-spell'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/cmp-luasnip-choice'
Plug 'chrisgrieser/nvim-scissors'
Plug 'Saghen/blink.cmp', { 'do': ':!cargo build --release'}
Plug 'saghen/blink.compat'
" AI
Plug 'zbirenbaum/copilot.lua'
Plug 'zbirenbaum/copilot-cmp'
Plug 'AndreM222/copilot-lualine'
Plug 'Bryley/neoai.nvim' " alternative: jackMort/ChatGPT.nvim
Plug 'jackMort/ChatGPT.nvim'
Plug 'David-Kunz/gen.nvim'

" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'rcarriga/cmp-dap'
Plug 'theHamsta/nvim-dap-virtual-text', { 'branch': 'inline-text' }
Plug 'leoluz/nvim-dap-go'
Plug 'mfussenegger/nvim-dap-python'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'ofirgall/goto-breakpoints.nvim'
Plug 'LiadOz/nvim-dap-repl-highlights'
Plug 'jbyuki/one-small-step-for-vimkind'
Plug 'leoluz/nvim-dap-go'

Plug 'vhyrro/luarocks.nvim'
Plug 'stevearc/overseer.nvim'
Plug 'esensar/nvim-dev-container'
Plug 'arnaupv/nvim-devcontainer-cli'
Plug 'jamestthompson3/nvim-remote-containers'
"Plug 'rest-nvim/rest.nvim'
" Plug 'tom-doerr/vim_codex'
Plug 'sindrets/diffview.nvim'
Plug 'kazhala/close-buffers.nvim'
Plug 'dstein64/nvim-scrollview'
Plug 'karb94/neoscroll.nvim'
" Plug 'petertriho/nvim-scrollbar'
Plug 'kevinhwang91/nvim-hlslens'
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
Plug 'hedyhli/outline.nvim'
" Plug 'narutoxy/dim.lua'
Plug 'zbirenbaum/neodim'
" Plug 'kyazdani42/nvim-tree.lua'
" Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'main' }
Plug 'stevearc/oil.nvim'
Plug 'mong8se/actually.nvim'
" TODO: one of this is redundant
Plug 's1n7ax/nvim-window-picker'
" Plug 'https://gitlab.com/yorickpeterse/nvim-window.git'
Plug 'sindrets/winshift.nvim'
Plug 'mrjones2014/smart-splits.nvim'
Plug 'kwkarlwang/bufresize.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'carbon-steel/detour.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
" Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-hop.nvim'
Plug 'debugloop/telescope-undo.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'NeogitOrg/neogit', {'branch': 'master'}
Plug 'akinsho/git-conflict.nvim'
Plug 'ahmedkhalf/project.nvim'
" Plug 'GnikDroy/projections.nvim'
Plug 'klen/nvim-config-local'
" Plug 'rmagatti/auto-session'
" Plug 'rmagatti/session-lens'
Plug 'windwp/nvim-autopairs'
Plug 'utilyre/sentiment.nvim'
Plug 'pocco81/true-zen.nvim'
Plug 'folke/zen-mode.nvim'
" TODO: change this for monaqa/dial.nvim or zegervdv/nrpattern.nvim for more
" versatile alternations
"Plug 'rmagatti/alternate-toggler'
Plug 'gbprod/yanky.nvim'
" Plug 'kevinhwang91/promise-async'
" Plug 'kevinhwang91/nvim-ufo'
" Plug 'lewis6991/satellite.nvim'
Plug 'folke/which-key.nvim'
Plug 'anuvyklack/hydra.nvim'
Plug 'NvChad/nvim-colorizer.lua'
" Plug 'axlebedev/footprints'
" Plug 'tweekmonster/startuptime.vim'
" Plug 'numToStr/Comment.nvim'
" Plug 'tpope/vim-surround' " TODO: change for kylechui/nvim-surround
Plug 'kylechui/nvim-surround'
" Let there be colorful schemes
Plug 'rebelot/kanagawa.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'talha-akram/noctis.nvim'
Plug 'uloco/bluloco.nvim'
Plug 'scottmckendry/cyberdream.nvim'
" Plug 'arturgoms/moonbow.nvim'
" Plug 'mcchrish/zenbones.nvim'
Plug 'rktjmp/lush.nvim'
" Plug 'hardhackerlabs/oh-my-nvim'

Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'levouh/specs.nvim'
Plug 'mvllow/modes.nvim'
Plug 'mbbill/undotree' " TODO: Change for simnalamburt/vim-mundo
Plug 'tzachar/highlight-undo.nvim'
" Plug 'mhinz/vim-startify'
Plug 'nvimdev/dashboard-nvim'
Plug 'olimorris/persisted.nvim'
" Plug 'nvimdev/dbsession.nvim'
" Plug 'akinsho/toggleterm.nvim'
Plug 'willothy/flatten.nvim'
" Markdown/Org-mode
Plug 'epwalsh/obsidian.nvim'
Plug 'jakewvincent/mkdnflow.nvim'
Plug 'AckslD/nvim-FeMaco.lua'
Plug 'toppair/peek.nvim', { 'do': 'deno task --quiet build:fast'}
" Plug 'jmbuhr/otter.nvim'
" Plug 'iamcco/markdown-preview.nvim'
Plug 'ellisonleao/glow.nvim'
" Plug 'kristijanhusak/orgmode.nvim'
" Plug 'lukas-reineke/headlines.nvim'
Plug 'MeanderingProgrammer/markdown.nvim'
Plug 'theKnightsOfRohan/csvlens.nvim'
" Plug 'akinsho/org-bullets.nvim', { 'for': 'org'}
" Plug 'dhruvasagar/vim-table-mode' "we can use mkdnflow's build in table-mode
Plug 'wfxr/minimap.vim', { 'do': ':!cargo install --locked code-minimap'}
Plug 'gorbit99/codewindow.nvim'
Plug 'gennaro-tedesco/nvim-jqx'
call plug#end()

"" Multi Cursor Plugin Configs
"let g:VM_leader = {'default': '\', 'visual': '\', 'buffer': 'z'}
"let g:VM_maps = {}
"let g:VM_maps['Find Under']         = '<M-d>'
"let g:VM_maps['Find Subword Under'] = '<M-d>'

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
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU ' . getcwd()] },
        \ { 'type': 'bookmarks', 'header': ['   Configs']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]
