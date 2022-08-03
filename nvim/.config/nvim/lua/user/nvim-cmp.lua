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
		["<C-k>"] = cmp.mapping.scroll_docs(-4),
		["<C-j>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	completion = {
		keyword_length = 1,
		completeopt = "menu,menuone,preview,noinsert",
	},
	confirmation = {
		default_behavior = require('cmp.types').cmp.ConfirmBehavior.Replace,
	},
	preselect = false,
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
        border = {
            '╭',
            '─',
            '╮',
            '│',
            '╯',
            '─',
            '╰',
            '│',
        },

        winhighlight = 'NormalFloat:NormalFloat,FloatBorder:NormalFloat',
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
					luasnip = "[LuaSnip]",
					buffer = "[Buffer]",
					path = "[Path]",
					nvim_lua = "[Lua]",
					calc = "[Calc]",
					--latex_symbols = "[Latex]",
				},
			})(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. strings[1] .. " "
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
			priority = 100,
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
	}),
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
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Setup lspconfig.
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
-- HERE CHANGE
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require("lspconfig")
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
local lsps = require'nvim-lsp-installer.servers'.get_installed_server_names()

for _, lsp in ipairs(lsps) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end
