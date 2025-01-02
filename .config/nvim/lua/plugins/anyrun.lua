return {
    "thalesgelinger/anyrun.nvim",
    config = function()
        local anyrun = require "anyrun"
        anyrun.setup {
            lua = { "lua" }
        }
        vim.keymap.set("n", "<leader>rr", anyrun.execute)
    end
}
