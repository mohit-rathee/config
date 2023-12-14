local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

        --vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
        --vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
        --vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    end
})

local default_setup = function(server)
    lspconfig[server].setup({})
end

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = { default_setup },
})
local cmp = require('cmp')
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip'  },
        { name = 'buffer'   },
    },
    mapping = cmp.mapping.preset.insert({
        -- Enter key confirms completion item
        --['<Tab>'] = cmp.mapping.confirm({select=true}),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        --['<Tab-l>'] = cmp.mapping.scroll_docs(4),
        --['<Tab-h>'] = cmp.mapping.scroll_docs(-4),
        ['<CR>'] = cmp.mapping.abort(),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})
lspconfig.pyright.setup({
    -- Other setup options...
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",  -- Adjust type checking mode if needed
            },
            useLibraryCodeForTypes = true,  -- Use library code for types
        },
        pyright = {
            usePyrightrc = false,  -- Disable pyrightrc file if you want to use the global settings
        },
    },
})
