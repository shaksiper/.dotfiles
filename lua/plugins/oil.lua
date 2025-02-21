require("oil").setup(
    {
        columns = {
            "icon",
            "size",
            "mtime",
        },
        delete_to_trash = true,
        keymaps = {
            ["<BS>"] = { "actions.parent", mode = "n" },
        },
    }
)
