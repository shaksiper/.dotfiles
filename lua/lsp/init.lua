-- LSP settings
local nvim_lsp = require("lspconfig")
vim.diagnostic.config({
	virtual_text = true,
	-- https://github.com/neovim/neovim/commit/8122470f8310ae34bcd5e436e8474f9255eb16f2
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = false,
})

-- local util = require("lspconfig.util")
local signature_config = {
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	-- If you want to hook lspsaga or other signature handler, pls set to false

	floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
	hint_enable = true, -- virtual hint enable
	hint_prefix = "🐼 ", -- Panda for parameter
	hint_scheme = "String",
	max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
	-- to view the hiding contents
	max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
	transparency = 25, -- disabled by default, allow floating win transparent value 1~100
	handler_opts = {
		border = "single", -- double, single, shadow, none
	},
	-- hint_inline = function()
	-- 	return true
	-- end,
	trigger_on_newline = false, -- set to true if you need multiple line parameter, sometime show signature on new line can be confusing, set it to false for #58
	zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
	padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
	toggle_key = "<M-x>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
	select_signature_key = "<M-n>", -- cycle to next signature, e.g. '<M-n>' function overloading
}
require("lsp_signature").setup(signature_config)
local lspsaga_conf = {
	-- diagnostic_header = { " ", " ", " ", "ﴞ " },
	-- show_diagnostic_source = true,
	ui = {
		-- currently only round theme
		theme = "round",
		-- border type can be single,double,rounded,solid,shadow.
		border = "rounded",
		winblend = 15,
	},
	-- beacon = {
	--     enable = true,
	--     frequency = 7
	-- },
	symbol_in_winbar = { enable = false },
	diagnostic = {
		-- on_insert_follow = true,
		show_code_action = true,
		show_source = true,
		jump_num_shortcut = true,
		keys = {
			exec_action = "o",
			-- expand_or_jump = "<CR>",
			quit = "<ESC>",
		},
	},
	code_action = {
		num_shortcut = true,
		keys = {
			quit = "<ESC>",
			exec = "<CR>",
		},
	},
	lightbulb = {
		enable = false,
		enable_in_insert = true,
		sign = true,
		sign_priority = 40,
		virtual_text = true,
	},
	finder = {
		open = "o",
		vsplit = "<c-v>",
		split = "<c-s>",
		tabe = "t",
		quit = "<ESC>",
		scroll_down = "<C-f>",
		scroll_up = "<C-b>", -- quit can be a table
	},
	rename = {
		quit = "<ESC>",
		exec = "<CR>",
		in_select = true,
	},
	-- definition_preview_icon = "  ",
}
require("lspsaga").setup(lspsaga_conf)
--[[ local navic = require("nvim-navic")
navic.setup({
	highlight = false,
	separator = " ",
	depth_limit = 5,
	depth_limit_indicator = "..",
}) ]]
require("nvim-navbuddy").setup({
	lsp = {
		auto_attach = true, -- If set to true, you don't need to manually use attach function
	},
})
local on_attach = function(client, bufnr)
	-- if client.server_capabilities.inlayHintProvider then
	--     vim.lsp.inlay_hint.enable(bufnr, true)
	-- end
	-- This methods considers dynamic registration as per neovim/neovim/pull/23681
	-- Instead use `client.supports_method(<method>)`. It considers both the dynamic capabilities and static `server_capabilities`.
	if client.supports_method("inlayHintProvider") then
		vim.lsp.inlay_hint.enable(true)
	end
	-- used to use tree-sitter-refactor for highlighting definitions under cursor
	if client.server_capabilities.documentHighlightProvider then
		-- if client.supports_method("documentHighlightProvider") then -- jsonls + biome cause problems with json files
		vim.api.nvim_create_augroup("lsp_document_highlight", {
			clear = false,
		})
		vim.api.nvim_clear_autocmds({
			buffer = bufnr,
			group = "lsp_document_highlight",
		})
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
	-- require'lsp_signature'.on_attach(cfg, bufnr)
	-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc') -- why was it here anyways??

	-- vim.lsp.buf.inlay_hint(0, true)
	local opts = { noremap = true, silent = true }
	vim.keymap.set("n", "<leader>fsw", "<cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols()<cr>", opts)
	vim.keymap.set(
		"n",
		"<leader>fsd",
		"<cmd>lua require'telescope.builtin'.lsp_document_symbols(require('telescope.themes').get_ivy({}))<cr>",
		opts
	)
	vim.keymap.set("n", "<leader>fdd", "<cmd>Telescope diagnostics bufnr=0<cr>", opts)
	vim.keymap.set("n", "<leader>fwd", "<cmd>Telescope diagnostics<cr>", opts)
	-- vim.keymap.set("n", "<leader>fso", "<cmd>Telescope lsp_workspace_symbols<cr>", opts)
	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "<leader>gdd", "<cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
	vim.keymap.set("n", "<leader>gdf", "<cmd>DetourCurrentWindow<CR><cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
	vim.keymap.set("n", "<leader>gds", "<C-w>s<cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
	vim.keymap.set("n", "<leader>gdv", "<C-w>v<cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
	vim.keymap.set("n", "<leader>gtd", "<Cmd>Telescope lsp_type_definitions theme=ivy<CR>", opts)
	vim.keymap.set("n", "<leader>g>", "<Cmd>Telescope lsp_outgoing_calls theme=ivy<CR>", opts)
	vim.keymap.set("n", "<leader>g<", "<Cmd>Telescope lsp_incoming_calls theme=ivy<CR>", opts)

	vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
	vim.keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations theme=ivy<CR>", opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	-- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	vim.keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references theme=ivy<CR>", opts)
	vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	vim.keymap.set("v", "<leader>ca", ":Telescope range_code_action<CR>", opts)

	-- vim.keymap.set("n", "<leader>cla", "V:<C-U>Lspsaga range_code_action<CR>", opts) -- Code line action
	vim.keymap.set("n", "gh", "<cmd>Lspsaga finder<CR>", opts)
	vim.keymap.set("n", "\\p", "<cmd>Lspsaga peek_definition<CR>", opts)
	vim.keymap.set("n", "\\P", "<cmd>Lspsaga peek_type_definition<CR>", opts)
	-- Only jump to error
	vim.keymap.set("n", "[D", function()
		require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, { silent = true })
	vim.keymap.set("n", "]D", function()
		require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, { silent = true })
	vim.keymap.set("n", "<leader>gf", "<cmd>lua vim.lsp.buf.format{ asyny = true }<CR>", opts)
	vim.keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	vim.keymap.set("n", "<leader>glf", "V<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts) -- Code line formatting, for whatever it's worth.
	vim.keymap.set("n", "<leader>e", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
	vim.keymap.set("n", "<leader>ce", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
	vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
	vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
	vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", opts)
	-- vim.keymap.set("n", "<leader>so", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
	-- TROUBLE
	vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>", { desc = "Trouble" })
	vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble WP Diagnostics" })
	vim.keymap.set(
		"n",
		"<leader>xd",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		{ desc = "Trouble WP Diagnostics" }
	)
	vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble Buffer Diagnostics" })
	vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", { desc = "Trouble Quickfix" })
	vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "Trouble LSP Ref." })
end

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), capabilities)
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}
-- capabilities.textDocument.foldingRange = {
-- 	dynamicRegistration = false,
-- 	lineFoldingOnly = true,
-- }

nvim_lsp.util.default_config = vim.tbl_deep_extend("force", nvim_lsp.util.default_config, {
	on_attach = on_attach,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	},
})
nvim_lsp.intelephense.setup({
	-- cmd = { "phpactor", "-vvv", "language-server" },
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	-- root_dir = root_pattern("composer.json", ".git"),
})
nvim_lsp.html.setup({
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
	},
	-- root_dir = function(fname)
	--       return util.root_pattern('package.json', '.git')(fname) or util.path.dirname(fname)
	--     end,
	settings = {},
})
-- CSS Language Server
nvim_lsp.cssls.setup({})
local configs = require("lspconfig.configs")
if not configs.ls_emmet then
	configs.ls_emmet = {
		default_config = {
			cmd = { "ls_emmet", "--stdio" },
			filetypes = {
				"html",
				"css",
				"scss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"haml",
				"xml",
				"xsl",
				"pug",
				"slim",
				"sass",
				"stylus",
				"less",
				"sss",
			},
			root_dir = function(_)
				return vim.loop.cwd()
			end,
			settings = {},
		},
	}
