vim.g.mapleader = " "
vim.keymap.set("i", "<C-u>", "<C-g>u<C-u>", { desc = "Delete all before cursor" })
vim.keymap.set("n", "<leader>gp", "'`[' . getregtype()[0] . '`]'", { expr = true, desc = "Paste last" })
vim.keymap.set("v", "<", "<gv", { desc = "De-indent and reselect last visual selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and reselect last visual selection" })
-- let mapleader=' '
-- " start new change before deleting an entire line
-- inoremap <c-u> <c-g>u<c-u>
-- " Some language specific mappings
-- " au FileType go imap <buffer> <M-;> :=
-- " au FileType javascript imap <buffer> <M-;> =>
-- " autocmd FileType markdown noremap <leader>p :Glow<CR>
-- " Reselect the last pastedtext
-- nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
-- " Reselect visual selection after indenting
-- vnoremap < <gv
-- vnoremap > >gv
--
-- " map <silent> <leader>ww :lua require('nvim-window').pick()<CR>
-- " nnoremap <C-t> :NeoTreeRevealToggle<CR>
-- " " -- TELESCOPE -- Find files using Telescope command-line sugar.
-- lua << EOF
-- local notifier =
vim.keymap.set(
	"x",
	"<C-s>",
	"<Plug>(nvim-surround-visual)",
	{ desc = "Add a surrounding pair around a visual selection" }
)
vim.keymap.set(
	"x",
	"gS",
	"<Plug>(nvim-surround-visual-line)",
	{ desc = "Add a surrounding pair around a visual selection, on new lines" }
)
-- TESTING
local neotest = require("neotest")
vim.keymap.set("n", "\\td", function()
	neotest.run.run({ strategy = "dap" })
end, { noremap = true, desc = "Test Debug" })
vim.keymap.set("n", "\\tl", function()
	neotest.run.run_last()
end, { noremap = true, desc = "Run Last Test" })
vim.keymap.set("n", "\\tt", function()
	neotest.run.run(vim.fn.expand("%"))
end, { noremap = true, desc = "Test Current Test File" })
vim.keymap.set("n", "\\ts", function()
	neotest.run.stop()
end, { noremap = true, desc = "Stop Test" })
vim.keymap.set("n", "\\T", function()
	neotest.run.run()
end, { noremap = true, desc = "Test Nearest" })
vim.keymap.set("n", "\\to", "<CMD>NeotestRunHistoryToggle<CR>", { noremap = true, desc = "Test Run History Output" })
-- vim.keymap.set("n", "\\to", function()
-- 	neotest.output.toggle({ enter = false })
-- end, { noremap = true, desc = "Test Output" })
vim.keymap.set("n", "\\tO", function()
	neotest.output_panel.toggle({ enter = true })
end, { noremap = true, desc = "Test Output Panel" })
vim.keymap.set("n", "<M-t>", function()
	neotest.summary.toggle()
end, { noremap = true, desc = "Toggle Test Summary" })
vim.keymap.set("n", "\\tm", function()
	neotest.summary.run_marked()
end, { noremap = true, desc = "Run Marked Tests" })
vim.keymap.set("n", "\\tM", function()
	neotest.summary.debug_marked()
end, { noremap = true, desc = "Debug Marked Tests" })
vim.keymap.set("n", "\\taa", function()
	neotest.run.run({ suite = true })
end, { noremap = true, desc = "Run All Test Suite" })
vim.keymap.set("n", "\\tad", function()
	neotest.run.run({ suite = true, strategy = "dap" })
end, { noremap = true, desc = "Run All Test Suite" })

