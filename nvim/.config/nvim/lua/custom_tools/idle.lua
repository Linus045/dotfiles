local IDLE_TIME_SEC = 60 * 6

local idle_timer = nil
local is_idle = false
local spell = nil

local function run_idle_task()
	if is_idle then
		-- print("Already idle")
		return
	end

	-- print("Starting idle")
	spell = vim.api.nvim_get_option_value("spell", { scope = "global" })
	is_idle = true

	vim.api.nvim_set_option_value("spell", false, { scope = "global" })

	local start_automaton = function()
		local mode = math.random(1, 3)
		if mode == 1 then
			vim.cmd(":CellularAutomaton scramble")
		elseif mode == 2 then
			vim.cmd(":CellularAutomaton game_of_life")
		elseif mode == 3 then
			vim.cmd(":CellularAutomaton make_it_rain")
		end
	end

	pcall(start_automaton)
end

local function stop_idle()
	-- print("Stopping idle")
	is_idle = false
	if spell ~= nil then
		vim.api.nvim_set_option_value("spell", spell, { scope = "global" })
	end
end


local function idle()
	-- local time = vim.fn.reltimestr(vim.fn.reltime())
	-- print("Reset time: " .. time)

	if is_idle then
		stop_idle()
	end

	if idle_timer ~= nil then
		vim.fn.timer_stop(idle_timer)
		idle_timer = nil
	end

	local test = run_idle_task

	idle_timer = vim.fn.timer_start(IDLE_TIME_SEC * 1000, test)
end

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	callback = idle
})
