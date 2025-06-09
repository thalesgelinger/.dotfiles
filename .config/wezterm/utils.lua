function table.merge(table1, table2)
    for _, v in ipairs(table2) do
        table.insert(table1, v)
    end
end

local function write_to_file(path, content)
    local file = io.open(path, "w")
    if file then
        file:write(content)
        file:close()
        wezterm.log_info("Content written to " .. path)
    else
        wezterm.log_error("Failed to open file for writing: " .. path)
    end
end

local Workspaces = {}

function Workspaces.write_table_to_file(data)
  local json_data = wezterm.json_encode(data) -- Convert the table to JSON
  write_to_file(json_data) -- Use the earlier `write_to_file` function
end
