-- LSP settings
-- require("lazydev").setup({
-- 	library = {
-- 		-- See the configuration section for more details
-- 		-- Load luvit types when the `vim.uv` word is found
-- 		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
-- 	},
-- })
local nvim_lsp = require("lspconfig")
vim.o.pumborder = "rounded"
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
vim.api.nvim_set_hl(0, "PmenuBorder", { bg = "NONE", fg = "#CC6600" })
-- require('tiny-inline-diagnostic').setup({
-- })
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
local doc_hl = require("lsp.document_highlight")
local on_attach = function(client, bufnr)
	-- if client.server_capabilities.inlayHintProvider then
	--     vim.lsp.inlay_hint.enable(bufnr, true)
	-- end
	-- This methods considers dynamic registration as per neovim/neovim/pull/23681
	-- Instead use `client.supports_method(<method>)`. It considers both the dynamic capabilities and static `server_capabilities`.
	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) -- include bufnr for safety
	end

	if client:supports_method("textDocument/codeLens") then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
		-- vim.keymap.set("n", "\\f", function() end, { desc = "Keep highlighting symbol under cursor" })

		-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		-- 	buffer = bufnr,
		-- 	callback = function()
		-- 		vim.lsp.codelens.refresh()
		-- 	end,
		-- 	desc = "Auto-refresh CodeLens",
		-- })
	end
	-- used to use tree-sitter-refactor for highlighting definitions under cursor
	if client:supports_method("textDocument/documentHighlight") then
		-- vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
		-- local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
		-- local persistent_hl_group = vim.api.nvim_create_augroup("persistent_hl_group", { clear = false })
		--
		-- vim.api.nvim_clear_autocmds({ buffer = bufnr, group = persistent_hl_group })
		-- vim.keymap.set("n", "\\f", function() end, { desc = "Keep highlighting symbol under cursor" })
		-- vim.keymap.set("n", "<C-l>", function() end, { desc = "Keep highlighting symbol under cursor" })
		-- vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })

		-- NOTE: Snacks.words handle this highlight
		-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		-- 	callback = vim.lsp.buf.document_highlight,
		-- 	buffer = bufnr,
		-- 	group = group,
		-- 	desc = "Document Highlight",
		-- })
		-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		-- 	callback = vim.lsp.buf.clear_references,
		-- 	buffer = bufnr,
		-- 	group = group,
		-- 	desc = "Clear All the References",
		-- })

		-- Current behavior, but through your own transient namespace.
		-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		-- 	buffer = bufnr,
		-- 	group = group,
		-- 	callback = function()
		-- 		doc_hl.request(doc_hl.ns.transient, bufnr)
		-- 	end,
		-- 	desc = "Document Highlight",
		-- })
		--
		-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		-- 	buffer = bufnr,
		-- 	group = group,
		-- 	callback = function()
		-- 		doc_hl.clear(doc_hl.ns.transient, bufnr)
		-- 	end,
		-- 	desc = "Clear transient references",
		-- })

		-- Sticky / persistent highlight.
		vim.keymap.set("n", "<leader>hl", function()
			doc_hl.request(doc_hl.ns.sticky, bufnr)
		end, { buffer = bufnr, desc = "Sticky document highlight" })

		vim.keymap.set("n", "<leader>hL", function()
			doc_hl.clear(doc_hl.ns.sticky, bufnr)
		end, { buffer = bufnr, desc = "Clear sticky document highlight" })
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

-- TODO: make capabilities more sensible
-- capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), capabilities)
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
capabilities.textDocument.diagnostic.dynamicRegistration = true
capabilities.textDocument.onTypeFormatting = { dynamicRegistration = false }
-- capabilities.textDocument.codeLens.dynamicRegistration = true
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}
capabilities.textDocument.foldingRange = {
	dynamicRegistration = true,
	lineFoldingOnly = true,
}

