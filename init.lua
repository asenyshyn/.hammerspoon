---
--- settings
---
hs.logger.setGlobalLogLevel("info")

---
--- local functions
---
local function activateYubikey()
  hs.eventtap.keyStrokes(hs.execute('PATH=$HOME/bin:/usr/local/bin:$PATH /Users/sam/bin/yubi/yubi_goog.py --yubi', false))
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

hs.window.animationDuration = 0
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

Install:andUse("ReloadConfiguration",
               {
                 start = true
               }
)

Install:andUse("TimeMachineProgress",
               {
                 disable = true,
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
      {{}, 'V', 'VirtualBox'},
      {{}, 'W', 'Safari'},
      {{}, '.', 'Dash'},
      {{}, ',', 'System Preferences'},
      {{}, '\\', 'Amphetamine'}
    },
    actionKeys = {
      {{}, "Y", activateYubikey},
      {{}, "L", lockScreen},
      {{}, "return", toggleFullscreen},
      {{"shift"}, "0", hs.openConsole}
    }
})
