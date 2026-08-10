local Snacks = require("snacks")
local helpers = require("plugins.snacks-helpers")
require("plugins.snacks-smart-path").setup(Snacks)

vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(event)
		if event.data.actions.type == "move" then
			Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
		end
	end,
})

local function multi_open(is_new_window)
	local cmd = { "zed" }
	if is_new_window == true then
		table.insert(cmd, "-n")
	end
	return function(picker)
		if vim.fn.mode():find("^[vV]") then
			picker.list:select()
		end
		local files = {}
		for _, item in ipairs(picker:selected({ fallback = true })) do
			table.insert(files, item.file)
		end
		print(vim.inspect(files))
		local _, err = helpers.multi_open(files, { cmd = cmd })
		if err then
			Snacks.notify.error("Failed to open `" .. files .. "`:\n- " .. err)
		end
		picker:close()
		-- picker.list:set_selected() -- clear selection
	end
end

Snacks.picker.pick_list = helpers.pick_list

Snacks.setup({
	bigfile = { enabled = true },
	terminal = {
		enabled = true,
		bo = {
			filetype = "snacks_terminal",
		},
		wo = {},
		stack = true, -- when enabled, multiple split windows with the same position will be stacked together (useful for terminals)
		keys = {
			q = "hide",
			gf = function(self)
				local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
				if f == "" then
					Snacks.notify.warn("No file under cursor")
				else
					self:hide()
					vim.schedule(function()
						vim.cmd("e " .. f)
					end)
				end
			end,
			term_normal = {
				"<esc>",
				function(self)
					self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
					if self.esc_timer:is_active() then
						self.esc_timer:stop()
						vim.cmd("stopinsert")
					else
						self.esc_timer:start(200, 0, function() end)
						return "<esc>"
					end
				end,
				mode = "t",
				expr = true,
				desc = "Double escape to normal mode",
			},
		},
	},
	-- dashboard = { enabled = true },
	-- explorer = { enabled = true },
	-- indent = { enabled = true },
	input = { enabled = true },
	notifier = {
		enabled = true,
		timeout = 3000,
	},
	picker = {
		enabled = true,
		formatters = {
			file = {
				smart = true, -- preserve the directory that distinguishes duplicate filenames
			},
		},
		win = {
			input = {
				keys = {
					["<A-s>"] = { "leap_select", mode = { "n", "i" } },
				},
			},
			list = {
				keys = {
					["<A-s>"] = "leap_select",
				},
			},
		},
		sources = {
			buffers = {
				layout = { preset = "dropdown" },
				-- current = false,
				-- sort_lastused = true,
				-- sort = { "lastused" },
			},
			files = {
				win = {
					input = {
						keys = {
							["<C-o>"] = { "multi_open", mode = { "i" } }, -- open with system application
							["<M-o>"] = { "multi_open_new_window", mode = { "i" } }, -- open with system application
						},
					},
				},
			},
			explorer = {
				win = {
					list = {
						keys = {
							["<leader>o"] = "multi_open", -- open with system application
						},
					},
				},
			},
		},
		matcher = {
			frecency = true,
		},
		actions = {
			-- TODO: refine and generalize, and consider for upstream
			leap_select = helpers.leap_select,
			multi_open = multi_open(false),
			multi_open_new_window = multi_open(true),
		},
	},
	quickfile = { enabled = true },
	-- scope = { enabled = true },
	-- scroll = { enabled = not vim.g.neovide },
	-- statuscolumn = { enabled = true },
	words = { enabled = true },
	styles = {
		notification = {
			wo = { wrap = true }, -- Wrap notifications
		},
		input = {
			relative = "cursor",
			row = -3,
			col = 0,
		},
	},
})
