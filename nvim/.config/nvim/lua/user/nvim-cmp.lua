local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
  vim.notify("nvim-cmp not found. Can't load debugger adapters")
  return
end

local status_ok2, luasnip = pcall(require, "luasnip")
if not status_ok2 then
  vim.notify(
    "luasnip not found. Can't autocomplete snippets. PLEASE ADD luasnip OR edit TAB/S-TAB keybinding function"
  )
  return
end



local status_ok3, lspkind = pcall(require, "lspkind")
if not status_ok3 then
  vim.notify("lspkind not found. Autocomplete Menu can't display type")
  return
end

-- load friendly snippets
require("luasnip/loaders/from_vscode").lazy_load()
require("user.luasnip")

require 'cmp_zsh'.setup {
  zshrc = true, -- Source the zshrc (adding all custom completions). default: false
  filetypes = { "sh", "zsh" } -- Filetypes to enable cmp_zsh source. default: {"*"}
}

-- Used for the TAB key mapping
-- See: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    -- ["<Esc>"] = cmp.abort(),
    ["<c-y>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
        -- if luasnip.expand_or_jumpable() then
        --   luasnip.expand_or_jump()
        -- end
      else
        fallback()
      end
    end, { "i", "c" }),
    ["<c-space>"] = cmp.mapping {
      i = function(fallback)
        if not cmp.visible() then
          cmp.complete()
        else
          -- ignore the keypress
          --fallback()
        end
      end,
      c = function(_ --[[fallback]])
        if cmp.visible() then
          if not cmp.confirm { select = true } then
            return
          end
        else
          cmp.complete()
        end
      end,
    },
    ['<Down>'] = cmp.config.disable,
    ['<Up>'] = cmp.config.disable,
    ["<tab>"] = cmp.config.disable,
    -- ["<Tab>"] = cmp.mapping(function(fallback)
    -- 	if cmp.visible() then
    -- 		cmp.select_next_item()
    -- 	elseif luasnip.expand_or_jumpable() then
    -- 		luasnip.expand_or_jump()
    -- 	elseif has_words_before() then
    -- 		cmp.complete()
    -- 	else
    -- 		fallback()
    -- 	end
    -- end, { "i", "s" }),
    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
    -- 	if cmp.visible() then
    -- 		cmp.select_prev_item()
    -- 	elseif luasnip.jumpable(-1) then
    -- 		luasnip.jump(-1)
    -- 	else
    -- 		fallback()
    -- 	end
    -- end, { "i", "s" }),
  }),
  completion = {
    autocomplete = {
      require("cmp.types").cmp.TriggerEvent.InsertEnter,
    },
    completeopt = 'menu,menuone,noselect,preview,noinsert',
    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
    keyword_length = 1,
  },
  -- completion = {
  --   keyword_length = -1,
  --   completeopt = "menu,menuone,noselect,preview,noinsert",
  -- },
  confirmation = {
    default_behavior = require("cmp.types").cmp.ConfirmBehavior.Replace,
  },
  preselect = cmp.PreselectMode.Item,
  view = {
    entries = "custom", -- can be "custom", "wildmenu" or "native"
    selection_order = "near_cursor",
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
    },
    documentation = {
      border = "double",
      winhighlight = "NormalFloat:NormalFloat,FloatBorder:NormalFloat",
      maxwidth = math.floor(20 * (vim.o.columns / 100)),
      maxheight = math.floor(20 * (vim.o.lines / 100)),
    },
    -- documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
        maxwidth = 50,
        menu = {
          nvim_lsp = "[LSP]",
          nvim_lsp_signature_help = "[Arg]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
          nvim_lua = "[Lua]",
          calc = "[Calc]",
          zsh = "[Zsh]",
          latex_symbols = "[Latex]",
        },
      })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      if strings[1] ~= "" then
        kind.kind = " " .. strings[1] .. " "
      else
        kind.kind = " UNKNOWN KIND "
      end

      if kind.menu == nil then
        kind.menu = "[" .. entry.source.name .. "]"
      end
      -- kind.menu = "    (" .. strings[2] .. ")"
      return kind
    end,
  },
  sources = cmp.config.sources({
    {
      name = "nvim_lsp",
      priority = 100,
      group_index = 1,
    },
    {
      name = "nvim_lsp_signature_help",
      priority = 110,
      group_index = 1,
      -- always show the signature help
      keyword_length = 0
    },
    {
      name = "nvim_lua",
      priority = 100,
      group_index = 1,
    },
    {
      name = "latex_symbols",
      priority = 80,
      group_index = 1,
    },
    {
      name = "luasnip",
      priority = 90,
      group_index = 2,
    },
    {
      name = "buffer",
      priority = 80,
      group_index = 3,
      --keyword_length = 3,
    },
    {
      name = "path",
      priority = 80,
      group_index = 3,
    },
    {
      name = "calc",
      priority = 100,
      group_index = 3,
    },
    -- {
    --   name = "zsh",
    --   group_index = 3,
    -- },
  }),
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      require "cmp-under-comparator".under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  experimental = {
    ghost_text = true,
  },
})
-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "buffer" },
  }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "nvim_lsp_document_symbol" },
  }, {
    { name = "buffer" },
  }),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = "path" }, },
    { { name = "cmdline" }, }
  ),
})