end
nvim_lsp.ls_emmet.setup({})

nvim_lsp.cssls.setup({})
nvim_lsp.jsonls.setup({})

-- Vim LSP
nvim_lsp.vimls.setup({
	-- Defaults
})
-- TSSERVER
nvim_lsp.ts_ls.setup({
	-- Defaults
})
nvim_lsp.quick_lint_js.setup({})
-- ray-x/go.nvim init
-- This plugin sets global configs which interfere with my config
-- require("go").setup({
--     max_line_len = 120,
--     tag_transform = false,
--     test_dir = "",
--     comment_placeholder = "   ",
--     diagnostic = false,
-- })
-- GOPLS
nvim_lsp.gopls.setup({
	cmd = { "gopls", "serve" },
	settings = {
		gopls = {
			gofumpt = true,
			analyses = {
				unusedparams = true,
				shadow = true,
				fieldalignment = true,
				nilness = true,
			},
			staticcheck = true,
		},
	},
})
-- LUA LSP
-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")
require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
})
nvim_lsp.lua_ls.setup({
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			hint = {
				enable = true,
			},
		},
	},
})
-- JAVA LS
-- It is temporarily out of service due to not being compiled
-- TODO make it more dynamic
-- nvim_lsp.java_language_server.setup({
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- 	cmd = { "/home/shaksiper/Downloads/LSP/java-language-server/dist/lang_server_linux.sh" },
-- 	--[[ filetypes = { "java" },
--     root_dir = function(startpath)
--         return M.search_ancestors(startpath, matcher)
--     end, --]]
-- })