local default_opts = { noremap = true }
-- SNACKS
local Snacks = require("snacks")
Snacks.toggle.profiler():map("<leader>pp")
Snacks.toggle.profiler_highlights():map("<leader>ph")
vim.keymap.set("n", "<leader>ps", function()
	Snacks.profiler.scratch()
end, { desc = "Profiler Scratch Buffer" })
vim.keymap.set("n", "<leader><space>", function()
	Snacks.picker.smart()
end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>,", function()
	Snacks.picker.buffers({
		on_show = function(picker)
			picker.list:view(2)
		end,
	})
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>/", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set("n", "<leader>:", function()
	Snacks.picker.command_history()
end, { desc = "Command History" })
vim.keymap.set("n", "<leader>n", function()
	Snacks.picker.notifications()
end, { desc = "Notification History" })
vim.keymap.set("n", "<leader>fe", function()
	Snacks.explorer()
end, { desc = "File Explorer" })
-- SNACK FIND
-- vim.keymap.set( "n", "<leader>fb", function() Snacks.picker.buffers() end, {desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function()
	Snacks.picker.git_files()
end, { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>fp", function()
	Snacks.picker.projects()
end, { desc = "Projects" })
vim.keymap.set("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent" })

-- SNACK GIT
vim.keymap.set("n", "<leader>gb", function()
	Snacks.picker.git_branches()
end, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gl", function()
	Snacks.picker.git_log()
end, { desc = "Git Log" })
vim.keymap.set("n", "<leader>gL", function()
	Snacks.picker.git_log_line()
end, { desc = "Git Log Line" })
vim.keymap.set("n", "<leader>gs", function()
	Snacks.picker.git_status()
end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gS", function()
	Snacks.picker.git_stash()
end, { desc = "Git Stash" })
vim.keymap.set("n", "<leader>gd", function()
	Snacks.picker.git_diff()
end, { desc = "Git Diff (Hunks)" })
vim.keymap.set("n", "<leader>gf", function()
	Snacks.picker.git_log_file()
end, { desc = "Git Log File" })
-- Grep
vim.keymap.set("n", "<leader>sb", function()
	Snacks.picker.lines()
end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sB", function()
	Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
vim.keymap.set("n", "<leader>sg", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function()
	Snacks.picker.grep_word()
end, { desc = "Visual selection or word" })
-- search
-- vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, {desc = "Registers" })
vim.keymap.set("n", "<leader>s/", function()
	Snacks.picker.search_history()
end, { desc = "Search History" })
vim.keymap.set("n", "<leader>sa", function()
	Snacks.picker.autocmds()
end, { desc = "Autocmds" })
vim.keymap.set("n", "<leader>sb", function()
	Snacks.picker.lines()
end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sc", function()
	Snacks.picker.command_history()
end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", function()
	Snacks.picker.commands()
end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sD", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sh", function()
	Snacks.picker.help()
end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", function()
	Snacks.picker.highlights()
end, { desc = "Highlights" })
vim.keymap.set("n", "<leader>si", function()
	Snacks.picker.icons()
end, { desc = "Icons" })
vim.keymap.set("n", "<leader>sj", function()
	Snacks.picker.jumps()
end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", function()
	Snacks.picker.keymaps()
end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl", function()
	Snacks.picker.loclist()
end, { desc = "Location List" })
vim.keymap.set("n", "<leader>sm", function()
	Snacks.picker.marks()
end, { desc = "Marks" })
vim.keymap.set("n", "<leader>sM", function()
	Snacks.picker.man()
end, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sp", function()
	Snacks.picker.lazy()
end, { desc = "Search for Plugin Spec" })
vim.keymap.set("n", "<leader>sq", function()
	Snacks.picker.qflist()
end, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>sR", function()
	Snacks.picker.resume()
end, { desc = "Resume" })
vim.keymap.set("n", "<leader>su", function()
	Snacks.picker.undo()
end, { desc = "Undo History" })
vim.keymap.set("n", "<leader>uC", function()
	Snacks.picker.colorschemes()
end, { desc = "Colorschemes" })
-- LSP
vim.keymap.set("n", "gd", function()
	Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function()
	Snacks.picker.lsp_declarations()
end, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function()
	Snacks.picker.lsp_references()
end, { desc = "References", nowait = true })
vim.keymap.set("n", "gI", function()
	Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", function()
	Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "gai", function()
	Snacks.picker.lsp_incoming_calls()
end, { desc = "C[a]lls Incoming" })
vim.keymap.set("n", "gao", function()
	Snacks.picker.lsp_outgoing_calls()
end, { desc = "C[a]lls Outgoing" })
vim.keymap.set("n", "<leader>ss", function()
	Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>sS", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })
vim.keymap.set({ "n", "t" }, "<M-/>", function()
	Snacks.terminal()
end, { desc = "Toggle Terminal" })

vim.keymap.set("n", "<leader>fa", "<cmd>Seeker files<CR>", { desc = "Seeker files" })
-- TELESCOPE
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>F",
-- 	"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git'}, file_ignore_patterns = { 'node%_modules/.*' }})<cr>",
-- 	default_opts
-- )
-- vim.keymap.set(
-- 	"n",
-- 	"<leader><TAB>",
-- 	"<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>",
-- 	default_opts
-- )
-- vim.keymap.set("n", "<leader>fsp", "<cmd>Telescope spell_suggest theme=cursor<cr>", default_opts)
-- vim.keymap.set("n", "<leader>fk", "<cmd>lua require'telescope.builtin'.keymaps()<cr>", default_opts)
-- vim.keymap.set("n", "<leader>fo", "<cmd>lua require'telescope.builtin'.oldfiles()<cr>", default_opts)
-- vim.keymap.set("n", "<leader>fh", "<cmd>lua require'telescope.builtin'.help_tags()<cr>", default_opts)
-- vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<CR>", default_opts)
-- vim.keymap.set("n", "<leader>fgr", "<cmd>lua require'telescope.builtin'.live_grep()<cr>", { desc = "Live Grep" })
-- vim.keymap.set(
-- 	"n",
-- 	"<leader><leader>",
-- 	"<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>",
-- 	default_opts
-- )
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>fe",
-- 	"<cmd>lua require 'telescope'.extensions.file_browser.file_browser({path='%:p:h',select_buffer=true})<CR>",
-- 	default_opts
-- )
-- Telescope Git actions
-- vim.keymap.set("n", "<leader>fgf", "<cmd>lua require'telescope.builtin'.git_files()<cr>", { desc = "Git Files" })
-- vim.keymap.set("n", "<leader>fgc", "<cmd>lua require'telescope.builtin'.git_commits()<cr>", { desc = "Git Commits" })
-- vim.keymap.set("n", "<leader>fgb", "<cmd>lua require'telescope.builtin'.git_branches()<cr>", { desc = "Git Branches" })
-- vim.keymap.set("n", "<leader>fgs", "<cmd>lua require'telescope.builtin'.git_status()<cr>", { desc = "Git Status" })
vim.keymap.set("n", "<M-g>", "<cmd>Neogit<cr>", { desc = "Neogit" })
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>fz",
-- 	"<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find({preview = {hide_on_startup = true, title = 'Fuzzy Find Buffer'}, layout_config={width=0.65}})<cr>",
-- 	default_opts
-- )
-- vim.keymap.set("n", "<leader>fj", "<cmd>lua require'telescope.builtin'.jumplist()<cr>", default_opts)
-- vim.keymap.set('v', '<leader>fc', "<cmd>Telescope lsp_range_code_actions<cr>", default_opts)
-- vim.keymap.set("n", "<leader>fm", "<cmd>lua require'telescope.builtin'.marks()<cr>", default_opts)
-- vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects theme=dropdown<cr>", default_opts)
-- vim.keymap.set("n", "<leader>fl", "<cmd>Telescope resume<cr>", default_opts)
-- vim.keymap.set("n", "<leader>fdb", "<cmd>Telescope dap commands theme=dropdown<cr>", default_opts)
--LSP

