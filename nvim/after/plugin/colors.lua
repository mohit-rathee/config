function ColorNeovim(color)
    color = color or "rose-pine-main"
    vim.cmd.colorscheme(color)

    -- Set transparency for the active pane
    vim.api.nvim_set_hl(0, "Normal", { bg = 'none' })
    --vim.api.nvim_set_hl(0, "NormalFloat", { bg = 'none' })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = 'none' })
    vim.api.nvim_set_hl(0, "VertSplit", { bg = 'none' })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = 'none' })

    -- Set transparency for the inactive pane
    vim.api.nvim_set_hl(0, "NormalNC", { bg = 'none' })
    --vim.api.nvim_set_hl(0, "StatusLineNC", { bg = 'none' })
    vim.api.nvim_set_hl(0, "VertSplitNC", { bg = 'none' })
end

ColorNeovim()

