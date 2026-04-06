function setup_swift()
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
            -- lua_ls = {},
            ts_ls = {},
            svelte = {},
            rust_analyzer = {
                diagnostics = {
                    enable = true,
                }
            },
            zls = {},
            clangd = {},
            biome = {},
            superhtml = {
                cmd = { os.getenv("HOME") .. "/.local/bin/superhtml", "lsp" },
            },
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
            },
            elixirls = {
                cmd = { os.getenv("HOME") .. "/Projects/lsp/elixir/language_server.sh" },
            },
            tailwindCSS = {
                filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html", "htmlangular", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ" },
                settings = {
                    tailwindCSS = {
                        experimental = {
                            classRegex = {
                                "tw`([^`]*)",
                                'tw\\("([^"]*)'
                            }
                        }
                    },
                    includeLanguages = {
                        eelixir = "html-eex",
                        elixir = "phoenix-heex",
                        eruby = "erb",
                        heex = "phoenix-heex",
                        htmlangular = "html",
                        templ = "html"
                    },
                }
            },
            tinymist = {},
            rover_lsp = {},
        }
    },
    config = function(_, opts)
        vim.lsp.set_log_level('INFO')

        local function rover_root_dir(bufnr, on_dir)
            local path = vim.api.nvim_buf_get_name(bufnr)
            if path == '' then
                on_dir(vim.uv.cwd())
                return
            end
            local util = vim.fs
            local git_files = util.find('.git', { path = path, upward = true })
            if git_files and #git_files > 0 then
                on_dir(util.dirname(git_files[1]))
                return
            end
            on_dir(vim.uv.cwd())
        end

        local default_capabilities = require('blink.cmp').get_lsp_capabilities()
        vim.lsp.config('*', { capabilities = default_capabilities })

        local function apply_capabilities(config)
            if config.capabilities then
                local capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                return vim.tbl_deep_extend('force', {}, config, { capabilities = capabilities })
            end
            return config
        end

        local rover_defaults = {
            cmd = { 'rover', 'lsp' },
            filetypes = { 'lua' },
            root_dir = rover_root_dir,
        }

        local rover_config = rover_defaults
        if opts.servers.rover_lsp then
            rover_config = vim.tbl_deep_extend('force', rover_defaults, opts.servers.rover_lsp)
        end
        vim.lsp.config('rover_lsp', apply_capabilities(rover_config))

        -- Enable virtual text and warnings
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = false,
        })

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
                vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ open_in_tab = true }) end, opts)
                -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            end,
        })

        local server_names = {}
        for server, config in pairs(opts.servers) do
            config = config or {}
            if server ~= 'rover_lsp' then
                vim.lsp.config(server, apply_capabilities(config))
            end
            table.insert(server_names, server)
        end

        vim.lsp.enable(server_names)

        vim.api.nvim_create_user_command('TestRover', function()
            local cmd = { 'rover', 'lsp' }
            vim.notify('Testing command: ' .. vim.inspect(cmd), vim.log.levels.INFO)
            local handle = io.popen(table.concat(cmd, ' ') .. ' 2>&1 &')
            if handle then
                vim.notify('Command started successfully', vim.log.levels.INFO)
                handle:close()
            else
                vim.notify('Failed to run command test', vim.log.levels.ERROR)
            end
        end, {})

        setup_swift()
    end
}