local opts = { noremap = true, silent = true }
-- vim.keymap.set("n", "<leader>fsw", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)
-- vim.keymap.set("n", "<leader>fsd", function()
-- 	require("telescope.builtin").lsp_document_symbols(require("telescope.themes").get_ivy({}))
-- end, opts)
-- vim.keymap.set("n", "<leader>fdd", "<cmd>Telescope diagnostics bufnr=0<cr>", opts)
-- vim.keymap.set("n", "<leader>fwd", "<cmd>Telescope diagnostics<cr>", opts)
-- -- vim.keymap.set("n", "<leader>fso", "<cmd>Telescope lsp_workspace_symbols<cr>", opts)
-- vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
-- vim.keymap.set("n", "<leader>gdd", "<cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
-- vim.keymap.set("n", "<leader>gdf", "<cmd>DetourCurrentWindow<CR><cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
-- vim.keymap.set("n", "<leader>gds", "<C-w>s<cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
-- vim.keymap.set("n", "<leader>gdv", "<C-w>v<cmd>Telescope lsp_definitions theme=ivy<CR>", opts)
-- vim.keymap.set("n", "<leader>gtd", "<Cmd>Telescope lsp_type_definitions theme=ivy<CR>", opts)
-- vim.keymap.set("n", "<leader>g>", "<Cmd>Telescope lsp_outgoing_calls theme=ivy<CR>", opts)
-- vim.keymap.set("n", "<leader>g<", "<Cmd>Telescope lsp_incoming_calls theme=ivy<CR>", opts)

vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({ border = "rounded" })
end, opts)
-- vim.keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations theme=ivy<CR>", opts)
vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, opts)
vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
-- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

-- vim.keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references theme=ivy<CR>", opts)
vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
-- vim.keymap.set("v", "<leader>ca", ":Telescope range_code_action<CR>", opts)

-- vim.keymap.set("n", "<leader>cla", "V:<C-U>Lspsaga range_code_action<CR>", opts) -- Code line action
-- vim.keymap.set("n", "gh", "<cmd>Lspsaga finder<CR>", opts)
-- vim.keymap.set("n", "<leader>gdp", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
-- vim.keymap.set("n", "<leader>gdP", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek type definition" })
-- Only jump to error
-- vim.keymap.set("n", "[D", function()
--     require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true })
-- vim.keymap.set("n", "]D", function()
--     require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true })
vim.keymap.set("n", "]D", function()
	vim.diagnostic.jump({ count = 1, severity = "ERROR", float = true })
end, { desc = "Jump to next ERROR" })
vim.keymap.set("n", "[D", function()
	vim.diagnostic.jump({ count = -1, severity = "ERROR", float = true })
end, { desc = "Jump to previous ERROR" })
local conform = require("conform")
vim.keymap.set({ "n", "v" }, "<leader>gf", function()
	conform.format({ async = true })
end, opts)
-- vim.keymap.set("v", "<leader>gf", conform.format({ async = true }), opts)
-- vim.keymap.set("n", "<leader>glf", "V<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts) -- Code line formatting, for whatever it's worth.
vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float({ border = "rounded" })
end, opts)
vim.keymap.set("n", "<leader>ce", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
-- vim .keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
-- vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
vim.keymap.set("n", "<leader>q", function()
	require("quicker").toggle()
end, { desc = "Toggle quickfix" })
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

-- DAP
local dap = require("dap")
vim.keymap.set("n", "<F5>", function()
	dap.continue()
end, { desc = "DAP Continue" })
vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end, { desc = "DAP Step Over" })
vim.keymap.set("n", "<M-Right>", function()
	dap.step_over()
end, { desc = "DAP Step Over" })
vim.keymap.set("n", "<F11>", function()
	dap.step_into()
end, { desc = "DAP Step Into" })
vim.keymap.set("n", "<M-Down>", function()
	dap.step_into()
end, { desc = "DAP Step Into" })
vim.keymap.set("n", "<F12>", function()
	dap.step_out()
end, { desc = "DAP Step Out" })
vim.keymap.set("n", "<M-Up>", function()
	dap.step_out()
end, { desc = "DAP Step Out" })
vim.keymap.set("n", "\\db", function()
	dap.toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "\\dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP Conditional Breakpoint" })
