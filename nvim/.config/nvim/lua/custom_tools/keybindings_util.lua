local M = {}

M.bindings = {
	[""] = {},
	n = {},
	i = {},
	v = {},
	x = {},
	t = {},
	o = {}
}

M.keymap = function(mode, lhs, rhs, opts, description, dontShow, dontRegister, bufnr, add_to_which_key)
	if not M.bindings[mode] then
		local rhsText = ""
		if type(rhs) == "string" then
			rhsText = "<invalid rhs:" .. type(rhs) .. ">"
		else
			rhsText = "<invalid rhs:" .. type(rhs) .. ">"
		end
		vim.notify("Error: invalid mode (" .. mode .. ") for keybinding: " .. lhs .. " = " .. rhsText)
		return
	end

	local keybindingExists = M.bindings[mode][lhs] ~= nil and true or false
	if keybindingExists then
		local bufnrExists = M.bindings[mode][lhs]["bufnr"] and true or false
		if not bufnrExists or (M.bindings[mode][lhs]["bufnr"] == bufnr) then
			-- vim.notify("Conflicting keybinding for: " .. lhs)
			return
		end
	end

	M.bindings[mode][lhs] = {
		["mode"] = mode,
		["lhs"] = lhs,
		["rhs"] = rhs,
		["opts"] = opts,
		["bufnr"] = bufnr
	}

	local mapping = {}

	-- set as group label if no rhs is given
	if not rhs then
		mapping[1] = lhs
		mapping["desc"] = description
	else
		mapping[1] = lhs
		mapping[2] = rhs
	end

	-- hide binding in popup
	if dontShow then
		mapping["hidden"] = true
	end

	if description ~= nil then
		mapping["desc"] = description
	end

	add_to_which_key = add_to_which_key == nil and true or add_to_which_key

	--P({ mode, mapping })
	if mode ~= "" and add_to_which_key == true then
		local wk = require('which-key')

		wk.add(
			mapping,
			{
				mode = mode, -- NORMAL mode
				-- prefix: use "<leader>f" for example for mapping everything related to finding files
				-- the prefix is prepended to every mapping part of `mappings`
				buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
				silent = true, -- use `silent` when creating keymaps
				noremap = true, -- use `noremap` when creating keymaps
				nowait = false, -- use `nowait` when creating keymaps
			})
	end

	if not dontRegister then
		-- 0 means current buffer, vim.keymap.set() requires true instead
		opts["buffer"] = (bufnr == 0) and true or bufnr
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

return M
