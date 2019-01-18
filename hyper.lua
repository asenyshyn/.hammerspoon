-- -- A global variable for the Hyper Mode
-- hyperKey = hs.hotkey.modal.new()

-- local singleKeyApps = {
--   -- 'A' reserved for double key shortucts
--   {'B', 'Calibre'},
--   {'C', 'Calendar'},
--   {'E', 'Emacs'},
--   {'F', 'Finder'},
--   {'G', 'Telegram'},
--   {'K', 'Skype'},
--   {'S', 'Slack'},
--   {'M', 'Mail'},
--   {'N', 'Notes'},
--   {'P', 'MacPass'},
--   {'T', 'iTerm'},
--   {'V', 'VirtualBox'},
--   {'W', 'Safari'},
--   {'.', 'Dash'},
--   {',', 'System Preferences'},
--   {'\\', 'Amphetamine'}
-- }

-- -- alert to show (if any) on hyper key press
-- local screen = hs.screen.primaryScreen()
-- local style = {textSize = 14, radius = 14, atScreenEdge = 2}

-- log = hs.logger.new('hyperkey')

-- local delayAlert = hs.timer.delayed.new(2, function() hs.alert.show(bindings, style, screen, 10) end)

-- -- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
-- function enterHyperMode()
--   hs.alert.closeAll()
--   -- hs.alert.show(bindings, style, screen, 10)
--   delayAlert:start()
--   hyperKey:enter()
-- end

-- -- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- function exitHyperMode()
--   hs.alert.closeAll()
--   delayAlert:stop()
--   -- clear dirty hack. watch HS change log
--   collectgarbage()
--   hyperKey:exit()
-- end

-- -- Bind the Hyper key
-- f18 = hs.hotkey.bind({}, 'f18', enterHyperMode, exitHyperMode)


-- -- launch apps
-- bindings = "Press key to launch application:\n-------------------------------------------------\n"
-- local function guide(key, prefix, message)
--   local add = ""
--   if prefix then
--     add = prefix .. "+"
--   end
--   bindings = bindings .. add .. key .. "\t--\t" .. message .. "\n"
-- end

-- -- build our own hyper key app launch shortcuts
-- local function launch(appname)
--   local found = hs.application.launchOrFocus(appname)
--   if found then
--     local app = hs.application.find(appname)
--     if appname == "Finder" then
--       app:selectMenuItem({"Window", "Bring All to Front"})
--     end
--     win = app:mainWindow()
--     if win then
--       win:focus()
--     end
--   else
--     log.e(app .. " not found")
--   end
-- end

-- for i, app in ipairs(singleKeyApps) do
--   guide(app[1], nil, app[2])
--   hyperKey:bind({}, app[1], function()
--       launch(app[2])
--   end)
-- end

-- -- extra actions
-- bindings = bindings .. "\nPress key to do action:\n-------------------------------------------------\n"
-- guide('Y', nil, "Yubikey")
-- hyperKey:bind({}, "Y", function()
--     hs.eventtap.keyStrokes(hs.execute('PATH=$HOME/bin:/usr/local/bin:$PATH /Users/sam/bin/yubi/yubi_goog.py --yubi', false))
-- end)

-- guide('L', nil, "Lock screen")
-- hyperKey:bind({}, "L", function()
--     hs.caffeinate.startScreensaver()
-- end)

-- guide("⏎", nil, "Maximize current window")
-- hyperKey:bind({}, "return", function()
--     local win = hs.window.frontmostWindow()
--     win:setFullscreen(not win:isFullscreen())
-- end)
