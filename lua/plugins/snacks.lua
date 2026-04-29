local Snacks = require("snacks")
local helpers = require("plugins.snacks-helpers")

vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(event)
		if event.data.actions.type == "move" then
			Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
		end
	end,
})

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
							-- ["<A-s>"] = { "leap", mode = { "n", "i" } },
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
			multi_open = function(picker)
				if vim.fn.mode():find("^[vV]") then
					picker.list:select()
				end
				local files = {}
				for _, item in ipairs(picker:selected({ fallback = true })) do
					table.insert(files, item.file)
				end
				print(vim.inspect(files))
				local _, err = helpers.multi_open(files, { cmd = { "zed" } })
				if err then
					Snacks.notify.error("Failed to open `" .. files .. "`:\n- " .. err)
				end
				picker:close()
				-- picker.list:set_selected() -- clear selection
			end,
		},
	},
	quickfile = { enabled = true },
	-- scope = { enabled = true },
	scroll = { enabled = true },
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
