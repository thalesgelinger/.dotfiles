return {
    "jmbuhr/otter.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        buffers = {
            set_filetype = true,
            write_to_disk = false,
        },
        handle_leading_whitespace = true,
    },
    config = function(_, opts)
        local otter = require("otter")
        otter.setup(opts)

        -- Auto-activate otter for lua files with html injections
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "lua" },
            callback = function()
                -- Activate otter for html injections, use superhtml
                otter.activate({ "html" }, true, true, nil)
            end,
        })

        -- Attach superhtml to otter html buffers
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "html" },
            callback = function(ev)
                local bufname = vim.api.nvim_buf_get_name(ev.buf)
                if bufname:match("otter") then
                    vim.lsp.start({
                        name = "superhtml",
                        cmd = { os.getenv("HOME") .. "/.local/bin/superhtml", "lsp" },
                        root_dir = vim.fn.getcwd(),
                    })
                end
            end,
        })

        -- Keymaps for otter
        vim.keymap.set("n", "<leader>od", function()
            require("otter").ask_definition()
        end, { desc = "Otter definition" })

        vim.keymap.set("n", "<leader>oh", function()
            require("otter").ask_hover()
        end, { desc = "Otter hover" })

        vim.keymap.set("n", "<leader>or", function()
            require("otter").ask_references()
        end, { desc = "Otter references" })

        -- Format injected HTML with superhtml
        vim.keymap.set("n", "<leader>of", function()
            require("otter").ask_format()
        end, { desc = "Otter format" })
    end,
}
