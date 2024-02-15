require('cmp').setup.buffer {
	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = ({
				omni = (vim.inspect(vim_item.menu):gsub('%"', "")),
				buffer = "[Buffer]",
				-- formatting for other sources
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = 'omni' },
		{
			name = 'buffer',
			max_item_count = 20,
			option = {
				keyword_pattern = [[\k\+]],
			}
		},
		-- other sources
	},
}

vim.diagnostic.config({
	update_in_insert = false,
	virtual_text = false,
})