nvim_lsp.util.default_config = vim.tbl_deep_extend("force", nvim_lsp.util.default_config, {
	on_attach = on_attach,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	},
})
-- PHP
-- nvim_lsp.intelephense.setup({
--     -- cmd = { "phpactor", "-vvv", "language-server" },
--     cmd = { "intelephense", "--stdio" },
--     filetypes = { "php" },
--     -- root_dir = root_pattern("composer.json", ".git"),
-- })
-- Styling
-- nvim_lsp.ls_emmet.setup({})
vim.lsp.enable("emmet_language_server") -- https://github.com/olrtg/emmet-language-server
vim.lsp.enable("cssls")
require("lsp.biome-lsp") -- refactor away for clutter
vim.lsp.enable("eslint")
vim.lsp.enable("html")
-- nvim_lsp.cssls.setup({})
-- nvim_lsp.jsonls.setup({})
-- nvim_lsp.biome.setup({}) -- instead of rome (unmaintained)
-- nvim_lsp.eslint.setup({})
-- vim.lsp.config('html', {
--     cmd = { "vscode-html-language-server", "--stdio" },
--     filetypes = { "html" },
--     init_options = {
--         configurationSection = { "html", "css", "javascript" },
--         embeddedLanguages = {
--             css = true,
--             javascript = true,
--         },
--     },
--     -- root_dir = function(fname)
--     --       return util.root_pattern('package.json', '.git')(fname) or util.path.dirname(fname)
--     --     end,
--     settings = {},
-- })
vim.lsp.enable("html")
-- CSS Language Server
-- nvim_lsp.cssls.setup({})
-- local configs = require("lspconfig.configs")
-- if not configs.ls_emmet then
--     configs.ls_emmet = {
--         default_config = {
--             cmd = { "ls_emmet", "--stdio" },
--             filetypes = {
--                 "html",
--                 "css",
--                 "scss",
--                 "javascript",
--                 "javascriptreact",
--                 "typescript",
--                 "typescriptreact",
--                 "haml",
--                 "xml",
--                 "xsl",
--                 "pug",
--                 "slim",
--                 "sass",
--                 "stylus",
--                 "less",
--                 "sss",
--             },
--             root_dir = function(_)
--                 return vim.loop.cwd()
--             end,
--             settings = {},
--         },
--     }
-- end
-- Vim LSP
vim.lsp.enable("vimls")
-- TSSERVER
vim.lsp.enable("ts_ls")
vim.lsp.enable("quick_lint_js")
-- nvim_lsp.quick_lint_js.setup({})
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
vim.lsp.config("gopls", {
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
vim.lsp.enable("gopls")
-- LUA LSP
-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")
-- require("neodev").setup({
-- 	-- add any options here, or leave empty to use the default settings
-- })
vim.lsp.config("lua_ls", {
	---@param client vim.lsp.Client
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- vim.env.VIMRUNTIME .. "/lua",
					vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
				},
			},
		})
	end,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			completion = {
				callSnippet = "Replace",
			},
			hint = {
				enable = true,
			},
		},
	},
})
vim.lsp.enable("lua_ls")
local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		json = { "biome" }, -- set -gx BIOME_CONFIG_PATH ~/.config/biome
		javascript = { "oxfmt" },
		javascriptreact = { "oxfmt" },
		typescript = { "oxfmt" },
		typescriptreact = { "oxfmt" },
		xml = { "yq" },
		yaml = { "yq" },
		cs = { "csharpier" },
		python = { "isort", "black" },
		-- markdown = { "markdownlint" },
		markdown = { "rumdl" },
		-- TODO: implement
		-- javascript = { "prettierd", "prettier", stop_after_first = true },
		-- xml = {}
	},
})
require("lint").linters_by_ft = {
	-- markdown = { "markdownlint", "proselint", "codespell" },
	markdown = { "rumdl", "proselint", "codespell" },
	-- cs = { 'csharpier' },
	gitcommit = { "commitlint" },
	yaml = { "yamllint" },
	json = { "biome" },
	vim = { "vint" },
	-- xml = {'tidy'},
}
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- nvim_lsp.rust_analyzer.setup({})

