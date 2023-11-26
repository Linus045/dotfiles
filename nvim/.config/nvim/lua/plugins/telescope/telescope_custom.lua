local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

M.dot_files = function()
	local opts = {
		cwd = os.getenv("DOTFILES"),
		hidden = true,
	}
	-- local ok = pcall(require"telescope.builtin".git_files, opts)
	-- if not ok then require"telescope.builtin".find_files(opts) end
	require("telescope.builtin").find_files(opts)
end

M.custom_selection_menu = function(title, options, on_select_callback)
	local enter = function(prompt_bufnr)
		local selected = action_state.get_selected_entry(prompt_bufnr)
		local selected_entry = selected[1]
		actions.close(prompt_bufnr)

		on_select_callback(selected_entry)
	end

	local opts = {
		finder = finders.new_table(options),
		sorter = sorters.get_generic_fuzzy_sorter({}),
		border = true,
		prompt_title = title,
		layout_strategy = "vertical",
		layout_config = {
			height = 30,
			width = 0.8,
			prompt_position = "bottom",
		},
		attach_mappings = function(prompt_bufnr, map)
			map("i", "<CR>", enter)
			map("n", "<CR>", enter)
			return true
		end,
	}

	local project_picker = pickers.new(opts)
	project_picker:find()
end

M.custom_selection_menu_files = function(title, cwd, fd_parameter, on_select_callback)
	local enter = function(prompt_bufnr)
		local selected = action_state.get_selected_entry(prompt_bufnr)
		local selected_entry = selected[1]
		actions.close(prompt_bufnr)

		on_select_callback(selected_entry)
	end

	local command = vim.tbl_flatten { "fd", fd_parameter }

	local opts = {
		cwd = cwd,
		finder = finders.new_oneshot_job(command, { cwd = cwd }),
		sorter = sorters.get_generic_fuzzy_sorter({}),
		border = true,
		prompt_title = title,
		layout_strategy = "vertical",
		layout_config = {
			height = 30,
			width = 0.8,
			prompt_position = "bottom",
		},
		function(prompt_bufnr, map)
			map("i", "<CR>", enter)
			map("n", "<CR>", enter)
			return true
		end,
	}

	local project_picker = pickers.new(opts)
	project_picker:find()
end


M.list_sessions = function()
	-- TODO: Handle case if Prosession is not installed
	local directories = {
		"~/dotfiles",
		"~/dev/",
	}

	local cwd_entry = vim.fn.getcwd()
	local prosession_installed = vim.fn.exists(":Prosession") == 2
	if prosession_installed then
		directories = vim.fn.getcompletion("Prosession ", "cmdline")
		if not vim.tbl_contains(directories, cwd_entry) then
			table.insert(directories, "CREATE NEW PROSESSION: " .. cwd_entry)
		end
	end

	local enter = function(prompt_bufnr)
		local selected = action_state.get_selected_entry(prompt_bufnr)
		local selected_dir = selected[1]
		actions.close(prompt_bufnr)

		if prosession_installed then
			if selected_dir == "CREATE NEW PROSESSION: " .. cwd_entry then
				vim.cmd("Prosession")
				vim.notify("Prosession: Created new Prosession")
			else
				vim.cmd("Prosession " .. selected_dir)
				vim.notify("Prosession: Switched to Prosession: " .. selected_dir)
			end
		else
			vim.notify("Prosession: Not installed")
		end
	end

	local delete_session = function(prompt_bufnr)
		local selected = action_state.get_selected_entry(prompt_bufnr)
		local selected_dir = selected[1]

		if prosession_installed then
			if selected_dir == "CREATE NEW PROSESSION: " .. cwd_entry then
				vim.notify("Prosession: Can't delete session")
			else
				vim.cmd("ProsessionDelete " .. selected_dir)
				vim.notify("Prosession: Deleted Prosession: " .. selected_dir)
			end
		else
			vim.notify("Prosession: Not installed")
		end

		actions.close(prompt_bufnr)
	end

	local opts = {
		cwd = os.getenv("HOME") .. "/dev",
		finder = finders.new_table(directories),
		sorter = sorters.get_generic_fuzzy_sorter({}),
		hidden = true,
		border = true,
		prompt_title = "Sessions [x:delete | enter:select session]",
		layout_strategy = "vertical",
		layout_config = {
			height = 30,
			width = 0.8,
			prompt_position = "bottom",
		},
		attach_mappings = function(prompt_bufnr, map)
			map("i", "<CR>", enter)
			map("n", "<CR>", enter)
			map("n", "x", delete_session)
			return true
		end,
	}

	local project_picker = pickers.new(opts)
	project_picker:find()
