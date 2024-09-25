-- Apple note dump
vim.keymap.set("n", "<C-n>", function()
    vim.ui.input({ prompt = 'Dump note: ' }, function(body)
        if body ~= nil then
            vim.cmd(string.format("silent !dump \"%s\"", body))
        end
    end)
end)

local function loveRun(opts)
    vim.fn.system("open -n -a love .")
end

vim.api.nvim_create_user_command('Love', loveRun, { nargs = "*" })

vim.keymap.set("n", "<leader>ll", loveRun)
