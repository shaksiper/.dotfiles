-- LSP settings
local nvim_lsp = require("lspconfig")
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
    trigger_on_newline = false,     -- set to true if you need multiple line parameter, sometime show signature on new line can be confusing, set it to false for #58
    zindex = 200,                   -- by default it will be on top of all floating windows, set to 50 send it to bottom
    padding = "",                   -- character to pad on left and right of signature can be ' ', or '|'  etc
    toggle_key = "<M-x>",           -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
    select_signature_key = "<M-n>", -- cycle to next signature, e.g. '<M-n>' function overloading
}
-- require("lsp_signature").setup(signature_config)
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
    if client:supports_method("inlayHintProvider") then
        vim.lsp.inlay_hint.enable(true)
    end
    -- used to use tree-sitter-refactor for highlighting definitions under cursor
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
        vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Document Highlight",
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Clear All the References",
        })
    end
end

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

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
nvim_lsp.ls_emmet.setup({})
nvim_lsp.cssls.setup({})
nvim_lsp.jsonls.setup({})
nvim_lsp.biome.setup({}) -- instead of rome (unmaintained)
nvim_lsp.eslint.setup({})
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
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT'
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        })
    end,
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

-- nvim_lsp.kotlin_language_server.setup({})

-- Python => PyLs
-- nvim_lsp.pylsp.setup({})
-- nvim_lsp.pyright.setup({})
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
        null_ls.builtins.diagnostics.buf,    -- protocol buffer
        null_ls.builtins.formatting.buf,

        -- Lua
        null_ls.builtins.formatting.stylua,

        --Markdown
        -- null_ls.builtins.formatting.cbfmt, -- FeMaco to edit/format codeblocks on separate buffer suffices.
        null_ls.builtins.diagnostics.markdownlint, --.with({ args = { "--stdin", "-c", "~/.markdownlint.yml" } }),
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
        null_ls.builtins.diagnostics.codespell,
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

-- nvim_lsp.rust_analyzer.setup({})

require("roslyn").setup({
    -- dotnet_cmd = "dotnet",           -- this is the dfault
    -- roslyn_version = "4.8.0-3.23475.7", -- this is the default
    -- exe = { "roslyn-language-server" },
    -- broad_search = true,
    -- filetypes = { "cs" },
    config = {
        -- on_attach = function(client, bufnr)
        --     monkey_patch_semantic_tokens(client)
        --     on_attach(client, bufnr)
        -- end,                         -- required
        -- on_attach = monkey_patch_semantic_tokens,
        cmd = {
            "dotnet",
            "/home/can/LSP/roslyn/content/LanguageServer/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll",
            "--logLevel=Debug", "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
            "--stdio"
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
                dotnet_analyzer_diagnostics_scope = 'fullSolution',
                dotnet_compiler_diagnostics_scope = 'fullSolution',
            },
        },
    },
})

-- nvim_lsp.razor.setup({
-- 	cmd = { "rzls" },
-- })

-- local util = require 'lspconfig.util'
nvim_lsp.gdscript.setup({})
nvim_lsp.clangd.setup({}) -- ~/.clang-format has indentation settings
-- Markup
nvim_lsp.yamlls.setup({})
nvim_lsp.dockerls.setup({})
nvim_lsp.docker_compose_language_service.setup({})
-- DB
nvim_lsp.sqls.setup({ cmd = { "sqls", "-config", "~/sqls/config.yml" } })
nvim_lsp.graphql.setup({
    -- root_dir =  util.root_pattern('.graphqlrc*', '.graphql.config.*', 'graphql.config.*', '.git'),
})
-- TEXT
nvim_lsp.typos_lsp.setup({})
nvim_lsp.markdown_oxide.setup({})
nvim_lsp.marksman.setup({})
nvim_lsp.vale_ls.setup({ cmd = { "vale" } })
