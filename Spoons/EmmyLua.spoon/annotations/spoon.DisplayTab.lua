--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Switch between applications on different displays
--
-- Download: [https://github.com](https://github.com)
---@class spoon.DisplayTab
local M = {}
spoon.DisplayTab = M

-- Binds hotkeys for DisplayTab
--
-- Parameters:
--  * mapping - A table containing hotkey objifier/key details for the following items:
--   * focus_next, focus_previous - move the focus to the next/previous display (if you have more than one monitor connected, does nothing otherwise)
function M:bindHotkeys(mapping, ...) end

