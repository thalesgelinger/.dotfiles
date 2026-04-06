local function getApp(spec)
    if spec.path then
        local appName = hs.fs.displayName(spec.path)
        return hs.application.get(appName)
    end

    if spec.bundleID then
        return hs.application.get(spec.bundleID)
    end

    return hs.application.get(spec.name)
end

local function launchOrFocusApp(spec)
    if spec.path then
        hs.application.launchOrFocus(spec.path)
        return
    end

    if spec.bundleID then
        hs.application.launchOrFocusByBundleID(spec.bundleID)
        return
    end

    hs.application.launchOrFocus(spec.name)
end

local function toggleFloatingApp(spec)
    local app = getApp(spec)

    if not app then
        launchOrFocusApp(spec)

        hs.timer.doAfter(0.6, function()
            local launchedApp = getApp(spec)
            local win = launchedApp and launchedApp:mainWindow()
            if win then
                win:setSize(hs.geometry.size(800, 600))
                win:centerOnScreen()
            end
        end)

        return
    end

    local mainWindow = app:mainWindow()
    if not mainWindow then
        launchOrFocusApp(spec)

        hs.timer.doAfter(0.6, function()
            local win = app and app:mainWindow()
            if win then
                win:setSize(hs.geometry.size(800, 600))
                win:centerOnScreen()
            end
        end)

        return
    end

    if app:isFrontmost() then
        app:hide()
        return
    end

    launchOrFocusApp(spec)

    hs.timer.doAfter(0.4, function()
        local focusedApp = getApp(spec) or app
        local win = focusedApp and focusedApp:mainWindow()
        if win then
            win:setSize(hs.geometry.size(800, 600))
            win:centerOnScreen()
        end
    end)
end

hs.hotkey.bind({ "alt" }, "g", function()
    toggleFloatingApp({ name = "ChatGPT" })
end)

hs.hotkey.bind({ "alt" }, "c", function()
    toggleFloatingApp({ name = "Claude" })
end)

hs.hotkey.bind({ "alt" }, "n", function()
    toggleFloatingApp({ name = "Obsidian" })
end)

hs.hotkey.bind({ "alt" }, "y", function()
    toggleFloatingApp({
        path = os.getenv("HOME") .. "/Applications/Google Tradutor.app" })
end)
