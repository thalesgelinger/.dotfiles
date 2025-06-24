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

        -- telescope.load_extension("git_worktree")

        local function get_visual_selection()
            local _, ls, cs = table.unpack(vim.fn.getpos("v"))
            local _, le, ce = table.unpack(vim.fn.getpos("."))

            if le < ls or (le == ls and ce < cs) then
                ls, le = le, ls
                cs, ce = ce, cs
            end

            local lines = vim.fn.getline(ls, le)
            if #lines == 0 then return "" end

            lines[#lines] = lines[#lines]:sub(1, ce)
            lines[1] = lines[1]:sub(cs)

            return table.concat(lines, "\n")
        end

        local builtin = require('telescope.builtin')
        vim.keymap.set("n", '<leader>ff', builtin.find_files, {})
        vim.keymap.set("n", '<leader>fg', builtin.live_grep, {})
        vim.keymap.set("n", '<leader>fw', builtin.grep_string, {})
        vim.keymap.set("n", '<leader>fh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>')
        vim.keymap.set('n', '<leader>fl', '<cmd>Telescope lsp_references<CR>')
        vim.keymap.set('v', '<leader>fs', function() builtin.live_grep({ default_text = get_visual_selection() }) end)
        -- vim.fn.expand("<cword>")
        vim.keymap.set("n", '<leader>fc', '<cmd>Telescope git_commits<CR>')
        vim.keymap.set("n", '<leader>fb', '<cmd>Telescope git_branches<CR>')


        local function find_js_files()
            builtin.live_grep({
                prompt_title = "Search JavaScript Files (excluding test files)",
                additional_args = function(opts)
                    return { '--glob', '!*.spec.js', '--glob', '!*.test.js', '--glob', '!*.spec.ts', '--glob',
                        '!*.test.ts' }
                end,
            })
        end

        vim.keymap.set('n', '<leader>fj', find_js_files)

        -- git worktree
        -- vim.keymap.set("n", '<leader>ws', telescope.extensions.git_worktree.git_worktrees)
        -- vim.keymap.set("n", '<leader>wa', telescope.extensions.git_worktree.create_git_worktree)
    end
}
