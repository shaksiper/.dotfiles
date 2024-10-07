-- require("copilot").setup({
-- 	suggestion = { enabled = false },
-- 	panel = { enabled = false },
-- })
-- require("copilot_cmp").setup()
-- require("neoai").setup({
-- 	-- Options go here
-- 	models = {
-- 		{
-- 			name = "openai",
-- 			model = { --[[ "gpt-3.5-turbo",  ]]
-- 				"gpt-4-1106-preview",
-- 			},
-- 			params = nil,
-- 		},
-- 	},
-- })
-- local home = vim.fn.expand("$HOME")
-- require("chatgpt").setup({
-- 	api_key_cmd = "gpg --decrypt " .. home .. "/Credentials/openai.env.gpg",
-- 	openai_params = {
-- 		model = "gpt-4-1106-preview",
-- 	},
-- 	openai_edit_params = {
-- 		model = "gpt-4-1106-preview",
-- 	},
-- })
require("gen").setup({
	display_mode = "float", -- The display mode. Can be "float" or "split".
	show_prompt = true, -- Shows the Prompt submitted to Ollama.
	show_model = true, -- Displays which model you are using at the beginning of your chat session.
})
