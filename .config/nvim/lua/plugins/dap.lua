return {
    'mfussenegger/nvim-dap',
    config = function()
        local dap = require 'dap'
        vim.keymap.set('n', '<F5>', dap.continue)
        vim.keymap.set('n', '<F10>', dap.step_over)
        vim.keymap.set('n', '<F11>', dap.step_into)
        vim.keymap.set('n', '<F12>', dap.step_out)
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
        vim.keymap.set('n', '<leader>B', function()
            dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end)
        dap.adapters.node2 = {
          type = 'executable',
          command = 'node',
          args = {os.getenv('HOME') .. '/.config/nvim/plugged/vscode-node-debug2/out/src/nodeDebug.js'},
        }

        dap.configurations.typescriptreact = {
            {
                type = 'node2',
                request = 'attach',
                program = '${workspaceFolder}/index.js',
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                -- console = 'integratedTerminal',
                request = 'attach',
                name = 'Attach to React Native',
                protocol = 'inspector',
                host = 'localhost',
                port = 9229,
                sourceMaps = true,
                skipFiles = { '<node_internals>/**/*.js' },
                skipFilesGlob = { '<node_internals>/**/*.js' },
            },
        }

    end

}
