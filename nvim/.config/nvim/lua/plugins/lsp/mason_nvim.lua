local function lsp_keymaps(_client, bufnr)
	local keymap = require("custom_tools.keybindings_util").keymap
	local opts = { noremap = true, silent = true }
	-- local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	keymap("n", "gq", function()
		vim.lsp.buf.type_definition({ reuse_win = true })
	end, opts, "Type Defintions", nil, nil, bufnr)
	keymap("n", "gD", function()
		vim.lsp.buf.declaration({ reuse_win = true })
	end, opts, "Goto Declaration", nil, nil, bufnr)
	keymap("n", "gd", function()
		vim.lsp.buf.definition({ reuse_win = true })
	end, opts, "Goto Definition", nil, nil, bufnr)
	-- TODO: Causes problems with :Man (jumping to references no longer works)
	-- Workaround use Ctrl+] to jump

	local hover_func = function(text)
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
		if filetype == "rust" and require("custom_tools.termdebug_helper").in_debug_session then
			vim.cmd("Evaluate")
		elseif filetype == "man" then
			vim.notify("TODO: put correct action here")
		elseif require("dap").session() then
			-- not sure which i like better
			--require 'dap.ui.widgets'.hover('<cexpr>', nil)
			-- OR:
			require 'dapui'.eval(nil, {
				enter = true,
				context = "hover",
			})
		else
			vim.lsp.buf.hover()
		end
	end

	keymap("n", "K", function()
		hover_func(vim.fn.expand('<cexpr>'))
	end, opts, "HOVER INFO", nil, nil, bufnr)


	keymap("v", "K", function()
		hover_func(vim.fn.getregion(vim.fn.getpos('.'), vim.fn.getpos('v'), { type = vim.fn.mode() }))
	end, opts, "HOVER INFO", nil, nil, bufnr)


	keymap("n", "<C-K>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts, "Signature Help", nil, nil, bufnr)
	keymap("i", "<C-K>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts, "Signature Help", nil, nil, bufnr)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts, "Goto Implementation [Telescope]", nil, nil, bufnr)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts, "Goto References [Telescope]", nil, nil, bufnr)
	keymap("n", "gl", '<cmd>lua vim.diagnostic.open_float({ border = "rounded", wrap = true, max_width = 80 })<CR>', opts,
		"Show Diagnostics", nil, nil, bufnr)

	-- Create own file/directory that allows custom commands/keybindings per language/lsp provider
	-- e.g. lsp/configurations/clangd.lua which contains this command or a more advanced version that can search for implementations if used on a function signature etc.
	-- https://github.com/neovim/nvim-lspconfig/blob/c5dae15c0c94703a0565e8ba35a9f5cb96ca7b8a/lua/lspconfig/server_configurations/clangd.lua#L52-L59
	keymap("n", "gh", '<cmd>ClangdSwitchSourceHeader<CR>', opts, "[Clangd] Switch between source/header file", nil, nil,
		bufnr)

	keymap("n", "<leader>,", "<cmd>lua vim.lsp.codelens.run()<CR>", opts, "Codelens (uses DAP to Run|Debug)", nil, nil,
		bufnr)
	keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, "Rename variable", nil, nil, bufnr)
	keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts, "Diagnostics quickfix list", nil, nil,
		bufnr)


	vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
end

local function lsp_highlight_document(client, bufnr)
	-- Set autocommands conditional on server_capabilities
	if client and client.server_capabilities.documentHighlightProvider then
		local highlight_augroup = vim.api.nvim_create_augroup('custom-lsp-highlight', { clear = false })
		vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
			buffer = bufnr,
			group = highlight_augroup,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
			buffer = bufnr,
			group = highlight_augroup,
			callback = vim.lsp.buf.clear_references,
		})

		vim.api.nvim_create_autocmd('LspDetach', {
			group = vim.api.nvim_create_augroup('custom-lsp-detach-codelens-highlight', { clear = true }),
			callback = function(event)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds { group = 'custom-lsp-highlight', buffer = event.buf }
			end,
		})
	end
