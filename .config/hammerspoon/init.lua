require "toggle-apps"

local function exec(cmd)
    local output, status, type, rc = hs.execute(cmd)
end

hs.hotkey.bind({ "alt" }, "O", function()
    exec("open cleanshot://capture-text")
end)

hs.hotkey.bind({ "alt" }, "R", function()
    hs.reload()
end)

hs.alert.show("Config loaded!")
