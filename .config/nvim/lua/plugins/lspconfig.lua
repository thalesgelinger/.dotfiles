return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        --- Uncomment these if you want to manage the language servers from neovim
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' }, -- Optional

        -- LSP Support
        { 'neovim/nvim-lspconfig' },
        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'L3MON4D3/LuaSnip' },
    },
    config = function()
        local lsp = require('lsp-zero')


        lsp.preset('recommended')

        lsp.on_attach(function(client, bufnr)
            lsp.default_keymaps({ buffer = bufnr })
        end)

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                'tsserver',
                'eslint',
                'svelte',
                'volar',
                'gopls',
                'lua_ls',
            },
            handlers = {
                lsp.default_setup,
            },
        })


        lsp.configure('svelte', { force_setup = true })
        lsp.configure('volar', { force_setup = true })
        lsp.configure('gopls', { force_setup = true })

        lsp.setup()

        vim.diagnostic.config({
            virtual_text = true,
        })

        -- (Optional) Configure lua language server for neovim
        local lspconfig = require('lspconfig')
        lspconfig.lua_ls.setup({})
        lspconfig.dartls.setup {}
        lspconfig.jdtls.setup {}
        lspconfig.clangd.setup {}
        lspconfig.htmx.setup {
            filetypes = { "html" }
        }

        lspconfig.gopls.setup({})


        lspconfig.kotlin_language_server.setup {
            root_dir = lspconfig.util.root_pattern(".kts", ".git"),
            cmd = { "kotlin-language-server" },
            -- settings = {
            --     ["kotlin-language-server"] = {
            --         kotlinHome = "/Users/tgelin01/.asdf/installs/kotlin/1.9.21",
            --         compiler = {
            --             classpath = { "/Users/tgelin01/.asdf/installs/kotlin/1.9.21/kotlinc/lib/kotlin-scripting-compiler.jar" }
            --         }
            --     },
            -- },
            settings = {
                kotlin = {
                    compiler = {
                        jars = { "/Users/tgelin01/.asdf/installs/kotlin/1.9.21/kotlinc/lib/kotlin-script-runtime.jar" },
                    },
                },
            },
        }

        vim.cmd [[ autocmd BufRead,BufNewFile *.leaf set filetype=html ]]


        lsp.on_attach(function(client, bufnr)
            local opts = { buffer = bufnr, remap = false }
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end)

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

        local cmp = require('cmp')

        cmp.setup({
            mapping = {
                -- Ctrl+Space to trigger completion menu
                ['<C-Space>'] = cmp.mapping.complete(),
            }
        })
    end
}