vim.keymap.set("n", "\\dlp", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "DAP Log Breakpoint" })
vim.keymap.set("n", "\\dr", function()
	require("dap-view").show_view("repl")
end, { desc = "DAP REPL" })
vim.keymap.set("n", "\\dW", function()
	require("dap-view").show_view("watches")
end, { desc = "DAP REPL" })
vim.keymap.set("n", "\\dw", function()
	require("dap-view").add_expr()
end, { desc = "DAP Add expr" })
vim.keymap.set("n", "\\dt", function()
	require("dap-view").toggle(true)
end, { desc = "DAP Toggle UI" })
vim.keymap.set("n", "\\dl", function()
	dap.run_last()
end, { desc = "DAP Run Last" })
vim.keymap.set("n", "\\dT", function()
	dap.terminate()
end, { desc = "DAP Terminate" })
vim.keymap.set({ "n", "v" }, "\\dh", function()
	require("dap.ui.widgets").hover()
end)

local dapwidgets = require("dap.ui.widgets")
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
	dapwidgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
	dapwidgets.centered_float(widgets.scopes)
end)

vim.keymap.set("n", "\\dl", function()
	require("osv").launch({ port = 8086 })
end, { noremap = true })

vim.keymap.set("n", "<leader>ot", "<CMD>ObsidianToday<CR>", { desc = "Obsidian Today" })
vim.keymap.set("n", "<C-w>gt", "<CMD>tab split<CR>", { desc = "Open current buffer in new tab" })

