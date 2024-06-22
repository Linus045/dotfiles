local function lsp_keymaps(_client, bufnr)
	local keymap = require("custom_tools.keybindings_util").keymap
	local opts = { noremap = true, silent = true }
	-- local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	keymap("n", "gq", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts, "Type Defintions", nil, nil, bufnr)
	keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts, "Goto Declaration", nil, nil, bufnr)
	keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts, "Goto Definition", nil, nil, bufnr)
	-- TODO: Causes problems with :Man (jumping to references no longer works)
	-- Workaround use Ctrl+] to jump
	keymap("n", "K", function()
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
		if filetype == "rust" and require("custom_tools.termdebug_helper").in_debug_session then
			vim.cmd("Evaluate")
		elseif filetype == "man" then
			vim.notify("TODO: put correct action here")
		else
			vim.lsp.buf.hover()
		end
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
	keymap("n", "gh", '<cmd>ClangdSwitchSourceHeader<CR>', opts, "Switch between source/header file", nil, nil, bufnr)

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
		vim.notify('File handlers.lua: nvim-navbuddy not found.')
		return
	end
	navbuddy.attach(client, bufnr)
end


-- autoinstall lsp server
return {
	"williamboman/mason.nvim",
	dependencies = {
		-- mason lsp config extension
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"nvim-lua/lsp-status.nvim",
		"folke/which-key.nvim"
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
				"tsserver",
				-- "gopls",
				-- "volar",
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
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("keep", capabilities, lsp_status.capabilities)
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)


		local lsps = mason_lspconfig.get_installed_servers()
		for _, server in pairs(lsps) do
			local opts = {
				on_attach = lsp_server_on_attach,
				capabilities = capabilities,
			}
			opts.capabilities = vim.tbl_extend('keep', opts.capabilities or {}, lsp_status.capabilities)

			local has_custom_opts, server_custom_opts = pcall(require, "plugins.lsp.settings." .. server)
			if has_custom_opts then
				opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
				-- vim.notify("[LSP-Installer] Custom options for " .. server .. " loaded")
			else
				-- print("[LSP-Installer] NO custom options for " .. server .. " found")
			end

			if server == "clangd" then
				-- Fixes annoying warning
				-- See: https://github.com/neovim/nvim-lspconfig/issues/2184#issuecomment-1273705335
				opts.capabilities.offsetEncoding = 'utf-16'
			end

			lspconfig[server].setup(opts)
			-- vim.notify("[LSP-Installer] " .. server .. " loaded")
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
	end
}
