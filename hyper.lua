-- A global variable for the Hyper Mode
hyperKey = hs.hotkey.modal.new({}, 'F17')

-- alert to show (if any) on hyper key press
reload = false
screen = hs.screen.primaryScreen()
style = {textSize = 14, radius = 14, atScreenEdge = 2}

log = hs.logger.new('hyperkey')

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
function enterHyperMode()
  hyperKey.triggered = false
  hs.alert.closeAll()
  hs.alert.show(bindings, style, screen, 10)
  hyperKey:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function exitHyperMode()
  hs.alert.closeAll()
  -- clear dirty hack. watch HS change log
  collectgarbage()
  hyperKey:exit()
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'f18', enterHyperMode, exitHyperMode)

singleKeyApps = {
  -- 'A' reserved for double key shortucts
  {'C', 'Calendar'},
  {'E', 'Emacs'},
  {'F', 'Finder'},
  {'G', 'Telegram'},
  {'K', 'Skype'},
  {'S', 'Slack'},
  {'M', 'Mail'},
  {'N', 'Notes'},
  {'P', 'Google Play Music Desktop Player'},
  {'T', 'iTerm'},
  {'V', 'VirtualBox'},
  {'W', 'Safari'},
  {'.', 'Dash'},
  {',', 'System Preferences'},
  {'\\', 'Amphetamine'}
}

-- launch apps
bindings = "Press key to launch application:\n-------------------------------------------------\n"
function guide(key, prefix, message)
  local add = ""
  if prefix then
    add = prefix .. "+"
  end
  bindings = bindings .. add .. key .. "\t--\t" .. message .. "\n"
end

-- build our own hyper key app launch shortcuts
function launch(appname)
  hyperKey.triggered = true
  found = hs.application.launchOrFocus(appname)
  if found then
    app = hs.application.find(appname)
    if appname == "Finder" then
      app:selectMenuItem({"Window", "Bring All to Front"})
    end
    win = app:mainWindow()
    if win then
      win:focus()
    end
  else
    log.e(app .. " not found")
  end
end

for i, app in ipairs(singleKeyApps) do
  guide(app[1], nil, app[2])
  hyperKey:bind({}, app[1], function()
      launch(app[2])
  end)
end
