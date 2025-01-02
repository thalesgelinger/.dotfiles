return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        { 'nvim-treesitter/playground' },
    },
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
        vim.filetype.add({
            extension = {
                elua = "elua",
            },
        })

        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.elua = {
            install_info = {
                url = "/Users/tgelin01/Projects/treesitter-elua", -- Path to your grammar repo
                files = { "src/parser.c" },
            },
            filetype = "elua",
        }

        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "typescript", "lua", "rust", "svelte", "html", "cmake", "c", "query", "elua" },
            -- ensure_installed = "maintained",
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },


            playground = {
                enable = true,
                disable = {},
                updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            }

        })
    end
}
