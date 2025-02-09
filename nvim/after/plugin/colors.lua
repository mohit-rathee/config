function ColorNeovim(color, bool)
    color = color or "catppuccin-macchiato"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "NormalFloat", { bg = 'none' })
    -- Set transparency for the active pane
    if (bool) then
        vim.api.nvim_set_hl(0, "Normal", { bg = 'none' })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = 'none' })
        vim.api.nvim_set_hl(0, "VertSplit", { bg = 'none' })
        vim.api.nvim_set_hl(0, "StatusLine", { bg = 'none' })
        vim.api.nvim_set_hl(0, "TabLine", { bg = 'none' })
        vim.api.nvim_set_hl(0, "TabLineFill", { bg = 'none' })


        -- Set transparency for the inactive pane
        vim.api.nvim_set_hl(0, "NormalNC", { bg = 'none' })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = 'none' })
        vim.api.nvim_set_hl(0, "VertSplitNC", { bg = 'none' })
        vim.api.nvim_set_hl(0, "LineNr", { bg = 'none', fg = 'gray' })
        vim.api.nvim_set_hl(0, "CursorLineNr", { bg = 'none' })
        vim.api.nvim_set_hl(0, "FoldColumn", { bg = 'none' })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = 'none' })

        -- Set transparency for NvimTree
        vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = 'none' })
        vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = 'none' })
        vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = 'none' })
        vim.api.nvim_set_hl(0, "NvimTreeStatusLine", { bg = 'none' })
        vim.api.nvim_set_hl(0, "NvimTreeStatusLineNC", { bg = 'none' })
        vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = 'none', fg = 'gray' })
    end
end

ColorNeovim("catppuccin-macchiato",true)