vim.lsp.config("roslyn", {
	-- on_attach = function(client, bufnr)
	--     monkey_patch_semantic_tokens(client)
	--     on_attach(client, bufnr)
	-- end,                         -- required
	-- on_attach = monkey_patch_semantic_tokens,
	cmd = {
		-- "dotnet",
		-- "roslyn-ls",
		"roslyn-language-server", -- dotnet new install -g roslyn-language-server --prerelease
		"--logLevel=Information",
		"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
		"--autoLoadProjects",
		"--stdio",
	},
	on_attach = on_attach,
	capabilities = capabilities, -- required
	settings = {
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
			csharp_enable_inlay_hints_for_lambda_parameter_types = true,
			csharp_enable_inlay_hints_for_types = true,
			dotnet_enable_inlay_hints_for_indexer_parameters = true,
			dotnet_enable_inlay_hints_for_literal_parameters = true,
			dotnet_enable_inlay_hints_for_object_creation_parameters = true,
			dotnet_enable_inlay_hints_for_other_parameters = true,
			dotnet_enable_inlay_hints_for_parameters = true,
			-- dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
			-- dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
			-- dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
			-- dotnet_enable_tests_code_lens = true,
		},
		["csharp|completion"] = {
			dotnet_show_completion_items_from_unimported_namespaces = true,
			dotnet_show_name_completion_suggestions = true,
		},
		["csharp|symbol_search"] = {
			dotnet_search_reference_assemblies = true,
		},
		["csharp|background_analysis"] = {
			dotnet_analyzer_diagnostics_scope = "fullSolution",
			dotnet_compiler_diagnostics_scope = "fullSolution",
		},
		["csharp|formatting"] = {
			dotnet_organize_imports_on_format = true,
		},
	},
})
-- vim.lsp.enable("roslyn") -- already enabling it through roslyn.nvim
require("roslyn").setup({
	filewatching = "roslyn",
})

-- TODO: improve neotest discovery
vim.lsp.commands["dotnet.test.run"] = function(command)
	local args = command.arguments or {}
	local data = args[1]
	if not data then
		vim.notify("No test information in CodeLens args", vim.log.levels.WARN)
		return
	end

	local uri = data.textDocument and data.textDocument.uri
	if not uri then
		vim.notify("Missing URI in CodeLens data", vim.log.levels.WARN)
		return
	end

	local file = vim.uri_to_fname(uri)
	local row = data.range.start.line + 1 -- Lua is 1-based, LSP is 0-based

	-- Use Neotest to run the test at the given line
	require("neotest").run.run({
		path = file,
		-- You can use `pos` to target line more directly
		pos = {
			path = file,
			row = row,
			col = data.range.start.character,
		},
	})
end

-- nvim_lsp.razor.setup({
-- 	cmd = { "rzls" },
-- })

-- local util = require 'lspconfig.util'
vim.lsp.enable("gdscript")
vim.lsp.enable("clangd") -- ~/.clang-format has indentation settings
-- Markup
vim.lsp.enable("yamlls")
vim.lsp.enable("dockerls")
vim.lsp.enable("docker_compose_language_service")
-- DB
vim.lsp.enable("sqls")
-- vim.lsp.enable('graphql')
-- nvim_lsp.graphql.setup({
--     -- root_dir =  util.root_pattern('.graphqlrc*', '.graphql.config.*', 'graphql.config.*', '.git'),
-- })
-- TEXT
-- vim.lsp.enable("typos_lsp")
vim.lsp.enable("markdown_oxide")
vim.lsp.enable("marksman")
-- vim.lsp.enable("vale_ls")
-- nvim_lsp.vale_ls.setup({ cmd = { "vale" } })
