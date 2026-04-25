if ENABLE_COPILOT then
	return {
		{
			"zbirenbaum/copilot-cmp",
			config = function()
				require("copilot_cmp").setup()
			end
		}
	}
else
	return {}
end
