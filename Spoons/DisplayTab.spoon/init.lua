--- === DisplayTab ===
---
--- Switch between applications on different displays
---
--- Download: [https://github.com](https://github.com)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "DisplayTab"
obj.version = "0.1"
obj.author = "Andriy Senyshyn <asenyshyn@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.logger = hs.logger.new("DisplayTab")

obj.defaultHotkeys = {
  focus_next     = {{"alt"}, "tab"},
  focus_previous = {{"alt", "shift"}, "tab"}
}

--Predicate that checks if a window belongs to a screen
function obj.isInScreen(screen, win)
  return win:screen() == screen
end

-- Brings focus to the scren by setting focus on the front-most application in it.
-- Also move the mouse cursor to the center of the screen. This is because
-- Mission Control gestures & keyboard shortcuts are anchored, oddly, on where the
-- mouse is focused.
function obj.focusScreen(screen)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  local windows = hs.fnutils.filter(
    hs.window.orderedWindows(),
    hs.fnutils.partial(obj.isInScreen, screen)
  )
  local windowToFocus = #windows > 0 and windows[1] or hs.window.desktop()
  windowToFocus:focus()

  -- Move mouse to center of screen
  local pt = hs.geometry.rectMidPoint(screen:fullFrame())
  hs.mouse.setAbsolutePosition(pt)
end

function obj.focusBetweenDisplays(where)
  local s = hs.window.focusedWindow():screen()
  if s == nil then
    obj.logger.d("screen not found")
    return
  end

  if #(hs.screen.allScreens()) <= 1 then
    obj.logger.d(s:name().." is the only screen")
    return
  end

  if where == "next" then
    obj.focusScreen(s:next())
  elseif where == "previous" then
    obj.focusScreen(s:previous())
  end
end

obj.focusNext     = hs.fnutils.partial(obj.focusBetweenDisplays, "next")
obj.focusPrevious = hs.fnutils.partial(obj.focusBetweenDisplays, "previous")

--- DisplayTab:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for DisplayTab
---
--- Parameters:
---  * mapping - A table containing hotkey objifier/key details for the following items:
---   * focus_next, focus_previous - move the focus to the next/previous display (if you have more than one monitor connected, does nothing otherwise)
function obj:bindHotkeys(mapping)
  local hotkeyDefinitions = {
    focus_next     = self.focusNext,
    focus_previous = self.focusPrevious,
  }
  hs.spoons.bindHotkeysToSpec(hotkeyDefinitions, mapping)
  return self
end

return obj
