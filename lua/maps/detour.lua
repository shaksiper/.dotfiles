vim.keymap.set("n", "<leader>T", function()
    local terminal_buffer_found = false
    -- Check if we there are any existing terminal buffers.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do -- iterate through all buffers
        if vim.api.nvim_buf_is_loaded(buf) then    -- only check loaded buffers
            if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal" then
                terminal_buffer_found = true
            end
        end
    end

    require("detour").Detour()                -- Open a detour popup
    if terminal_buffer_found then
        require("telescope.builtin").buffers({}) -- Open telescope prompt
        vim.api.nvim_feedkeys("term://", "n", true) -- populate prompt with "term://"
    else
        -- [OPTIONAL] Set the new window's current working directory to the directory of current file.
        -- You can remove this line if you would prefer to open terminals from the
        -- existing working directory.
        -- vim.cmd.lcd(vim.fn.expand("%:p:h"))
        -- Since there are no existing terminal buffers, open a new one.
        vim.cmd.terminal()
        vim.keymap.set("t", "<C-Space>", "<C-\\><C-n>", { buffer = true })
        vim.cmd.startinsert()
    end
end, { desc = "Open a floating terminal" })
vim.keymap.set("n", "<c-w><enter>", ":Detour<cr>")
