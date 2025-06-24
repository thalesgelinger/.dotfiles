return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'MunifTanjim/prettier.nvim',
        "saghen/blink.cmp",
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    },

    opts = {
        servers = {
            lua_ls = {},
            ts_ls = {},
            elixirls = {
                cmd = { os.getenv("HOME") .. "/Projects/lsp/elixir/language_server.sh" },
            },
            tailwindCSS = {
                settings = {
                    tailwindCSS = {
                        experimental = {
                            classRegex = {
                                "tw`([^`]*)",
                                'tw\\("([^"]*)'
                            }
                        }
                    }
                }
            }
        }
    },
    config = function(_, opts)
        local lspconfig = require('lspconfig')

        -- Setup LSP keybindings when LSP attaches
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            end,
        })

        for server, config in pairs(opts.servers) do
            -- passing config.capabilities to blink.cmp merges with the capabilities in your
            -- `opts[server].capabilities, if you've defined it
            config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
        end

        -- HTML file type for .leaf files
        vim.cmd [[ autocmd BufRead,BufNewFile *.leaf set filetype=html ]]

        -- Swift LSP setup using the native LSP client
        local swift_lsp = vim.api.nvim_create_augroup("swift_lsp", { clear = true })
        vim.api.nvim_create_autocmd("filetype", {
            pattern = { "swift" },
            callback = function()
                local root_dir = vim.fs.dirname(vim.fs.find({
                    "package.swift",
                    ".git",
                }, { upward = true })[1])
                local client = vim.lsp.start({
                    name = "sourcekit-lsp",
                    cmd = { "sourcekit-lsp" },
                    root_dir = root_dir,
                    capabilities = require('blink.cmp').get_lsp_capabilities(),
                })
                vim.lsp.buf_attach_client(0, client)
            end,
            group = swift_lsp,
        })
    end
}
