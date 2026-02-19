local M = {}
--- Opens `paths` with the system default handler (macOS `open`, Windows `explorer.exe`, Linux
--- `xdg-open`, …), or returns (but does not show) an error message on failure.
---
--- Can also be invoked with `:Open`. [:Open]()
---
--- Expands "~/" and environment variables in filesystem paths.
---
--- Examples:
---
--- ```lua
--- -- Asynchronous.
--- vim.ui.multi_open({"https://neovim.io/", "http://github.com"})
--- vim.ui.open({"~/path/to/file", "~/path/to/another/file"})
--- -- Use the "osurl" command to handle the path or URL.
--- vim.ui.open({"gh#neovim/neovim!29490", "gh#neovim/neovim!29490"}, { cmd = { 'osurl' } })
--- -- Synchronous (wait until the process exits).
--- local cmd, err = vim.ui.open("$VIMRUNTIME")
--- if cmd then
---   cmd:wait()
--- end
--- ```
---
---@param paths string[] Path or URL to open
---@param opt? vim.ui.open.Opts Options
---
---@return vim.SystemObj|nil # Command object, or nil if not found.
---@return nil|string # Error message on failure, or nil on success.
---
---@see vim.system |vim.system()|
function M.multi_open(paths, opt)
	vim.validate("paths", paths, "table")
	vim.iter(paths):map(function(path)
		local is_uri = path:match("%w+:")
		if not is_uri then
			path = vim.fs.normalize(path)
		end
	end)

	opt = opt or {}
	local cmd ---@type string[]
	local job_opt = { text = true, detach = true } --- @type vim.SystemOpts

	if opt.cmd then
		cmd = vim.list_extend(opt.cmd --[[@as string[] ]], paths)
	else
		local open_cmd, err = vim.ui._get_open_cmd()
		if err then
			return nil, err
		end
		---@cast open_cmd string[]
		if open_cmd[1] == "xdg-open" then
			job_opt.stdout = false
			job_opt.stderr = false
		end
		cmd = vim.list_extend(open_cmd, paths)
	end
	return vim.system(cmd, job_opt), nil
end

return M
