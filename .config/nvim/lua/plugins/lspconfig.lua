return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'folke/neodev.nvim'
    },

    config = function()
        -- Setup neovim lua configuration
        require("neodev").setup({})

        -- Setup capabilities
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        -- Setup on_attach function
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, remap = false }
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end

        -- Configure diagnostics
        vim.diagnostic.config({
            virtual_text = true,
        })

        -- Initialize lspconfig
        local lspconfig = require('lspconfig')

        -- Setup mason
        require('mason').setup({})

        -- Setup mason-lspconfig
        require('mason-lspconfig').setup({
            ensure_installed = {
                "lua_ls", "svelte", "volar", "gopls", "clangd",
                "html", "htmx", "rust_analyzer", "elixirls"
            },
            automatic_installation = true,
        })

        -- Helper function to setup servers with base config and overrides
        local function setup_server(server, config)
            local server_config = {
                on_attach = on_attach,
                capabilities = capabilities,
            }

            -- Merge additional configs if provided
            if config then
                for k, v in pairs(config) do
                    server_config[k] = v
                end
            end

            lspconfig[server].setup(server_config)
        end

        -- Setup default handlers for mason servers
        require('mason-lspconfig').setup_handlers({
            function(server_name)
                setup_server(server_name)
            end,
        })

        -- Specific server configurations

        -- htmx for HTML files
        setup_server("htmx", {
            filetypes = { "html" },
        })

        -- rust_analyzer with cargo features
        setup_server("rust_analyzer", {
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        features = "all",
                    },
                },
            },
        })

        -- kotlin_language_server with custom config
        setup_server("kotlin_language_server", {
            root_dir = lspconfig.util.root_pattern(".kts", ".git"),
            cmd = { "kotlin-language-server" },
            settings = {
                kotlin = {
                    compiler = {
                        jars = { "/Users/tgelin01/.asdf/installs/kotlin/1.9.21/kotlinc/lib/kotlin-script-runtime.jar" },
                    },
                },
            },
        })

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
                })
                vim.lsp.buf_attach_client(0, client)
            end,
            group = swift_lsp,
        })
    end
}
