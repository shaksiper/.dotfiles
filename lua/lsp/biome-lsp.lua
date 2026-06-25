local lsp_util = require("lspconfig.util")
vim.lsp.config("biomejson", {
	cmd = function(dispatchers, config)
		local cmd = "biome"
		local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/biome"
		if local_cmd and vim.fn.executable(local_cmd) == 1 then
			cmd = local_cmd
		end
		return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers)
	end,
	filetypes = { "json" },
	root_dir = function(bufnr, on_dir)
		-- The project root is where the LSP can be started from
		-- As stated in the documentation above, this LSP supports monorepos and simple projects.
		-- We select then from the project root, which is identified by the presence of a package
		-- manager lock file.
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		-- Give the root markers equal priority by wrapping them in a table
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
			or vim.list_extend(root_markers, { ".git" })

		-- exclude deno
		if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
			return
		end

		-- We fallback to the current working directory if no project root is found
		local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

		local biome_global_config = os.getenv("BIOME_CONFIG_PATH")
		if biome_global_config ~= nil and biome_global_config ~= "" then
			on_dir(project_root)
			return
		end

		on_dir(project_root)
	end,
})
vim.lsp.enable("biomejson")
vim.lsp.enable("biome")
