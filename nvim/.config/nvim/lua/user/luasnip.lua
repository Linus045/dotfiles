local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
  vim.notify("luasnip not found")
  return
end

local status_ok2, types = pcall(require, "luasnip.util.types")
if not status_ok2 then
  vim.notify("luasnip.util.types not found")
  return
end

ls.config.set_config {
  history = true,
  update_events = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = {{"<-","CHOICE HERE"}},
      }
    }
  }
}

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

ls.add_snippets("all",{
})

ls.add_snippets("lua",{
  s("pcall_check_expand", {
    t("local status_ok, "), i(1, "module_name"), t(" = pcall(require, '"), i(2, "module_name"),t("')"),
    t({"", "if not status_ok then"}),
    t({"","  vim.notify('File "}), l(l.TM_FILENAME), t(": "), i(3, "module_name"), t(" not found.')"),
    t({"", "  return"}),
    t({"", "end"})
  }),
})

