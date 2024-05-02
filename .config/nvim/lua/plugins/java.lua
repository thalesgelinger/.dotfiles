return {
    'mfussenegger/nvim-jdtls',
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "java" },
            callback = function()
                require('jdtls').start_or_attach({
                    cmd = { 'jdtls' },
                    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
                })
            end,
        })
    end
}
