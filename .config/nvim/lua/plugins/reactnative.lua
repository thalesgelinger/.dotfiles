
return {
    --"thalesgelinger/reactnative.nvim",
    name = "reactnative.nvim",
    dir = "/Users/tgelin01/Projects/reactnative.nvim",
    dev = true,
    -- dependencies = { },
    config = function()
        local rn = require "reactnative"
        vim.keymap.set('n', '<leader>es', rn.sync_page)
    end
}
