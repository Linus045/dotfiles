-- Copilot (Disable due to high cpu for some reason)
if ENABLE_COPILOT then
	return {
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end
	}
else
	return {}
end
