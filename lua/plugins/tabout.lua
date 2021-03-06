require("tabout").setup({
	tabkey = "<C-K>",
	backwards_tabkey = "<C-B>",
	act_as_tab = false, -- shift content if tab out is not possible
	act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
	enable_backwards = true, -- well ...
	completion = false, -- if the tabkey is used in a completion pum
	ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
	exclude = {}, -- tabout will ignore these filetypes
})
