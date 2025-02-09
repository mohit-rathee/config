local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

local float_opts = {
    border = "rounded", -- Apply rounded borders globally to all LSP floating windows
}

vim.diagnostic.config({
    float = float_opts,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, float_opts
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, float_opts
)

lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
})
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set('n', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
        vim.keymap.set('n', 'gp', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
        vim.keymap.set('n', 'gn', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    end
})

local default_setup = function(server)
    lspconfig[server].setup({})
end

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = { default_setup },
})

lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                    ["/usr/share/awesome/lib"] = true,
                },
                checkThirdParty = false,
            },
            diagnostics = {
                globals = { "awesome", "client", "root", "screen" },
            },
        },
    }
}

lspconfig.pylsp.setup({
    filetypes = { "htmldjango" },
    settings = {
        pylsp = {
            plugins = {
                pylint = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = {
                    enabled = true,
                    ignore = {
                        'W', -- Suppress all warnings
                    },
                },
            },
        }
    }
})

lspconfig.rust_analyzer.setup {
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = true,
            }
        }
    }
}

lspconfig.html.setup {
    filetypes = { "htmldjango", "html" },
    settings = {
        ['html'] = {
            diagnostics = {
                enable = true,
            }
        }
    }
}
