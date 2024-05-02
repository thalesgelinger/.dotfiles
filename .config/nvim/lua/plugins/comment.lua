return {
    "terrortylor/nvim-comment",
    config = function()
        require('nvim_comment').setup()
        -- Comment
        vim.keymap.set("n", '<leader>/', '<cmd>CommentToggle<CR>')
        vim.keymap.set("v", '<leader>/', '<cmd>CommentToggle<CR>')
    end
}
