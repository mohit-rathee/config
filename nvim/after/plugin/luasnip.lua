-- Lazy load friendly snippets from vscode-snippet style
require("luasnip.loaders.from_vscode").lazy_load()

-- Define a simple LuaSnip snippet for a function
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Example snippet for a function
ls.add_snippets("lua", {
    s("fun", {
        t("function "), i(1, "name"), t("("), i(2, "args"), t(")"),
        t({ "", "\t" }), i(3, "body"), t({ "", "end" })
    })
})
ls.add_snippets("typescriptreact", {
    s("useEffect", {
        t("useEffect(() => { "),
        t({ "", "\t" }), i(1, "Effect"),
        t({ "", "" }), t(" }, ["), i(2, "dependencies"), t("]);")
    })
})

-- Key mappings for expanding or jumping between snippet placeholders
-- vim.keymap.set("i", "<CR>", function() ls.expand_or_jump() end, { noremap = true })
-- vim.keymap.set("i", "<S-Tab>", function() ls.jump(-1) end, { noremap = true })
vim.keymap.set("s", "<CR>", function() ls.expand_or_jump() end, { noremap = true })
vim.keymap.set("i", "<C-J>", function() ls.jump(1) end, { noremap = true })
vim.keymap.set("i", "<C-K>", function() ls.jump(-1) end, { noremap = true })
