return {
	"L3MON4D3/LuaSnip",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "v2.3",
	build = "make install_jsregexp",
	config = function()
		local ls = require("luasnip")
		local types = require("luasnip.util.types")
		ls.config.set_config {
			history = false,
			update_events = "TextChanged,TextChangedI",
			enable_autosnippets = true,
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { "<- <C-E> to change", "CHOICE HERE" } },
					}
				}
			}
		}


		-- prevent jumping back to snippet when placeholders are skipped
		-- see https://github.com/L3MON4D3/LuaSnip/issues/258
		function leave_snippet()
			if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i') and
				ls.session.current_nodes[vim.api.nvim_get_current_buf()] and
				not ls.session.jump_active
			then
				ls.unlink_current()
			end
		end

		-- stop snippets when you leave to normal mode
		vim.api.nvim_command([[autocmd ModeChanged * lua leave_snippet()]])

		local s = ls.snippet
		local sn = ls.snippet_node
		local t = ls.text_node
		local i = ls.insert_node
		local f = ls.function_node
		local c = ls.choice_node
		local d = ls.dynamic_node
		local r = ls.restore_node
		local l = require("luasnip.extras").lambda
		local rep = require("luasnip.extras").rep
		local p = require("luasnip.extras").partial
		local m = require("luasnip.extras").match
		local n = require("luasnip.extras").nonempty
		local dl = require("luasnip.extras").dynamic_lambda
		local fmt = require("luasnip.extras.fmt").fmt
		local fmta = require("luasnip.extras.fmt").fmta
		local types = require("luasnip.util.types")
		local conds = require("luasnip.extras.expand_conditions")

		-- ls.snippets = {
		-- 	lua = {
		-- 		s("myreq", { c(1, {
		-- 			fmt("require('{}')", { r(1, 'module') }),
		-- 			fmt("local {} = require('{}')", { rep(1), r(1, 'module') })
		-- 		}
		-- 		) }, { stored = { module = i(1, "module") } })
		-- 	}
		-- }

		-- ls.add_snippets("all", {})

		ls.add_snippets("lua", {
			s("pcall_check_expand", {
				t("local status_ok, "), i(1, "module_name"), t(" = pcall(require, '"), r(2, "module_name"), t("')"),
				t({ "", "if not status_ok then" }),
				t({ "", "  vim.notify('File " }), l(l.TM_FILENAME), t(": "), rep(2, "module_name"), t(" not found.')"),
				t({ "", "  return" }),
				t({ "", "end" }),
			}, { stored = { module_name = i(1, "module_name") } }),
		})

		-- load friendly snippets
		require("luasnip/loaders/from_vscode").lazy_load()
	end
}
