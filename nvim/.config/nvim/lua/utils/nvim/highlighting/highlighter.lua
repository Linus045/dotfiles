-- -- source: https://github.com/s1n7ax/dotnvim
-- local v = vim

-- local M = {}

-- function M:new()
-- 	self.new_called = true
-- 	self.highlight_groups_list = {}

-- 	return self
-- end

-- function M:__instance_validation()
-- 	if not self.new_called then
-- 		error("Highlighter: call new() before using this class")
-- 	end
-- end

-- function M:add(highlight_groups)
-- 	self:__instance_validation()

-- 	table.insert(self.highlight_groups_list, highlight_groups)

-- 	return self
-- end

-- function M:register_highlights()
-- 	self:__instance_validation()

-- 	for _, highlight_groups in ipairs(self.highlight_groups_list) do
-- 		for _, highlight_group in pairs(highlight_groups) do
-- 			v.cmd(string.format("highlight %s %s", highlight_group.name, highlight_group.colors))
-- 		end
-- 	end

-- 	return self
-- end

-- return M
