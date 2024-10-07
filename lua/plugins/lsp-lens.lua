require("lsp-lens").setup({
    enable = true,
    include_declaration = false, -- Reference include declaration
    sections = {
        definition = true,
        references = true,
        implementation = true,
    },
})
