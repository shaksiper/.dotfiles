local Hydra = require("hydra")
local splits = require("smart-splits")

local function cmd(command)
	return table.concat({ "<Cmd>", command, "<CR>" })
end

Hydra({
	name = "WINDOWS",
	hint = [[
 ^^^^^^     Move     ^^^^^^   ^^    Size   ^^   ^^     Split
 ^^^^^^--------------^^^^^^   ^^-----------^^   ^^---------------
 ^ ^ _k_ ^ ^   ^ ^ _K_ ^ ^    ^   _<C-k>_   ^   _s_: horizontally
 _h_ ^ ^ _l_   _H_ ^ ^ _L_    _<C-h>_ _<C-l>_   _v_: vertically
 ^ ^ _j_ ^ ^   ^ ^ _J_ ^ ^    ^   _<C-j>_   ^   _q_: close
 focus^^^^^^   window^^^^^^   ^ _=_ equalize^   _b_: choose buffer 
]],
	config = {
		timeout = 4000,
		hint = {
			border = "rounded",
			-- position = "bottom",
		},
        invoke_on_body = true,
	},
	mode = "n",
	body = " ww", -- <leader> won't work for some reason
	heads = {
		{ "h", "<C-w>h" },
		{ "j", "<C-w>j" },
		{ "k", cmd([[try | wincmd k | catch /^Vim\%((\a\+)\)\=:E11:/ | close | endtry]]) },
		{ "l", "<C-w>l" },

		{ "H", cmd("WinShift left") },
		{ "J", cmd("WinShift down") },
		{ "K", cmd("WinShift up") },
		{ "L", cmd("WinShift right") },

		{
			"<C-h>",
			function()
				splits.resize_left(2)
			end,
		},
		{
			"<C-j>",
			function()
				splits.resize_down(2)
			end,
		},
		{
			"<C-k>",
			function()
				splits.resize_up(2)
			end,
		},
		{
			"<C-l>",
			function()
				splits.resize_right(2)
			end,
		},
		{ "=", "<C-w>=", { desc = "equalize" } },

		{ "s", "<C-w>s" },
		{ "v", "<C-w>v" },
		{ "b", cmd("BufferLinePick"), { exit = true, desc = "choose buffer" } },
		-- { "g", require("nvim-window").pick, { exit = true, desc = "pick page" } },
		{
			"g",
			function()
				vim.api.nvim_set_current_win(require("window-picker").pick_window({
					include_current_win = true,
				}))
			end,
			{ exit = true, desc = "pick page" },
		},
		{ "q", cmd([[try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry]]) },
		{ "<Esc>", nil, { exit = true, desc = false } },
	},
})
