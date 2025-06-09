require('lspconfig').tailwindcss.setup {
    filetypes = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    init_options = {
        userLanguages = {
            javascript = "javascriptreact",
            typescript = "typescriptreact"
        }
    },
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
