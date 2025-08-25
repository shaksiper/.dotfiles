vim.api.nvim_create_user_command("SSR", require("ssr").open, {range = true})
