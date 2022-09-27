require("mkdnflow").setup({
	modules = {
		bib = true,
		buffers = true,
		conceal = true,
		cursor = true,
		folds = true,
		links = true,
		lists = true,
		maps = true,
		paths = true,
		tables = true,
	},
	filetypes = { md = true, rmd = true, markdown = true },
	create_dirs = true,
	perspective = {
		priority = "first",
		fallback = "current",
		root_tell = false,
		nvim_wd_heel = true,
	},
	wrap = false,
	bib = {
		default_path = nil,
		find_in_root = true,
	},
	silent = false,
	links = {
		style = "markdown",
		conceal = false,
		implicit_extension = nil,
		transform_implicit = false,
		transform_explicit = function(text)
			text = text:gsub(" ", "-")
			text = text:lower()
			text = os.date("%Y-%m-%d_") .. text
			return text
		end,
	},
	to_do = {
		symbols = { " ", "", "" },
		update_parents = true,
		not_started = " ",
		in_progress = "-",
		complete = "X",
	},
	tables = {
		trim_whitespace = true,
		format_on_move = true,
	},
	mappings = {
		MkdnEnter = { { "n", "v" }, "<CR>" },
		MkdnTab = false,
		MkdnSTab = false,
		MkdnNextLink = { "n", "<Tab>" },
		MkdnPrevLink = { "n", "<S-Tab>" },
		MkdnNextHeading = { "n", "]]" },
		MkdnPrevHeading = { "n", "[[" },
		MkdnGoBack = { "n", "<BS>" },
		MkdnGoForward = { "n", "<Del>" },
		MkdnFollowLink = false, -- see MkdnEnter
		MkdnDestroyLink = { "n", "<M-CR>" },
		MkdnMoveSource = { "n", "<F2>" },
		MkdnYankAnchorLink = { "n", "ya" },
		MkdnYankFileAnchorLink = { "n", "yfa" },
		MkdnIncreaseHeading = { "n", "+" },
		MkdnDecreaseHeading = { "n", "-" },
		MkdnToggleToDo = { { "n", "v" }, "<C-Space>" },
		MkdnNewListItem = false,
		MkdnExtendList = false,
		MkdnUpdateNumbering = { "n", "<leader>nn" },
		MkdnTableNextCell = { "i", "<Tab>" },
		MkdnTablePrevCell = { "i", "<S-Tab>" },
		MkdnTableNextRow = false,
		MkdnTablePrevRow = { "i", "<M-CR>" },
		MkdnTableNewRowBelow = { { "n", "i" }, "<leader>ir" },
		MkdnTableNewRowAbove = { { "n", "i" }, "<leader>iR" },
		MkdnTableNewColAfter = { { "n", "i" }, "<leader>ic" },
		MkdnTableNewColBefore = { { "n", "i" }, "<leader>iC" },
		MkdnFoldSection = { "n", "<leader>f" },
		MkdnUnfoldSection = { "n", "<leader>F" },
	},
})