-- require("maps.detour")
-- require("maps.hydras")

-- LEAP
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
vim.keymap.set({ "n", "o" }, "<leader>gs", function()
	require("leap.remote").action()
end, { desc = "Leap remote action" })
vim.keymap.set({ "n", "x", "o" }, "R", function()
	require("leap.treesitter").select({
		opts = require("leap.user").with_traversal_keys("R", "r"),
	})
end, { desc = "Leap AST" })
vim.keymap.set("n", "gs", "<Plug>(leap-from-window)", { desc = "Leap somewhere else" })
vim.keymap.set(
	"n",
	"<leader>ss",
	"<Plug>(leap-anywhere)",
	{ desc = "Leap anywhere" }
	-- function()
	-- 	require("leap").leap({
	-- 		target_windows = vim.tbl_filter(function(win)
	-- 			return vim.api.nvim_win_get_config(win).focusable
	-- 		end, vim.api.nvim_tabpage_list_wins(0)),
	-- 	})
	-- end
)
-- local map = vim.keymap.set

vim.keymap.set("n", "\\<TAB>", function()
	require("snipe").open_buffer_menu()
end, { desc = "Snipe Buffers" })
-- FAILED REMAP FOR ORGMODE
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "org",
--     callback = function() vim.keymap.set('i', '<C-CR>', '<ESC><leader><CR>i', default_opts) end,-- Or myvimfun
--     })

