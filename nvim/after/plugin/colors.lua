function ColorNeovim(color)
    color = color or "rose-pine-main"
    vim.cmd.colorscheme(color)


    vim.api.nvim_set_hl(0 , "Normal", { bg = 'none' })
    vim.api.nvim_set_hl(0 , "NormalFloat", { bg = 'none' })

    vim.api.nvim_set_hl(0 , "StatusLine", { bg = 'none' })
    vim.api.nvim_set_hl(0 , "SignColumn", { bg = 'none' })

    vim.api.nvim_set_hl(0 , "VertSplit", { bg = 'none' })
end

ColorNeovim()
--vim.cmd.colorscheme('peachpuff')
