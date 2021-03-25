---
--- local functions
---
local function activateYubikey()
  local output, status, exit_type, code = hs.execute('PATH=$HOME/bin:/usr/local/bin:$PATH /Users/sam/bin/yubi/yubi_goog.py --yubi', false)
  if status then
    hs.eventtap.keyStrokes(output)
  else
    hs.notify.show("Yubikey failed", "failed to execute yubi_goog", "Code: " .. code .. " type: ".. exit_type)
  end
end

local function toggleFullscreen()
  local win = hs.window.frontmostWindow()
  win:setFullscreen(not win:isFullscreen())
end

local function lockScreen()
  os.execute("pmset displaysleepnow")
end

-- Spoons
hs.loadSpoon("SpoonInstall")

-- spoon.SpoonInstall.use_syncinstall = true
local Install=spoon.SpoonInstall

local wmKey      = {"cmd", "alt"}
local wmKeyShift = {"cmd", "alt", "shift"}

hs.window.animationDuration = 0.05
Install:andUse("MiroWindowsManager",
                {
                  hotkeys = {
                      up         = {wmKey, "up"},
                      right      = {wmKey, "right"},
                      down       = {wmKey, "down"},
                      left       = {wmKey, "left"},
                      fullscreen = {wmKey, "f"}
                  }
                }
)
-- spoon.MiroWindowsManager.sizes = { 6/5, 4/3, 3/2, 2/1, 3/1, 4/1, 6/1 }

-- center focused x and y
hs.hotkey.bind(wmKey, 'c', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.x = ((max.w - f.w) / 2) + max.x
	x.y = ((max.h - f.h) / 2) + max.y
	win:setFrame(x)
end)

-- center focused y
hs.hotkey.bind(wmKey, 'x', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.y = ((max.h - f.h) / 2) + max.y
	win:setFrame(x)
end)

-- center focused x
hs.hotkey.bind(wmKey, 'v', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.x = ((max.w - f.w) / 2) + max.x
	win:setFrame(x)
end)

-- maximize on wide screen
hs.hotkey.bind(wmKey, 'w', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  local x = f

  x.y = max.y
  x.h = max.h
  x.w = 8 * max.w / 9
  x.x = ((max.w - f.w) / 2) + max.x
  win:setFrame(x)
end)

-- maximize vertically
hs.hotkey.bind(wmKey, '[', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.y = max.y
	x.h = max.h
	win:setFrame(x)
end)

-- maximize horizontally
hs.hotkey.bind(wmKey, ']', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.x = max.x
	x.w = max.w
	win:setFrame(x)
end)

Install:andUse("ReloadConfiguration",
               {
                 start = true
               }
)

Install:andUse("WindowScreenLeftAndRight",
               {
                 hotkeys = {
                   screen_left  = { wmKeyShift, "Left" },
                   screen_right = { wmKeyShift, "Right" },
                 }
               }
)

hs.loadSpoon("DisplayTab")
spoon.DisplayTab:bindHotkeys(spoon.DisplayTab.defaultHotkeys)

hs.loadSpoon("UsbYubiWatcher")
spoon.UsbYubiWatcher.deviceActions = {
  Yubikey = {
    connect    = function() os.execute("caffeinate -u -t 10") end,
    disconnect = lockScreen
  }
}
spoon.UsbYubiWatcher:start()

hs.loadSpoon("KeyCommander")
spoon.KeyCommander:bindHotkeys({
    hotkey = spoon.KeyCommander.defaultHotkey,
    appKeys = {
      {{}, 'B', 'Calibre'},
      {{}, 'C', 'Calendar'},
      {{"shift"}, 'C', 'Calculator'},
      {{}, 'E', 'Emacs'},
      {{}, 'F', 'Finder'},
      {{}, 'G', 'Telegram'},
      {{}, 'K', 'Skype'},
      {{}, 'S', 'Slack'},
      {{}, 'M', 'Mail'},
      {{}, 'N', 'Notes'},
      {{}, 'P', 'MacPass'},
      {{}, 'T', 'iTerm'},
      {{}, 'V', 'Viber'},
      {{}, 'Z', 'Zoom.us.app'},
      {{}, 'W', 'Firefox'},
      {{}, '.', 'Dash'},
      {{}, ',', 'System Preferences'},
      {{}, ';', 'Activity Monitor'},
      {{}, '\\', 'Amphetamine'}
    },
    actionKeys = {
      {{}, "Y", activateYubikey},
      {{}, "L", lockScreen},
      {{}, "return", toggleFullscreen},
      {{"shift"}, "0", hs.openConsole}
    }
})

local lastPsuSerial = "unknown"

local function batteryChangedCallback()
  psuSerial = hs.battery.psuSerialString()
  if hs.battery.powerSource() == "AC Power"  then
    if psuSerial ~= "C4H701102AMGN8RA4"
      and psuSerial ~=""
      and psuSerial ~= lastPsuSerial
    then
      hs.notify.show("Battery Watcher", "That's not your power supply!", psuSerial)
    end
    lastPsuSerial = psuSerial
  end
end

local batteryWatcher = hs.battery.watcher.new(batteryChangedCallback)
batteryWatcher:start()
