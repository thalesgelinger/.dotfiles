return {
    'saghen/blink.cmp',
    dependencies = {
        'rafamadriz/friendly-snippets',
        { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    },
    version = 'v0.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = 'default' },

        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
        },

        snippets = { preset = 'luasnip' },

        sources = {
            default = { "lsp", "path", "snippets", "buffer", "lazydev" },
            per_filetype = {
                sql = { 'snippets', 'dadbod', 'buffer' },
                lua = { "lsp", "path", "snippets", "buffer", "lazydev" },
            },
            providers = {
                dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
            },
        },

        completion = {
            trigger = {
                prefetch_on_insert = true,
                show_on_insert_on_trigger_character = true,
            },
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            menu = {
                enabled = true,
                min_width = 15,
                max_height = 10,
                border = 'none',
                winblend = 0,
                winhighlight =
                'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
                scrollbar = true,
                direction_priority = { 's', 'n' },
                auto_show = true,
                draw = {
                    treesitter = { "lsp" },
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                treesitter_highlighting = true,
            },
            ghost_text = {
                enabled = true,
            },
        },

        signature = {
            enabled = true,
            trigger = {
                blocked_trigger_characters = {},
                blocked_retrigger_characters = {},
                show_on_insert_on_trigger_character = true,
            },
        }
    },
    config = function(_, opts)
        require('blink.cmp').setup(opts)
    end
}
