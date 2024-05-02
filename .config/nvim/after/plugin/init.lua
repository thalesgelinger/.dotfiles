-- Apple note dump
vim.keymap.set("n", "<C-n>", function()
    vim.ui.input({ prompt = 'Dump note: ' }, function(body)
        if body ~= nil then
            vim.cmd(string.format("silent !dump \"%s\"", body))
        end
    end)
end)
