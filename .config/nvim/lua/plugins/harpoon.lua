return {
    'ThePrimeagen/harpoon',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
        local hmark = require("harpoon.mark")
        local hui = require("harpoon.ui")
        vim.keymap.set("n", '<leader>m', hmark.add_file)
        vim.keymap.set("n", '<leader>h', hui.toggle_quick_menu)
        vim.keymap.set('n', '<C-g>', hui.nav_next)
        vim.keymap.set('n', '<C-f>', hui.nav_prev)

        vim.keymap.set('n', '<C-j>', function() hui.nav_file(1) end)
        vim.keymap.set('n', '<C-k>', function() hui.nav_file(2) end )
        vim.keymap.set('n', '<C-l>', function() hui.nav_file(3) end )
        vim.keymap.set('n', '<C-;>', function() hui.nav_file(4) end )
    end
}
