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
        preview_win = {
            -- Whether the preview window is automatically updated when the cursor is moved
            update_on_cursor_moved = false,
            -- How to open the preview window "load"|"scratch"|"fast_scratch"
        },
    }
)
