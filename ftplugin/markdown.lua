vim.opt_local.conceallevel = 2
vim.diagnostic.enable(false, { bufnr = 0 }) -- if no bufnr, it will disable for the whole session
-- this breaks hyperlinks and conceal
-- vim.opt_local.formatoptions:append("a") -- auto-format markdown files in insert mode (Ex: wrap the paragraph)
