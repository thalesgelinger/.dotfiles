return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local telescope = require('telescope')
        telescope.setup {
            defaults = {
                file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
                grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
                qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
                prompt_prefix = "> ",
                selection_caret = "> ",
                layout_strategy = "vertical",
            },
            find_files = {
                theme = "dropdown"
            }

        }

        telescope.load_extension("git_worktree")

        local builtin = require('telescope.builtin')
        vim.keymap.set("n", '<leader>ff', builtin.find_files, {})
        vim.keymap.set("n", '<leader>fg', builtin.live_grep, {})
        vim.keymap.set("n", '<leader>fw', builtin.grep_string, {})
        vim.keymap.set("n", '<leader>fh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>')
        vim.keymap.set('n', '<leader>fl', '<cmd>Telescope lsp_references<CR>')
        -- vim.fn.expand("<cword>")
        vim.keymap.set("n", '<leader>fc', '<cmd>Telescope git_commits<CR>')
        vim.keymap.set("n", '<leader>fb', '<cmd>Telescope git_branches<CR>')

        -- git worktree
        vim.keymap.set("n", '<leader>ws', telescope.extensions.git_worktree.git_worktrees)
        vim.keymap.set("n", '<leader>wa', telescope.extensions.git_worktree.create_git_worktree)
    end
}
