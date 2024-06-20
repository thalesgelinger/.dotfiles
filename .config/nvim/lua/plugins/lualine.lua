return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true },
    config = function()
        require('lualine').setup({
            options = {
                theme = 'tokyonight',
            },
            sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 4,
                    }
                }
            }
        })
    end
}
