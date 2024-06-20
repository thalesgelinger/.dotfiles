function LineNumberColors()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.cmd.colorscheme "tokyonight"

    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#dedede', bold = false })
    vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white', bold = false })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#dedede', bold = false })
end

LineNumberColors()