end

local function lsp_codelens(client, bufnr)
	if client.server_capabilities.codeLensProvider then
		local codelens_augroup = vim.api.nvim_create_augroup('custom-lsp-codelens', { clear = false })
		vim.api.nvim_create_autocmd({ 'BufEnter' }, {
			buffer = bufnr,
			once = true,
			group = codelens_augroup,
			callback = function() require "vim.lsp.codelens".refresh({ bufnr = bufnr }) end,
		})

		vim.api.nvim_create_autocmd({ 'BufWritePost', 'CursorHold' }, {
			buffer = bufnr,
			group = codelens_augroup,
			callback = function() require "vim.lsp.codelens".refresh({ bufnr = bufnr }) end,
		})

		vim.api.nvim_create_autocmd('LspDetach', {
			group = vim.api.nvim_create_augroup('custom-lsp-detach-codelens', { clear = true }),
			callback = function(event)
				vim.api.nvim_clear_autocmds { group = 'custom-lsp-codelens', buffer = event.buf }
			end,
		})
	end
end

local lsp_server_on_attach = function(client, bufnr)
	-- vim.notify("Attaching LSP Client: " .. client.name .. " to buffer")
	lsp_keymaps(client, bufnr)
	lsp_highlight_document(client, bufnr)
	lsp_codelens(client, bufnr)

	require("lsp-status").on_attach(client)

	-- Register folds for: pierreglaser/folding-nvim
	local status_ok_folding, folding = pcall(require, 'folding')
	if status_ok_folding then
		folding.on_attach()
	else
		-- vim.notify('File handlers.lua: folding not found.')
	end

	-- Register automatic formatting: lsp-format.nvim
	-- require("lsp-format").on_attach(client)


	local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
	if filetype == "rust" then
		require("custom_tools.rust_cargo_checker").register_rust_cargo_check_autocommand()
	end
	if filetype == "c" then
		-- require("user.utilities").register_gcc_check_autocommand()
		require("custom_tools.c_cpp_utilities").register_gcc_run_user_command()
	end

	-- Attach nvim-navbuddy
	local status_ok_navbuddy, navbuddy = pcall(require, 'nvim-navbuddy')
	if not status_ok_navbuddy then
		vim.notify('File mason_nvim.lua: nvim-navbuddy not found.')
		return
	end

	if client.server_capabilities.documentSymbolProvider then
		navbuddy.attach(client, bufnr)
	end
end


-- quickly see the lsp configs
vim.api.nvim_create_user_command(
	"LspShowConfiguration",
	function()
		vim.cmd("tabnew")
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_win_set_buf(0, buf)
		vim.keymap.set("n", "q", function()
			vim.api.nvim_buf_delete(buf, {})
		end, { buffer = buf, remap = false });

		for _, client in ipairs(vim.lsp.get_clients()) do
			vim.api.nvim_buf_set_lines(buf, -1, -1, false,
				{ "Client: " .. client.name, "-------------------------------" })
			local config = vim.inspect(client.config)
			local lines  = vim.fn.split(config, '\n')
			table.insert(lines, 1, "Config:")
			table.insert(lines, "-------------------------------")
			table.insert(lines, "")
			table.insert(lines, "")
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
		end

		vim.api.nvim_set_option_value("readonly", true, { buf = buf })
	end,
	{}
)

