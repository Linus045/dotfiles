local status_ok, transparent = pcall(require, "transparent")
if not status_ok then
  vim.notify("nvim-transparent not found")
  return
end

transparent.setup({
  extra_groups = { -- table/string: additional groups that should be clear
    -- In particular, when you set it to 'all', that means all avaliable groups

    -- example of akinsho/nvim-bufferline.lua
    -- "BufferlineBufferSelected",
    "BufferLineTabClose",
    "BufferLineFill",
    "BufferLineBackground",
    "BufferLineSeparator",
    "BufferLineIndicatorSelected",
  },
  --exclude_groups = {}, -- table: groups you don't want to clear
})
