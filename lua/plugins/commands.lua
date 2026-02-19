vim.api.nvim_create_user_command("SSR", require("ssr").open, { range = true })
vim.api.nvim_create_user_command("W", "write %", {})
