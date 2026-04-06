-- Apple note dump
vim.keymap.set("n", "<C-n>", function()
    vim.ui.input({ prompt = 'Dump note: ' }, function(body)
        if body ~= nil then
            vim.cmd(string.format("silent !dump \"%s\"", body))
        end
    end)
end)

vim.keymap.set("n", "<leader>p", function()
  local oil = require("oil")
  local image = require("image")

  -- get absolute path of the file under cursor
  local entry = oil.get_cursor_entry()
  if not entry then
    vim.notify("No file under cursor", vim.log.levels.WARN)
    return
  end
  local path = oil.get_current_dir() .. entry.name

  -- render image
  image.display(path, {
    win = 0,
  })
end, { desc = "Render image under cursor with image.nvim", buffer = true })

