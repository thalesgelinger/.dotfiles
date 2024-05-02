return {
    'BenGH28/neo-runner.nvim',
    config = function()
        -- NeoRunner
        vim.g.runner_cpp_compiler = 'g++'
        vim.g.runner_c_compiler = 'gcc'
        vim.g.runner_c_options = '-std=c99 -Wall'
        vim.g.runner_cpp_options = '-std=c++11 -Wall'

        vim.keymap.set("n", '<leader>r', "<cmd>NeoRunner<CR>")
    end
}
