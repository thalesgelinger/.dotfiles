-- Debug completion setup
-- Add this to your init.lua temporarily to debug completion issues

local function debug_completion()
    print("=== Blink.cmp Debug Info ===")
    
    -- Check if blink.cmp is loaded
    local blink_ok, blink = pcall(require, 'blink.cmp')
    if not blink_ok then
        print("❌ blink.cmp not loaded")
        return
    end
    print("✅ blink.cmp loaded")
    
    -- Check LSP clients
    local clients = vim.lsp.get_active_clients()
    if #clients == 0 then
        print("❌ No LSP clients active")
    else
        print("✅ Active LSP clients:")
        for _, client in ipairs(clients) do
            print("  - " .. client.name)
        end
    end
    
    -- Check completion sources
    print("📋 Available completion sources:")
    local sources = blink.get_completion_sources()
    if sources then
        for _, source in ipairs(sources) do
            print("  - " .. source)
        end
    end
    
    -- Check if completion is enabled
    print("🔧 Completion enabled:", blink.is_completion_enabled())
end

-- Create command to run debug
vim.api.nvim_create_user_command('DebugCompletion', debug_completion, {})

-- Auto-run on file open
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*.ts,*.js,*.lua',
    callback = function()
        vim.defer_fn(function()
            print("File opened, checking completion...")
            debug_completion()
        end, 1000)
    end,
    once = true
})