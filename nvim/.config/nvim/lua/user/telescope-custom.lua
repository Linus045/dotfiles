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

M.custom_selection_menu_files("test", "~", function(t)
  P(t)
end)


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


return M
