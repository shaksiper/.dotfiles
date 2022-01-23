-- LSP settings
local nvim_lsp = require("lspconfig")
local cfg = {
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	-- If you want to hook lspsaga or other signature handler, pls set to false

	floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
	hint_enable = true, -- virtual hint enable
	hint_prefix = "🐼 ", -- Panda for parameter
	hint_scheme = "String",
	max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
	-- to view the hiding contents
	max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
	transpancy = 10, -- set this value if you want the floating windows to be transpant (100 fully transpant), nil to disable(default)
	handler_opts = {
		border = "single", -- double, single, shadow, none
	},

	trigger_on_newline = false, -- set to true if you need multiple line parameter, sometime show signature on new line can be confusing, set it to false for #58
	extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
	-- deprecate !!
	-- decorator = {"`", "`"}  -- this is no longer needed as nvim give me a handler and it allow me to highlight active parameter in floating_window
	zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom

	padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

	toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
}
require("lsp_signature").setup(cfg)
local saga = require("lspsaga")
saga.init_lsp_saga({
	code_action_prompt = {
		enable = true,
		sign = true,
		sign_priority = 20,
		virtual_text = false,
	},
})

-- go to preview plugin setup to show a floating window for def/imp preview
-- require('goto-preview').setup {
--     width = 100; -- Width of the floating window
--     height = 15; -- Height of the floating window
--     default_mappings = false; -- Bind default mappings
--     debug = false; -- Print debug information
--     opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
--     post_open_hook = nil -- A function taking two arguments, a buffer and a window to be ran as a hook.
-- }
local on_attach = function(_, bufnr) -- (client, bufnr)
	-- require'lsp_signature'.on_attach(cfg, bufnr)
	-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc') -- why was it here anyways??

	local opts = { noremap = true, silent = true }
	vim.keymap.set("n", "<leader>gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.keymap.set("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	-- vim.keymap.set(bufnr, 'n', 'gpd', '<cmd>lua require(\'goto-preview\').goto_preview_definition()<CR>', opts)
	-- vim.keymap.set(bufnr, 'n', 'gpi', '<cmd>lua require(\'goto-preview\').goto_preview_implementation()<CR>', opts)
	-- vim.keymap.set(bufnr, 'n', '<leader>gp', '<cmd>lua require(\'goto-preview\').close_all_win()<CR>', opts)
	vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
	-- vim.keymap.set(bufnr, 'n', '<C-f>', '<cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(1)<CR>', opts)
	-- vim.keymap.set(bufnr, 'n', '<C-b>', '<cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(-1)<CR>', opts)
	vim.keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	vim.keymap.set("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

	vim.keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	vim.keymap.set("v", "<leader>ca", ":Telescope range_code_action<CR>", opts)

	vim.keymap.set("n", "<leader>cla", "V:<C-U>Lspsaga range_code_action<CR>", opts) -- Code line action
	vim.keymap.set("n", "<leader>gh", "<cmd>lua require('lspsaga.provider').lsp_finder()<CR>", opts)
	vim.keymap.set("n", "<leader>gf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	vim.keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	vim.keymap.set("n", "<leader>glf", "V<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts) -- Code line formatting, for whatever it's worth.
	vim.keymap.set("n", "<leader>e", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
	vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
	vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
	vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", opts)
	vim.keymap.set("n", "<leader>so", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}
nvim_lsp.intelephense.setup({
	-- cmd = { "phpactor", "-vvv", "language-server" },
	cmd = { "intelephense", "--stdio" },
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "php" },
	-- root_dir = root_pattern("composer.json", ".git"),
})
nvim_lsp.html.setup({
	cmd = { "vscode-html-language-server", "--stdio" },
	on_attach = on_attach,
	capabilities = capabilities,
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
nvim_lsp.cssls.setup({
	capabilities = capabilities,
})
local configs = require("lspconfig/configs")
if not nvim_lsp.emmet_ls then
	configs.emmet_ls = {
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
			-- root_dir = function(fname)
			--     return vim.loop.cwd()
			-- end;
			settings = {},
		},
	}
end
nvim_lsp.emmet_ls.setup({ capabilities = capabilities })

nvim_lsp.cssls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
nvim_lsp.jsonls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Vim LSP
nvim_lsp.vimls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	-- Defaults
})
-- TSSERVER
nvim_lsp.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	-- Defaults
})
-- GOPLS
require("go").setup({
	max_line_len = 120,
	tag_transform = false,
	test_dir = "",
	comment_placeholder = "   ",
}) -- ray-x/go.nvim init
nvim_lsp.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
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
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
nvim_lsp.sumneko_lua.setup({
	-- cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
-- JAVA LS
nvim_lsp.java_language_server.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "/home/shaksiper/Documents/java-language-server/dist/lang_server_linux.sh" },
	--[[ filetypes = { "java" },
    root_dir = function(startpath)
        return M.search_ancestors(startpath, matcher)
    end, --]]
})
-- JDTLS from eclipse
nvim_lsp.jdtls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
-- NULL_LS setup
local null_ls = require("null-ls")
require("null-ls").setup({
	on_attach = on_attach,
	capabilities = capabilities,
	sources = {
		-- null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.gofumpt, -- alternative to gofmt?
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.diagnostics.markdownlint,
		-- null_ls.builtins.diagnostics.eslint_d,
		-- null_ls.builtins.formatting.eslint_d,
		require("null-ls.helpers").conditional(function(utils)
			local b = null_ls.builtins
			return utils.root_has_file(".eslintrc.js") and b.formatting.eslint_d --[[ or b.formatting.prettierd ]]
		end),
	},
})
