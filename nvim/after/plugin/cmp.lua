-- Lazy load friendly snippets from vscode-snippet style
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require('cmp')
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
    },
    window = {
        completion = cmp.config.window.bordered({
            border = "rounded",
        }),
        documentation = cmp.config.window.bordered({
            border = "rounded",
        }),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping.select_next_item({ select = true }),
        ['<C-k>'] = cmp.mapping.select_prev_item({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-l>'] = cmp.mapping.scroll_docs(4),
        ['<C-h>'] = cmp.mapping.scroll_docs(-4),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})
