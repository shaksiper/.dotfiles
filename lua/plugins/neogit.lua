local graph_style = "kitty"
if vim.g.neovide then
	graph_style = "unicode"
end
require("neogit").setup({
	graph_style = graph_style,
	diff_viewer = "codediff",
    -- highlight = { -- somehow it is not fallback to default
    --     red = "red",
    --     purple = "purple"
    -- }
})
