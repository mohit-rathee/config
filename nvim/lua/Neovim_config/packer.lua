-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' -- Packer can manage itself
    -- very important plugins.
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4', -- or , branch = '0.1.x',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    use { 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' } }
    use { 'nvim-treesitter/playground' } -- to inspect treesitter

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use { 'JoosepAlviste/nvim-ts-context-commentstring' }
    -- good plugins
    use { "catppuccin/nvim", as = "catppuccin" }
    use { "rebelot/kanagawa.nvim", as = "kanagawa" }
    use { 'rose-pine/neovim', as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end }
    use { 'theprimeagen/harpoon' }
    use { 'mbbill/undotree' }
    use { 'tpope/vim-fugitive' }
    use { 'christoomey/vim-tmux-navigator' }
    use { 'windwp/nvim-autopairs' }

    -- Github Copilot
    -- use {'github/copilot.vim'}

    -- LSP saga
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- lsp support
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'neovim/nvim-lspconfig' },
            -- autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            -- snippets
            { "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
            }
        }
    }

    -- debugging
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'
    use 'simrat39/rust-tools.nvim'
    use 'nvim-telescope/telescope-dap.nvim'

    use { 'kyazdani42/nvim-tree.lua' }
    use { 'kyazdani42/nvim-web-devicons' }
    -- for vim plugins development
    use { 'folke/neodev.nvim' }
    use { 'nanotee/luv-vimdocs' }
    use { 'milisims/nvim-luaref' }
    use { 'markonm/traces.vim' }

    -- personal
    --use '/home/Arch/code/neovim_plugins/Explorer.nvim'
end)
