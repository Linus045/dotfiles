if ENABLE_COPILOT then
	return {
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			dependencies = { "copilot.lua" },
			opts = {
				suggestion = { enabled = false },
				panel = { enabled = false },
			}
		}
	}
else
	return {}
end
