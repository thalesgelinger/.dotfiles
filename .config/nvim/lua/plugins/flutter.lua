return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
        local H = os.getenv("HOME")
        require("flutter-tools").setup({
            flutter_path = H .. "/.asdf/shims/flutter",
            lsp = {
                cmd = { H .. "/.asdf/shims/dart", "language-server", "--protocol=lsp" },
            },
        })
    end,
}
