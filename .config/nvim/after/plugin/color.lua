function defaultTransparent()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.cmd.colorscheme "tokyonight"

    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#dedede', bold = false })
    vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white', bold = false })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#dedede', bold = false })
end

local is_transparent = true

-- Toggle Transparent Background
vim.keymap.set("n", "<leader>bb", function()
    if is_transparent then
        vim.cmd.colorscheme "tokyonight"
        vim.api.nvim_set_hl(0, "Normal", { bg = "#24283b" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#24283b" })
        is_transparent = false
    else
        defaultTransparent()
        is_transparent = true
    end
end)

defaultTransparent()