-- TODO make mappings with newly added vim.keymap
-- See : htt,ps://github.com/neovim/neovim/pull/16591
-- map('n', '<leader>fs', ":SearchSession<cr>", default_opts)
vim.keymap.set(
	"n",
	"<leader>th",
	"<cmd>lua require'close_buffers'.delete({type = 'hidden'})<cr>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>tu",
	"<cmd>lua require'close_buffers'.delete({type = 'nameless'})<cr>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>tc",
	"<cmd>lua require'close_buffers'.delete({type = 'this'})<cr>",
	{ noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>tt", ":bd<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ts", ":OverseerRun<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>to", ":OverseerToggle bottom<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tr", ":OverseerRestartLast<cr>", { noremap = true, silent = true })
-- map('n', '<M-t>', "<cmd>lua require('rose-pine.functions').toggle_variant()<cr>", {noremap = true, silent = true})
-- Syntax Tree Surfer
-- Normal Mode Swapping
-- vim.keymap.set(
-- 	"n",
-- 	"vd",
-- 	'<cmd>lua require("syntax-tree-surfer").move("n", false)<cr>',
-- 	{ noremap = true, silent = true }
-- )
-- vim.keymap.set(
-- 	"n",
-- 	"vu",
-- 	'<cmd>lua require("syntax-tree-surfer").move("n", true)<cr>',
-- 	{ noremap = true, silent = true }
-- )
-- -- .select() will show you what you will be swapping with .move(), you'll get used to .select() and .move() behavior quite soon!
-- vim.keymap.set("n", "vx", '<cmd>lua require("syntax-tree-surfer").select()<cr>', { noremap = true, silent = true })
-- -- .select_current_node() will select the current node at your cursor
-- vim.keymap.set(
-- 	"n",
-- 	"vn",
-- 	'<cmd>lua require("syntax-tree-surfer").select_current_node()<cr>',
-- 	{ noremap = true, silent = true }
-- )
--
-- -- NAVIGATION: Only change the keymap to your liking. I would not recommend changing anything about the .surf() parameters!
-- vim.keymap.set(
-- 	"x",
-- 	"L",
-- 	'<cmd>lua require("syntax-tree-surfer").surf("next", "visual")<cr>',
-- 	{ noremap = true, silent = true }
-- )
-- vim.keymap.set(
-- 	"x",
-- 	"H",
-- 	'<cmd>lua require("syntax-tree-surfer").surf("prev", "visual")<cr>',
-- 	{ noremap = true, silent = true }
-- )
-- vim.keymap.set(
-- 	"x",
-- 	"K",
-- 	'<cmd>lua require("syntax-tree-surfer").surf("parent", "visual")<cr>',
-- 	{ noremap = true, silent = true }
-- )
-- vim.keymap.set(
-- 	"x",
-- 	"J",
-- 	'<cmd>lua require("syntax-tree-surfer").surf("child", "visual")<cr>',
-- 	{ noremap = true, silent = true }
-- )

-- local sts = require("syntax-tree-surfer")
-- vim.keymap.set("n", "<A-n>", function()
-- 	sts.filtered_jump("default", true) --> true means jump forward
-- end, opts)
-- vim.keymap.set("n", "<A-p>", function()
-- 	sts.filtered_jump("default", false) --> false means jump backwards
-- end, opts)
--
-- -- SWAPPING WITH VISUAL SELECTION: Only change the keymap to your liking. Don't change the .surf() parameters!
-- vim.keymap.set("x", "<A-J>", function()
-- 	require("syntax-tree-surfer").surf("next", "visual", true)
-- end, { noremap = true, silent = true })
-- vim.keymap.set(
-- 	"x",
-- 	"<A-K>",
-- 	'<cmd>lua require("syntax-tree-surfer").surf("prev", "visual", true)<cr>',
-- 	{ noremap = true, silent = true }
-- )

-- focus.nvim toggle thingy
-- map('n', '<m-BS>', ":lua require('focus').focus_toggle()<CR>", default_opts)
-- Outline symbols toggle
vim.keymap.set("n", "<m-o>", ":Outline<CR>", default_opts)
vim.keymap.set("n", "<m-u>", ":UndotreeToggle<CR>", default_opts)
-- Sniprun
vim.keymap.set("n", "<leader>rr", "<Plug>SnipRun", { silent = true })
vim.keymap.set("v", "<leader>rr", "<Plug>SnipRun", { silent = true })

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n><C-W>p]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>", [[<C-\><C-n><C-W>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
-- vim.keymap.set("n", "<leader>sl", require('session-lens').search_session, default_opts) -- make this a user command and free the keymapping

vim.keymap.set("n", "\\e", "<cmd>FeMaco<CR>", default_opts)

--DAP
vim.keymap.set("n", "]b", require("goto-breakpoints").next, { desc = "Next Break Point" })
vim.keymap.set("n", "[b", require("goto-breakpoints").prev, { desc = "Previous Break Point" })
vim.keymap.set("n", "]B", require("goto-breakpoints").stopped, { desc = "Stopped Break Point" })

-- vim.keymap.set("n", "<leader>n", require("nvim-navbuddy").open, { desc = "Navbuddy" })

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
vim.keymap.set("n", "<leader>fy", "<CMD>YankyRingHistory<CR>")
-- Dropbar
local dropbar_api = require("dropbar.api")
vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Select symbol from drop bar" })
vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

-- Markdown
vim.keymap.set("n", "\\mir", "<cmd>MkdnTableNewRowAbove<CR>", { desc = "Insert Row Before" })
vim.keymap.set("n", "\\mar", "<cmd>MkdnTableNewRowBelow<CR>", { desc = "Insert Row After" })
vim.keymap.set("n", "\\mic", "<cmd>MkdnTableNewColBefore<CR>", { desc = "Insert Column Before" })
vim.keymap.set("n", "\\mac", "<cmd>MkdnTableNewColAfter<CR>", { desc = "Insert Column After" })
vim.keymap.set("n", "\\mf", "<cmd>MkdnTableFormat<CR>", { desc = "Format Table" })

vim.api.nvim_create_user_command("PeekToggle", function()
	local peek = require("peek")
	if peek.is_open then
		peek.close()
	end
	peek.open()
end, {})
-- EOF
--
vim.keymap.set("v", "<leader>rp", '"_dp', { desc = "Replace without yanking" })
-- vim.keymap.set("n", "<leader>rp", 'viw"_dp')
vim.keymap.set("n", "<leader>b", "<CMD>BufferLinePick<CR>", { desc = "Pick buffer from Buffer Line" })
vim.keymap.set("n", "<leader>sw", "<CMD>ToggleAlternate<CR>", { desc = "Toggle Alternative under cursor" })

-- " mfussenegger/nvim-ts-hint-textobject TreeSitter plugin for highlighting parts of the code using syntax tree
-- " omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
-- " vnoremap <silent> m :lua require('tsht').nodes()<CR>
-- "nnoremap <M-m> :MinimapToggle<CR>
-- " Replace word without affecting buffer.
-- vnoremap <leader>rp "_dP
-- nnoremap <leader>rp viw"_dP
-- " Buffer pick
-- nnoremap <leader>bb :BufferLinePick<CR>
-- " let g:winresizer_start_key="<leader>ws"
-- nnoremap <leader>sw :ToggleAlternate<CR>
--
-- " Pounce
-- "nmap <leader><C-f> <cmd>Pounce<CR>
-- "vmap <leader><C-f> <cmd>Pounce<CR>
-- "" nmap <C-l> <cmd>PounceRepeat<CR>
-- "omap gs <cmd>Pounce<CR>  " 's' is used by vim-surround

-- Tree Sitter Textobjects
-- Select
local ts_textobjects_select = require("nvim-treesitter-textobjects.select")
vim.keymap.set({ "x", "o" }, "af", function()
	ts_textobjects_select.select_textobject("@function.outer", "textobjects")
end, { desc = "Select [a]round [f]unction" })
vim.keymap.set({ "x", "o" }, "if", function()
	ts_textobjects_select.select_textobject("@function.inner", "textobjects")
end, { desc = "Select [i]nside [f]unction" })
vim.keymap.set({ "x", "o" }, "ac", function()
	ts_textobjects_select.select_textobject("@class.outer", "textobjects")
end, { desc = "Select [a]round [c]lass" })
vim.keymap.set({ "x", "o" }, "ic", function()
	ts_textobjects_select.select_textobject("@class.inner", "textobjects")
end, { desc = "Select [i]nside [c]lass" })
vim.keymap.set({ "x", "o" }, "ar", function()
	ts_textobjects_select.select_textobject("@returns", "textobjects")
end, { desc = "Select around [r]eturn type" })
vim.keymap.set({ "x", "o" }, "ae", function()
	ts_textobjects_select.select_textobject("@parameter.outer", "textobjects")
end, { desc = "Select around parameter" })
vim.keymap.set({ "x", "o" }, "ie", function()
	ts_textobjects_select.select_textobject("@parameter.inner", "textobjects")
end, { desc = "Select inside parameter" })
vim.keymap.set({ "x", "o" }, "a=", function()
	ts_textobjects_select.select_textobject("@assignment.outer", "textobjects")
end, { desc = "Select around assignment" })
vim.keymap.set({ "x", "o" }, "i=", function()
	ts_textobjects_select.select_textobject("@assignment.inner", "textobjects")
end, { desc = "Select inside assignment" })
vim.keymap.set({ "x", "o" }, "[l", function()
	ts_textobjects_select.select_textobject("@assignment.lhs", "textobjects")
end, { desc = "Select left hand side of assignment" })
vim.keymap.set({ "x", "o" }, "]l", function()
	ts_textobjects_select.select_textobject("@assignment.rhs", "textobjects")
end, { desc = "Select right hand side of assignment" })
-- Move
-- Function
vim.keymap.set({ "n", "x", "o" }, "]f", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end, { desc = "Move to next [f]unc. start" })
vim.keymap.set({ "n", "x", "o" }, "]F", function()
	require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
end, { desc = "Move to next [f]unc. end" })
vim.keymap.set({ "n", "x", "o" }, "[f", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end, { desc = "Move to prev. [f]unc. start" })
vim.keymap.set({ "n", "x", "o" }, "[F", function()
	require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
end, { desc = "Move to prev. [f]unc. end" })
-- Parameter
vim.keymap.set({ "n", "x", "o" }, "]e", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects")
end, { desc = "Move to next parameter start" })
vim.keymap.set({ "n", "x", "o" }, "]E", function()
	require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer", "textobjects")
end, { desc = "Move to next parameter end" })
vim.keymap.set({ "n", "x", "o" }, "[e", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects")
end, { desc = "Move to prev. parameter start" })
vim.keymap.set({ "n", "x", "o" }, "[E", function()
	require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.outer", "textobjects")
end, { desc = "Move to prev. parameter end" })
--Statement
vim.keymap.set({ "n", "x", "o" }, "]s", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@statement.outer", "textobjects")
end, { desc = "Move to next [s]statement start" })
vim.keymap.set({ "n", "x", "o" }, "]S", function()
	require("nvim-treesitter-textobjects.move").goto_next_end("@statement.outer", "textobjects")
end, { desc = "Move to next [s]tatement end" })
vim.keymap.set({ "n", "x", "o" }, "[s", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@statement.outer", "textobjects")
end, { desc = "Move to prev. [s]tatement start" })
vim.keymap.set({ "n", "x", "o" }, "[S", function()
	require("nvim-treesitter-textobjects.move").goto_previous_end("@statement.outer", "textobjects")
end, { desc = "Move to prev. [s]tatement end" })
--Class
vim.keymap.set({ "n", "x", "o" }, "]]", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
end, { desc = "Move to next class start" })
vim.keymap.set({ "n", "x", "o" }, "][", function()
	require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
end, { desc = "Move to next class end" })
vim.keymap.set({ "n", "x", "o" }, "[[", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end, { desc = "Move to prev. class start" })
vim.keymap.set({ "n", "x", "o" }, "[]", function()
	require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
end, { desc = "Move to prev. class end" })
-- Swap
vim.keymap.set("n", "<leader>a", function()
	require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
end, { desc = "Swap parameter with next" })
vim.keymap.set("n", "<leader>A", function()
	require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
end, { desc = "Swap parameter with prev." })
-- TODO comment
-- vim.keymap.set("n", "]t", function()
-- 	require("todo-comments").jump_next()
-- end, { desc = "Next todo comment" })
--
-- vim.keymap.set("n", "[t", function()
-- 	require("todo-comments").jump_prev()
-- end, { desc = "Previous todo comment" })

-- movement
vim.keymap.set({ "n", "v" }, "<M-k>", "<cmd>Treewalker Up<cr>", { silent = true, desc = "Move up the tree" })
vim.keymap.set({ "n", "v" }, "<M-j>", "<cmd>Treewalker Down<cr>", { silent = true, desc = "Move down the tree" })
vim.keymap.set(
	{ "n", "v" },
	"<M-h>",
	"<cmd>Treewalker Left<cr>",
	{ silent = true, desc = "Move left through the tree" }
)
vim.keymap.set(
	{ "n", "v" },
	"<M-l>",
	"<cmd>Treewalker Right<cr>",
	{ silent = true, desc = "Move rigtht through the tree" }
)

vim.keymap.set("n", "<leader>fo", "<CMD>Oil --float<CR>", {desc = "Open Oil in float"})
