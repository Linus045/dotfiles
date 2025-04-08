local Copilot_Complete = {}
if ENABLE_COPILOT then
	Copilot_Complete = {
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end
	}
end

return {
	require("plugins.autocomplete.neogen"),
	-- Faster autocompletion
	require("plugins.autocomplete.copilot_vim"),
	{
		"hrsh7th/nvim-cmp",
		-- lost just before insert mode is entered, see :h InsertEnter
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"hrsh7th/cmp-omni",
			"f3fora/cmp-spell",
			"p00f/clangd_extensions.nvim",
			{
				"tamago324/cmp-zsh",
				config = function()
					require('cmp_zsh').setup {
						zshrc = true, -- Source the zshrc (adding all custom completions). default: false
						filetypes = { "sh", "zsh" } -- Filetypes to enable cmp_zsh source. default: {"*"}
					}
				end
			},
			"kdheepak/cmp-latex-symbols",
			-- TODO: Add this back in and test it
			-- "rcarriga/cmp-dap",
			-- fix cmp ordering for dunder elements e.g. __main__ for python files
			"lukas-reineke/cmp-under-comparator",

			-- Snippets
			require("plugins.autocomplete.luasnip_stuff"),

			"saadparwaiz1/cmp_luasnip",

			-- show icons for entries in autocomplete menu
			"onsails/lspkind.nvim",
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				dependencies = { "rafamadriz/friendly-snippets" },
			},
			Copilot_Complete
		},
		config = function()
			local cmp = require("cmp")

			local luasnip = require("luasnip")
			-- local lspkind = require("lspkind")

			-- Used for the TAB key mapping
			-- See: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
			-- local has_words_before = function()
			-- 	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			-- 	return col ~= 0 and
			-- 		vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			-- end

			local compare = require('cmp.config.compare')
			local cmp_comparators = {
				require("clangd_extensions.cmp_scores"),
				compare.offset,
				compare.exact,
				-- compare.scopes,
				compare.score,
				compare.recently_used,
				compare.locality,
				compare.kind,
				compare.sort_text,
				compare.length,
				compare.order,
				require "cmp-under-comparator".under,
			}


			if ENABLE_COPILOT then
				cmp.event:on("menu_opened", function()
					vim.b.copilot_suggestion_hidden = true
				end)

				cmp.event:on("menu_closed", function()
					vim.b.copilot_suggestion_hidden = false
				end)

				table.insert(cmp_comparators, 1, require("copilot_cmp.comparators").prioritize)
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
					["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<Esc>"] = cmp.mapping(function(fallback)
						cmp.mapping.abort()
						fallback()
					end),
					-- ["<Esc>"] = cmp.abort(),
					["<c-y>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
							-- elseif luasnip.expandable() then
							-- print("Expanding snippet...")
							-- luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "c" }),
					["<c-space>"] = cmp.mapping {
						i = function(_fallback)
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
				}),
				-- confirmation = {
				-- },
				-- view = {
				-- 	entries = "custom", -- can be "custom", "wildmenu" or "native"
				-- 	selection_order = "near_cursor",
				-- 	docs = {
				-- 		auto_open = true,
				-- 	},
				-- },
				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(entry, vim_item)
						local kind = require("lspkind").cmp_format({
							mode = "symbol_text",
							menu = ({
								nvim_lsp = "[LSP]",
								nvim_lsp_signature_help = "[Arg]",
								luasnip = "[Snippet]",
								buffer = "[Buffer]",
								path = "[Path]",
								nvim_lua = "[Lua]",
								calc = "[Calc]",
								zsh = "[Zsh]",
								latex_symbols = "[Latex]",
								copilot = "[Copilot]",
							}),
							symbol_map = {
								Copilot = "",
							}
						})(entry, vim_item)

						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						if strings[1] ~= "" then
							kind.kind = strings[1]
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
						name = 'omni',
						-- priority = 100,
						-- group_index = 1
					},
					{
						name = "nvim_lsp",
						-- priority = 100,
						-- group_index = 1,
						-- workaround for clangd's missing functions/cached results
						-- see: https://github.com/hrsh7th/nvim-cmp/issues/1176
						trigger_characters = {
							'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
							's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
							'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '_'
						}
					},
					{
						name = "copilot",
						-- priority = 101,
						-- group_index = 1,
					},
					{
						name = "nvim_lsp_signature_help",
						-- priority = 110,
						-- group_index = 1,
						-- always show the signature help
						keyword_length = 0
					},
					{
						name = "nvim_lua",
						-- priority = 100,
						-- group_index = 1,
					},
					{
						name = "latex_symbols",
						-- priority = 80,
						-- group_index = 1,
						-- https://github.com/kdheepak/cmp-latex-symbols#options
						option = {
							strategy = 2,
						},
					},
					{
						name = "luasnip",
						-- priority = 90,
						-- group_index = 1,
						max_item_count = 5,
					},
					{
						name = "buffer",
						-- priority = 80,
						-- group_index = 1,
						max_item_count = 5,
						option = {
							keyword_pattern = [[\k\+]],
						}
						--keyword_length = 3,
					},
					{
						name = "path",
						-- priority = 80,
						-- group_index = 1,
					},
					{
						name = "calc",
						-- priority = 100,
						-- group_index = 1,
					},
					{
						name = "lazydev",
						-- group_index = 1,
					},
					-- {
					--   name = "zsh",
					--   group_index = 3,
					-- },
				}),
				sorting = {
					priority_weight = 2,
					comparators = cmp_comparators,
				},
				experimental = {
					ghost_text = false,
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

			-- cmp.setup({
			--   enabled = function()
			--     return (vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()) and
			--         require("dap").session() and require("dap").session().capabilities and
			--         require("dap").session().capabilities.supportsCompletionsRequest
			--   end
			-- })

			cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
				sources = {
					{ name = "dap" },
				},
			})
		end
	},

	-- {
	-- 	"evesdropper/luasnip-latex-snippets.nvim",
	-- },

}
