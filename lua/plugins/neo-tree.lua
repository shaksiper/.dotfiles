require("neo-tree").setup({
	close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	default_component_configs = {
		indent = {
			indent_size = 2,
			padding = 1, -- extra padding on left hand side
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
			highlight = "NeoTreeIndentMarker",
		},
		icon = {
			folder_closed = "",
			folder_open = "",
			folder_empty = "ﰊ",
			default = "*",
		},
		name = {
			trailing_slash = true,
			use_git_status_colors = true,
		},
		git_status = {
			highlight = "NeoTreeDimText", -- if you remove this the status will be colorful
		},
	},
	filesystem = {
		-- filters = { --These filters are applied to both browsing and searching
		-- 	show_hidden = false,
		-- 	respect_gitignore = true,
		-- },
		follow_current_file = true, -- This will find and focus the file in the active buffer every
		-- time the current file is changed while the tree is open.
		use_libuv_file_watcher = false, -- This will use the OS level file watchers
		-- to detect changes instead of relying on nvim autocmd events.
		hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
		-- in whatever position is specified in window.position
		-- "open_split",  -- netrw disabled, opening a directory opens within the
		-- window like netrw would, regardless of window.position
		-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
		window = {
			position = "left",
			width = 40,
		},
	},
	buffers = {
		show_unloaded = true,
		window = {
			position = "left",
		},
	},
	git_status = {
		window = {
			position = "float",
		},
	},
})