nvim_lsp.kotlin_language_server.setup({})

-- Python => PyLs
-- nvim_lsp.pylsp.setup({})
nvim_lsp.pyright.setup({})
-- nvim_lsp.pylyzer.setup({}) -- a lot error raised
-- NULL_LS setup
local null_ls = require("null-ls")
require("null-ls").setup({
	on_attach = on_attach,
	capabilities = capabilities,
	sources = {
		null_ls.builtins.formatting.uncrustify,
		null_ls.builtins.diagnostics.vint, -- vim
		-- null_ls.builtins.formatting.prettierd,
		-- null_ls.builtins.formatting.rome, -- unmaintained -> Replaced by biome
		null_ls.builtins.formatting.biome, -- patched rome to use biome as cmd
		-- null_ls.builtins.diagnostics.cspell,
		-- null_ls.builtins.code_actions.cspell,
		-- C-like
		-- null_ls.builtins.formatting.uncrustify,
		-- null_ls.builtins.formatting.clang_format,

		-- C#
		null_ls.builtins.formatting.csharpier,
		-- TODO: install/setup the following tools
		-- null_ls.builtins.diagnostics.semgrep,
		-- null_ls.builtins.diagnostics.golangci_lint,
		--
		-- null_ls.builtins.diagnostics.eslint_d,
		-- null_ls.builtins.formatting.eslint_d,
		-- See: [:h vim.lsp.buf.formatting_seq_sync]
		-- require("null-ls.helpers").conditional(function(utils)
		-- 	local b = null_ls.builtins
		-- 	return utils.root_has_file(".eslintrc.js") and b.formatting.eslint_d --[[ or b.formatting.prettierd ]]
		-- end),

		-- JAVA
		-- null_ls.builtins.formatting.google_java_format, -- needs [ https://github.com/google/google-java-format ] installed

		-- JS
		-- null_ls.builtins.diagnostics.eslint_d,
		-- null_ls.builtins.code_actions.eslint_d,
		-- null_ls.builtins.formatting.eslint_d, .with({
		-- 	condition = function(utils)
		-- 		return utils.root_has_file(".eslintrc.js")
		-- 	end,
		-- })

		-- Go Lang
		-- null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.gofumpt, -- alternative to gofmt?
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.diagnostics.buf, -- protocol buffer
		null_ls.builtins.formatting.buf,

		-- Lua
		null_ls.builtins.formatting.stylua,

		--Markdown
		-- null_ls.builtins.formatting.cbfmt, -- FeMaco to edit/format codeblocks on separate buffer suffices.
		null_ls.builtins.diagnostics.markdownlint,
		null_ls.builtins.formatting.markdownlint,
		-- null_ls.builtins.formatting.mdformat,

		-- Python related
		null_ls.builtins.diagnostics.pylint,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.djhtml,

		-- Spelling
		-- null_ls.builtins.completion.spell.with({
		-- 	filetypes = { "markdown", "org" },
		-- }),
		-- null_ls.builtins.diagnostics.typos,
		null_ls.builtins.diagnostics.proselint,
		null_ls.builtins.code_actions.proselint,
		null_ls.builtins.diagnostics.commitlint.with({ filetypes = { "NeogitCommitMessage", "gitcommit" } }),
		-- null_ls.builtins.diagnostics.textlint,
		-- null_ls.builtins.formatting.tidy,
		-- null_ls.builtins.diagnostics.codespell,

		--XML - HTML
		null_ls.builtins.formatting.tidy,
		null_ls.builtins.diagnostics.tidy,
		-- YML
		-- null_ls.builtins.formatting.yamlfix,
		-- null_ls.builtins.formatting.yq,
		null_ls.builtins.diagnostics.yamllint,
		null_ls.builtins.formatting.yamlfmt,
	},
})
nvim_lsp.marksman.setup({})
nvim_lsp.vale_ls.setup({})

nvim_lsp.rust_analyzer.setup({})

-- nvim_lsp.csharp_ls.setup({
-- 	-- on_attach = on_attach,
-- 	-- capabilities = capabilities,
--     filetypes = {"cs", "razor"}
-- })

-- require("mason").setup()
-- require("mason-lspconfig").setup()

-- require("roslyn").setup({
--     -- dotnet_cmd = "dotnet",           -- this is the default
--     -- roslyn_version = "4.8.0-3.23475.7", -- this is the default
--     on_attach = on_attach,           -- required
--     capabilities = capabilities,     -- required
-- })

nvim_lsp.omnisharp.setup({
	-- Dependency : https://github.com/Hoffs/omnisharp-extended-lsp.nvim
	handlers = {
		["textDocument/definition"] = require("omnisharp_extended").handler,
	},
	-- cmd = { "mono", "/home/shaksiper/LSP/omnisharp-mono/OmniSharp.exe" },
	cmd = { "Omnisharp" },
	enable_ms_build_load_projects_on_demand = false,
	-- Enables support for roslyn analyzers, code fixes and rulesets.
	-- enable_roslyn_analyzers = true,
	organize_imports_on_format = false,
	enable_import_completion = true,
})

-- nvim_lsp.razor.setup({
-- 	cmd = { "rzls" },
-- })

-- local pid = vim.fn.getpid() -- not a good LS
-- nvim_lsp.omnisharp.setup({
-- 	cmd = { "OmniSharp", "--languageserver", "--hostPID", tostring(pid) },
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- })
-- local util = require 'lspconfig.util'
nvim_lsp.graphql.setup({
	-- root_dir =  util.root_pattern('.graphqlrc*', '.graphql.config.*', 'graphql.config.*', '.git'),
})
nvim_lsp.gdscript.setup({})
nvim_lsp.clangd.setup({}) -- ~/.clang-format has indentation settings
nvim_lsp.dockerls.setup({})
nvim_lsp.docker_compose_language_service.setup({})
nvim_lsp.biome.setup({}) -- instead of rome (unmaintained)
nvim_lsp.eslint.setup({})
nvim_lsp.yamlls.setup({})
nvim_lsp.typos_lsp.setup({})
nvim_lsp.markdown_oxide.setup({})
nvim_lsp.sqls.setup({ cmd = { "sqls", "-config", "~/sqls/config.yml" } })
