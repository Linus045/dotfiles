local ThemeManager = require("utils.nvim.theme.theme-manager")
local HighlightGroups = require("utils.nvim.highlighting.highlight-groups")
local highlighter = require("utils.nvim.highlighting.highlighter")

local theme = ThemeManager.get_theme()

local highlight_groups = HighlightGroups({
  TextYank = { guibg = theme.normal.yellow, guifg = theme.normal.black },
})

highlighter:new():add(highlight_groups):register_highlights()

vim.cmd("autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=300}")


vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.c", "*.h", "*.cpp" },
  callback = function()
    vim.api.nvim_buf_set_option(0, "tabstop", 4)
    vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
  end
})


-- easier editing of binary files
-- see :help using-xxd
vim.cmd([[
	augroup Binary
	  au!
	  au BufReadPre  *.bin let &bin=1
	  au BufReadPost *.bin if &bin | %!xxd
	  au BufReadPost *.bin set ft=xxd | endif
	  au BufWritePre *.bin if &bin | %!xxd -r
	  au BufWritePre *.bin endif
	  au BufWritePost *.bin if &bin | %!xxd
	  au BufWritePost *.bin set nomod | endif
	augroup END
]])

-- e.g. :lua P(vim.api)
-- now also :lua =vim.api works
function P(v)
  print(vim.inspect(v))
  return v
end

local status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  vim.notify('File utilities.lua: which-key not found.')
  return
end

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

M.keymap = function(mode, lhs, rhs, opts, description, dontShow, dontRegister, bufnr)
  if not M.bindings[mode] then
    vim.notify("Error: invalid mode (" .. mode .. ") for keybinding: " .. lhs .. " = " .. rhs)
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
  local mapping = {
    [lhs] = {}
  }

  -- set as group label if no rhs is given
  if not rhs then
    mapping[lhs]["name"] = description
  else
    mapping[lhs] = { rhs }
  end

  -- hide binding in popup
  if dontShow then
    mapping[lhs][1] = "which_key_ignore"
  end

  if description ~= nil then
    table.insert(mapping[lhs], description)
  end

  --P({ mode, mapping })
  if mode ~= "" then
    wk.register(mapping, {
      ["mode"] = mode, -- NORMAL mode
      -- prefix: use "<leader>f" for example for mapping everything related to finding files
      -- the prefix is prepended to every mapping part of `mappings`
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
    })
  end

  if not dontRegister then
    if bufnr ~= nil then
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    else
      vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
  end
end



M.register_rust_cargo_check_autocommand = function()
  -- check if window exists otherwise create it

  M.window_nr = -1
  M.buf_nr = -1

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("rust_cargo_check_autocommand", { clear = true }),
    callback = function()
      -- make sure this is a rust file
      local filetype = vim.api.nvim_buf_get_option(0, "filetype")
      if filetype ~= "rust" then
        return
      end

      if vim.api.nvim_buf_is_valid(M.buf_nr) then
        -- vim.notify("Closed buffer: " .. M.buf_nr)
        vim.api.nvim_buf_delete(M.buf_nr, { force = true, unload = false })
      end

      if vim.api.nvim_win_is_valid(M.window_nr) then
        -- vim.notify("Closed window: " .. M.window_nr)
        vim.api.nvim_win_close(M.window_nr, false)
      end


      local args = { "cargo", "check", "--message-format", "human", "-q", "--color", "always" }
      vim.cmd("noautocmd new | resize 6 | terminal " .. vim.fn.join(args, " "))
      M.buf_nr = vim.api.nvim_get_current_buf()
      local win = vim.api.nvim_get_current_win()
      M.window_nr = win

      -- TODO: Maybe try this with AnsiEsc but for now its fine to call it via :terminal
      --   -- callback to handle 'cargo check' output
      --   local on_cargo_check = function(_, output_lines)
      --     local lines_to_print = {}
      --     local error_amount = 1

      --     -- only include the first error from the output
      --     for lineNr, line in ipairs(output_lines) do
      --       if vim.startswith(line, "error") then
      --         if error_amount == 0 then
      --           break
      --         end

      --         error_amount = error_amount - 1
      --         table.insert(lines_to_print, line)
      --       else
      --         table.insert(lines_to_print, line)
      --       end
      --     end

      --     if #lines_to_print == 0 then
      --       return
      --     end

      --     if not vim.api.nvim_win_is_valid(M.rust_cargo_check_window_nr) then
      --       -- create window
      --       vim.cmd('noautocmd new | terminal')
      --       vim.cmd('resize 6')
      --       local win = vim.api.nvim_get_current_win()
      --       M.rust_cargo_check_window_nr = win
      --     end


      --     -- check if buffer exists, otherwise create it
      --     if not vim.api.nvim_buf_is_valid(M.rust_cargo_check_buf_nr) then
      --       M.rust_cargo_check_buf_nr = vim.api.nvim_create_buf(true, true)
      --       if M.rust_cargo_check_buf_nr == 0 then
      --         print("[Utilities.RustCheck] Failed to create buffer")
      --         return
      --       end
      --     end

      --     -- set buffer for window
      --     -- vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "buftype", "terminal")
      --     vim.api.nvim_buf_set_lines(M.rust_cargo_check_buf_nr, 0, -1, false, lines_to_print)
      --     vim.api.nvim_win_set_buf(M.rust_cargo_check_window_nr, M.rust_cargo_check_buf_nr)
      --     vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "bt", "terminal")
      --     -- vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "readonly", true)
      --   end

      --   print("Running cargo check")
      --   -- message-format human|short|json|json-diagnostic-short|json-diagnostic-rendered-ansi|json-render-diagnostics
      --   local args = { "cargo", "check", "--message-format", "human", "-q", "--color", "always" }
      --   vim.fn.jobstart(args, {
      --     stdout_buffered = true,
      --     stderr_buffered = true,
      --     on_stdout = on_cargo_check,
      --     on_stderr = on_cargo_check,
      --   })
    end
  })
end


M.RunCurrentCFile = function(argsString)
  -- make sure this is a rust file
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if filetype ~= "c" then
    return
  end

  if M.buf_nr and vim.api.nvim_buf_is_valid(M.buf_nr) then
    -- vim.notify("Closed buffer: " .. M.buf_nr)
    vim.api.nvim_buf_delete(M.buf_nr, { force = true, unload = false })
  end

  if M.window_nr and vim.api.nvim_win_is_valid(M.window_nr) then
    -- vim.notify("Closed window: " .. M.window_nr)
    vim.api.nvim_win_close(M.window_nr, false)
  end

  local runArgs = {}
  if argsString ~= nil then
    runArgs = vim.fn.split(argsString, " ", false)
  end
  local file = vim.api.nvim_buf_get_name(0)
  local args = { "gcc", "-g", "-Wall", file, "-o", "/tmp/nvim_c_program", "&&", "/tmp/nvim_c_program" }
  args = vim.fn.extend(args, runArgs)
  vim.cmd("noautocmd new | resize 6 | terminal " .. vim.fn.join(args, " "))
  M.buf_nr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  M.window_nr = win
end

M.register_gcc_run_user_command = function()
  vim.api.nvim_create_user_command("RunCFile", function(opts)
    M.RunCurrentCFile(opts.args)
  end, { nargs = "*" })
end

M.register_gcc_check_autocommand = function()
  -- check if window exists otherwise create it

  M.window_nr = -1
  M.buf_nr = -1

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("gcc_check_autocommand", { clear = true }),
    callback = function(opts)
      M.RunCurrentCFile()
    end
  })
end

return M
