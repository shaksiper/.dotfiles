require("tsht").config.hint_keys = { "h", "j", "f", "d", "n", "v", "s", "l", "a" }
--require("orgmode").setup_ts_grammar()
require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	autotag = {
		enable = true,
		filetypes = { "html", "xml", "php", "javascript" },
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<leader>v",
			node_incremental = "v",
			node_decremental = "V",
			scope_incremental = "<tab>",
		},
	},
	indent = {
		enable = true,
	},
	refactor = {
		navigation = {
			enable = true,
			keymaps = {
				-- list_definitions = "gld",
				-- list_definitions_toc = "go",
				goto_next_usage = "<leader>*",
				goto_previous_usage = "<leader>#",
			},
		},
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "grr",
			},
		},
		-- highlight_current_scope = { enable = true },
		-- highlight_definitions = { enable = true }, -- highlight the word under cursor
	},
	textobjects = {
		select = {
			enable = true,
			include_surrounding_whitespace = true,
			-- automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- you can use the capture groups defined in textobjects.scm
				["ae"] = { query = "@parameter.outer", desc = "Select around parameter" },
				["ie"] = { query = "@parameter.inner", desc = "Select inside parameter" },
				["af"] = { query = "@function.outer", desc = "Select around function" },
				["if"] = { query = "@function.inner", desc = "Select inside function" },
				["ac"] = { query = "@class.outer", desc = "Select around class" },
				["ic"] = { query = "@class.inner", desc = "Select inside class" },

				["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
				["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
				["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
				["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = { query = "@parameter.inner", desc = "Swap parameter with the next" },
			},
			swap_previous = {
				["<leader>A"] = { query = "@parameter.inner", desc = "Swap parameter with the previous" },
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = { query = "@function.outer", desc = "Move to next func. start" },
				["]e"] = { query = "@parameter.inner", desc = "Move to next param. start" },
				["]s"] = { query = "@statement.outer", desc = "Move to next state. start" },
				["]]"] = { query = "@class.outer", desc = "Move to next class start" },
			},
			goto_next_end = {
				["]M"] = { query = "@function.outer", desc = "Move to next func. end" },
				["]E"] = { query = "@parameter.inner", desc = "Move to next param. end" },
				["]S"] = { query = "@statement.outer", desc = "Move to next state. end" },
				["]["] = { query = "@class.outer", desc = "Move to next class end" },
			},
			goto_previous_start = {
				["[m"] = { query = "@function.outer", desc = "Move to prev. func. start" },
				["[e"] = { query = "@parameter.inner", desc = "Move to prev. param. start" },
				["[s"] = { query = "@statement.outer", desc = "Move to prev. state. start" },
				["[["] = { query = "@class.outer", desc = "Move to prev. class start" },
			},
			goto_previous_end = {
				["[M"] = { query = "@function.outer", desc = "Move to prev. func. end" },
				["[E"] = { query = "@parameter.inner", desc = "Move to prev. param. end" },
				["[S"] = { query = "@statement.outer", desc = "Move to prev. state. end" },
				["[]"] = { query = "@class.outer", desc = "Move to prev. class end" },
			},
		},
		lsp_interop = {
			enable = false,
			border = "single",
			peek_definition_code = {
				["<leader>df"] = { query = "@function.outer", desc = "Peek definition of function" },
				["<leader>dp"] = { query = "@class.outer", desc = "Peek definition of class" },
			},
		},
	},
	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "i",
			focus_language = "f",
			unfocus_language = "f",
			update = "r",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "bufwrite", "cursorhold" },
	},
})
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
-- example: make gitsigns.nvim movement repeatable with ; and , keys.
local gs = require("gitsigns")

-- make sure forward function comes first
local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
-- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.

vim.keymap.set({ "n", "x", "o" }, "]h", next_hunk_repeat, { desc = "Next hunk" })
vim.keymap.set({ "n", "x", "o" }, "[h", prev_hunk_repeat, { desc = "Previous hunk" })

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
