-- source: https://github.com/s1n7ax/dotnvim
local alias_to_key_map = {
	text = "guifg",
	fg = "guifg",
	bg = "guibg",
}

local function map_join(map)
	local list = {}

	for k, v in pairs(map) do
		local key = alias_to_key_map[k] or k
		table.insert(list, key .. "=" .. v)
	end

	return table.concat(list, " ")
end

local function HighlightGroups(highlights)
	local highlight_groups = {}

	for name, colors in pairs(highlights) do
		highlight_groups[name] = {
			name = name,
			colors = map_join(colors),
		}
	end

	return highlight_groups
end

return HighlightGroups
