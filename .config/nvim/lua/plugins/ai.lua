return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("codecompanion")
        vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionActions<CR>")
        vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat<CR>")
        vim.keymap.set("v", "<leader>ae", ":<C-u>'<,'>CodeCompanion ", { silent = false, noremap = true })
    end
}
