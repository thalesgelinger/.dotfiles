return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "williamboman/mason.nvim",
        "nvim-neotest/nvim-nio"
    },
    config = function()
        local dap = require "dap"
        local ui = require "dapui"

        ui.setup()

        dap.configurations.lua = {
            {
                name = 'Current file (local-lua-dbg, lua)',
                type = "executable",
                command = "node",
                args = {
                    os.getenv("HOME") .. "/Projects/local-lua-debugger-vscode/extension/debugAdapter.js"
                },
                request = 'launch',
                cwd = '${workspaceFolder}',
                -- program = {
                --     lua = 'lua5.1',
                --     file = '${file}',
                -- },
                -- enrich_config = function(config, on_config)
                --     if not config["extensionPath"] then
                --         local c = vim.deepcopy(config)
                --         -- 💀 If this is missing or wrong you'll see
                --         -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
                --         c.extensionPath = os.getenv("HOME") .. "/Projects/local-lua-debugger-vscode"
                --         on_config(c)
                --     else
                --         on_config(config)
                --     end
                -- end,
            },
        }
    end
}
