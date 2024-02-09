require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "javascript", "python", "rust", "lua", "vim", "vimdoc", "query" },
    sync_install = false,
    auto_install = true,
    autopairs = {
        enable = true,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
    },
}
