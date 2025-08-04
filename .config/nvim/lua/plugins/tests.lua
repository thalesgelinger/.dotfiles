return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "jfpedroza/neotest-elixir"
    },
    config = function()
        local neotest = require("neotest")
        neotest.setup({
            adapters = {
                require("neotest-elixir")
            },
            output = {
                enabled = true,
                open_on_run = false,
            },
            output_panel = {
                enabled = true,
                open = "botright split | resize 15"
            }
        })

        vim.keymap.set("n", "<leader>tt", function()
            neotest.output.open({ enter = true })
        end)

        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = { "*_test.exs" },
            callback = function()
                vim.defer_fn(function()
                    neotest.watch.toggle(vim.fn.expand("%"))
                end, 100)
            end,
        })
    end
}