-- autoinstall lsp server
return {
	"williamboman/mason.nvim",
	dependencies = {
		-- mason lsp config extension
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"nvim-lua/lsp-status.nvim",
		"folke/which-key.nvim",
		"mhartington/formatter.nvim"
	},
	config = function()
		local mason = require("mason")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			}
		})

		require("formatter").setup({
			silent = true,
			filetype = {
				tex = {
					function()
						local util = require "formatter.util"
						return {
							exe = "tex-fmt",
							args = {
								"--print",
								"--stdin"
							},
							stdin = true,
						}
					end
				},
				glsl = function()
					local util = require "formatter.util"
					return {
						exe = "clang-format",
						args = {
							util.escape_path(util.get_current_buffer_file_path()),
						},
						stdin = true,
					}
				end,
				cmake = function()
					local util = require "formatter.util"
					return {
						exe = "cmake-format",
						args = {
							util.escape_path(util.get_current_buffer_file_path()),
						},
						stdin = true,
					}
				end
			}
		})

		local mason_lspconfig = require("mason-lspconfig")
		--[[
		Installed
		✓ clang-format
		✓ clangd
		✓ cmake-language-server
		✓ gopls
		✓ lua-language-server
		✓ rust-analyzer
		✓ typescript-language-server
		✓ vue-language-server
		]]
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"clangd",
				"jsonls",
				"yamlls",
				"bashls",
				-- "gopls",
				-- "volar",
				-- "ts_ls",
				-- "tsserver",

				-- Installed but invalid names, need to install manually via mason (no lspconfig integration?! idk)
				-- "clang-format",
				-- "cmake-language-server",
				-- "debugpy",
				-- "ltex-ls",
				-- "mypy",
				-- "python-lsp-server",
				-- "typescript-language-server",
				-- "vue-language-server",

				-- "codelldb"
			}
		})


		local lsp_status = require("lsp-status")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("keep", capabilities, lsp_status.capabilities)
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		capabilities.textDocument.completion.completionItem.detailSupport = true
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		local lsps = mason_lspconfig.get_installed_servers()
		for _, server in pairs(lsps) do
			local opts = {
				on_attach = lsp_server_on_attach,
				capabilities = capabilities,
			}

			-- make vue work with ts_ls
			if server == "ts_ls" then
				opts.init_options = {
					plugins = { -- I think this was my breakthrough that made it work
						{
							name = "@vue/typescript-plugin",
							location = vim.fn.stdpath("data") ..
								"/mason/packages/vue-language-server/node_modules/@vue/language-server",
							languages = { "vue" },
						},
					},
				}
				opts.filetypes = {
					"typescript",
					"javascript",
					"javascriptreact",
					"typescriptreact",
				}
			end

			local has_custom_opts, server_custom_opts = pcall(require, "plugins.lsp.settings." .. server)
			if has_custom_opts then
				opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
				-- vim.notify("[LSP-Installer] Custom options for " .. server .. " loaded")
			else
				-- print("[LSP-Installer] NO custom options for " .. server .. " found")
			end

			if server == "rust_analyzer" then
				-- TODO: for some reason setting capabilities breaks LSP
				opts.capabilities = {}
			end

			if server == "clangd" then
				-- Fixes annoying warning
				-- See: https://github.com/neovim/nvim-lspconfig/issues/2184#issuecomment-1273705335
				opts.capabilities.offsetEncoding = 'utf-16'

				-- clangd needs some extra options
				opts.cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--all-scopes-completion",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				}
				opts.init_options = {
					completeUnimported = true,
					clangdFileStatus = true,
					usePlaceholders = true,
					inlayHints = {
						variableTypes = true,
						functionReturnTypes = true,
						parameterNames = true,
						includeInlayEnumMemberValueHints = true,
					},
				}
			end
			vim.lsp.config(server, opts)
			vim.lsp.enable(server)
		end


		local signs = {
			{ name = "DiagnosticSignError", text = "" },
			{ name = "DiagnosticSignWarn", text = "" },
			{ name = "DiagnosticSignHint", text = "" },
			{ name = "DiagnosticSignInfo", text = "" },
		}

		for _, sign in ipairs(signs) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
		end

		local config = {
			-- disable virtual text
			virtual_text = {
				virt_text_pos = "eol",
			},

			-- show signs
			signs = {
				active = signs,
			},
			update_in_insert = true,
			underline = true,
			severity_sort = true,
			float = {
				focusable = true,
				style = "minimal",
				border = "none",
				source = "always",
				header = "",
				prefix = "",
			},
		}

		vim.diagnostic.config(config)

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
		})

		vim.lsp.inlay_hint.enable(true);
	end
}
