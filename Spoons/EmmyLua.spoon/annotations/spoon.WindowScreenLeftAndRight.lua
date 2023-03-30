--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Move windows to other screens
--
-- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/WindowScreenLeftAndRight.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/WindowScreenLeftAndRight.spoon.zip)
---@class spoon.WindowScreenLeftAndRight
local M = {}
spoon.WindowScreenLeftAndRight = M

-- Binds hotkeys for WindowScreenLeftAndRight
--
-- Parameters:
--  * mapping - A table containing hotkey objifier/key details for the following items:
--   * screen_left, screen_right - move the window to the left/right screen (if you have more than one monitor connected, does nothing otherwise)
function M:bindHotkeys(mapping, ...) end

-- Table containing a sample set of hotkeys that can be
-- assigned to the different operations. These are not bound
-- by default - if you want to use them you have to call:
-- `spoon.WindowScreenLeftAndRight:bindHotkeys(spoon.WindowScreenLeftAndRight.defaultHotkeys)`
-- after loading the spoon. Value:
-- ```
--  {
--     screen_left = { {"ctrl", "alt", "cmd"}, "Left" },
--     screen_right= { {"ctrl", "alt", "cmd"}, "Right" },
--  }
-- ```
M.defaultHotkeys = nil

-- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
M.logger = nil

