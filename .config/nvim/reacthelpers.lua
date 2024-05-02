local function file_exists(name)
    local f = io.open(name, "r")
    return f ~= nil and io.close(f)
end

local function add_to_styles_as_view()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local component_name = vim.fn.expand("<cword>")
    local current_path = vim.fn.getcwd() .. "/" .. vim.fn.expand('%:h') .. "/styles.ts"

    local styled = "export const " .. component_name .. " = styled.View``"

    if not file_exists(current_path) then
        vim.cmd("!echo import styled from \\'styled-components/native\\' >> " .. current_path)
    end

    vim.cmd("!echo " .. styled .. " >> " .. current_path)

    local ok = pcall(vim.cmd, "%s/\\} from '.\\/styles'/, " .. component_name .. " } from '.\\/styles'")

    if not ok then
        local current_buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_lines(current_buf, 1, 1, false, { "import { " .. component_name .. " } from './styles'" })
    end

    vim.api.nvim_win_set_cursor(0, { line, 1 })
end

vim.keymap.set("n", "<leader>sv", add_to_styles_as_view)

