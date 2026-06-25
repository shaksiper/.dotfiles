vim.loader.enable()
vim.g.mapleader = " "

--- Builds and parsers after |vim.pack| install/update (replaces vim-plug `do` hooks).
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local kind = ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end
		local name = ev.data.spec.name
		local path = ev.data.path
		if name == "LuaSnip" then
			vim.system({ "make", "install_jsregexp" }, { cwd = path }):wait()
		elseif name == "blink.cmp" then
			vim.system({ "cargo", "build", "--release" }, { cwd = path }):wait()
		elseif name == "peek.nvim" then
			vim.system({ "deno", "task", "--quiet", "build:fast" }, { cwd = path }):wait()
		elseif name == "nvim-treesitter" then
			vim.schedule(function()
				vim.cmd.packadd("nvim-treesitter")
				pcall(vim.cmd.TSUpdate)
			end)
		end
	end,
})

vim.pack.add(require("pack.plugins"), {
	-- load = true,
	-- Avoid blocking headless/CI on the interactive install prompt.
	confirm = #vim.api.nvim_list_uis() > 0,
})

require("vim._core.ui2").enable({
	enable = true,
	-- msg = {
	-- 	targets = {
	-- 		default = "msg",
	-- 		typed_cmd = "msgarea",
	-- 		wmsg = "msgarea",
	-- 		emsg = "msgarea",
	-- 		lua_error = "msgarea",
	-- 		list_cmd = "msgarea",
	-- 		lua_print = "msgarea",
	-- 		echoerr = "msgarea",
	-- 		shell_out = "msgarea",
	-- 		shell_cmd = "msgarea",
	-- 		shell_err = "msgarea",
	--
	-- 		confirm = "pager",
	-- 		rpc_error = "pager",
	-- 	},
		msg = { timeout = 4000 },
	-- 	pager = { height = 0.75 },
	-- },
})
vim.opt.guifont = "JetBrainsMono NFM:h9"
vim.opt.confirm = true
vim.opt.encoding = "utf-8"
vim.opt.spelllang = { "en_us" }
vim.opt.spell = true
vim.opt.spelloptions:append("noplainbuffer,camel")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard:append("unnamedplus")
vim.opt.errorbells = false
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.incsearch = true
vim.opt.linebreak = true
vim.opt.showbreak = "››› "
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.colorcolumn = "80"
vim.opt.pumheight = 8
vim.opt.termguicolors = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.updatetime = 500

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		pcall(vim.highlight.on_yank, { higroup = "IncSearch", timeout = 200 })
	end,
})

require("init")
require("maps")

vim.cmd.colorscheme("kanagawa")
vim.opt.background = "dark"

vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = "#56B6C2", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg = "#E5C07B", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { fg = "#98C379", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { fg = "#E06C75", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { fg = "#61AFEF", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", { fg = "#C678DD", nocombine = true })