end


local live_grep_in_glob = function(glob_pattern)
	require('telescope.builtin').live_grep({
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--glob=" .. (glob_pattern or ""),
		}
	})
end

M.live_grep_in_glob = function()
	vim.ui.input({ prompt = "Glob: ", completion = "file", default = "**/*." }, live_grep_in_glob)
end


local function is_git_repo(path)
	local success, result = pcall(function()
		local git_path = vim.fn.resolve(path .. "/.git")
		local git_repo_exists, err = vim.loop.fs_stat(git_path)
		local utils = require("telescope.utils")
		local branch_info = utils.get_os_command_output({ "git", "show-branch" }, path)[1]
		return { git_repo_exists, branch_info }
	end)
	if success then
		return result[1], result[2]
	else
		return nil
	end
end

M.list_projects = function(opts)
	opts = opts or {}
	local directories = {
		"~/dev",
		"~/useful_scripts",
		"~/dotfiles",
		"~/OneDrive",
	}
	local project_directories = {}

	local function add_directory_if_git_project(search_dir, rel_path)
		local absolute_path = vim.fn.fnamemodify(vim.fn.resolve(vim.fs.joinpath(search_dir, rel_path)), ":p")
		local git_repo_exists, branch_info = is_git_repo(absolute_path)
		if git_repo_exists == nil then
			-- we have no access to this directory
		elseif git_repo_exists then
			table.insert(project_directories, {
				rel_path = rel_path ~= "" and rel_path or search_dir,
				absolute_path = absolute_path,
				is_git_repo = git_repo_exists and branch_info or "-"
			})
		end
	end

	for _, search_dir in pairs(directories) do
		add_directory_if_git_project(search_dir, "")

		local dirs = vim.fs.dir(search_dir, {
			depth = 3,
			skip = function(dirname)
				local absolute_path = vim.fn.fnamemodify(vim.fn.resolve(vim.fs.joinpath(search_dir, dirname)), ":p")
				local git_repo_exists, _ = is_git_repo(absolute_path)
				return not git_repo_exists
			end
		})

		for rel_path, type in dirs do
			if type == "directory" then
				add_directory_if_git_project(search_dir, rel_path)
			end
		end
	end

	local enter = function(prompt_bufnr)
		local selected = action_state.get_selected_entry(prompt_bufnr)
		local selected_dir = selected.absolute_path
		actions.close(prompt_bufnr)
		vim.cmd("cd " .. selected_dir)
		vim.cmd("clearjumps")

		require("load_project_config").load_custom_config_for_cwd()
	end


	local displayer = require("telescope.pickers.entry_display").create {
		separator = " ",
		items = {
			{ width = 30 },
			{ width = 60 },
			{ remaining = true }
		},
	}

	local utils = require("telescope.utils")
	local make_display = function(entry)
		return displayer {
			{ entry.rel_path,     "TelescopeResultsIdentifier" },
			-- { utils.transform_path(opts, entry.absolute_path) },
			{ entry.absolute_path },
			{ entry.is_git_repo },
		}
	end

	local project_picker = pickers.new(opts, {
		cwd = os.getenv("HOME"),
		finder = finders.new_table({
			results = project_directories,
			entry_maker = function(entry)
				entry.display = make_display
				entry.ordinal = entry.absolute_path
				entry.value = entry.rel_path
				return entry
			end,
		}),
		sorter = sorters.get_fzy_sorter({}),
		hidden = true,
		border = true,
		prompt_title = "Change Directory [enter:change into directory]",
		layout_strategy = "vertical",
		layout_config = {
			height = 30,
			width = 0.8,
			prompt_position = "bottom",
		},
		attach_mappings = function(prompt_bufnr, map)
			map("i", "<CR>", enter)
			map("n", "<CR>", enter)
			return true
		end,
	})

	project_picker:find()
end


return M
