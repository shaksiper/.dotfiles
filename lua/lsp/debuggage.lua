local dap = require("dap")
require("dap-view").setup({
    winbar = {
        controls = {
            enabled = true,
        }
    },
})
require("nvim-dap-virtual-text").setup(
    {
        display_callback = function(variable, _, _, _, options)
            if #variable.value > 40 then
                variable.value = string.sub(variable.value, 1, 40) .. "..."
            end
            if options.virt_text_pos == 'inline' then
                return ' = ' .. variable.value:gsub("%s+", " ")
            else
                return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
            end
        end,
    }
)
require("dapui").setup()
require("nvim-dap-repl-highlights").setup()
-- require("dap-go").setup()

-- Javascript
dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/Downloads/LSP/Debug/vscode-node-debug2/out/src/nodeDebug.js" },
}
dap.configurations.lua = {
    {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
    },
}
dap.adapters.nlua = function(callback, config)
    callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end
dap.configurations.javascript = {
    {
        name = "Launch",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
    },
    {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = "Attach to process",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
    },
}

-- Python
-- require("dap-python").setup("~/Downloads/LSP/Debug/venv/debugpy/bin/python")

--C#
dap.adapters.coreclr = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
}
-- TODO: implement this file search in telescope, preferably with project name recognition
-- require("dap.ext.vscode").load_launchjs(nil, { coreclr = { "cs" } })
-- dap.configurations.cs = {
-- 	{
-- 		type = "coreclr",
-- 		name = "launch - netcoredbg",
-- 		request = "launch",
-- 		program = function() -- make this a bit more automatic, maybe telecope?
-- 			-- also TODO: https://github.com/ldelossa/nvim-dap-projects
-- 			return vim.fn.input("Path to dll> ", vim.fn.getcwd() .. "/bin/Debug/", "file")
-- 			-- return require("telescope.builtin").find_files(require("telescope.themes").get_ivy({
-- 			-- 	search_dirs = { vim.fn.getcwd() .. "/bin/Debug" },
-- 			-- 	search_file = "jira-devops.dll",
-- 			-- }))
-- 		end,
-- 	},
-- }
