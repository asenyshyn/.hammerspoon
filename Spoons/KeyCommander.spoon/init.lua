local obj = {}
obj.__index = obj

-- Metadata
obj.name = "KeyCommander"
obj.version = "0.1"
obj.author = "Andriy Senyshyn <asenyshyn@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.logger = hs.logger.new("KeyCommander")
obj.cache = {}

obj.hyperKey = hs.hotkey.modal.new({}, 'F17')

obj.defaultHotkey = {{}, "F18"}

function obj:enterHyperMode()
  obj.logger.d("enter hyper")
  self.hyperKey:enter()
end

function obj:exitHyperMode()
  obj.logger.d("exit hyper")
  self.hyperKey:exit()
end

-- build our own hyper key app launch shortcuts
function obj:launch(appName)
  -- first focus with hammerspoon
  hs.application.launchOrFocus(appName)

  -- clear timer if exists
  if obj.cache.launchTimer then obj.cache.launchTimer:stop() end

  -- wait 500ms for window to appear and try hard to show the window
  obj.cache.launchTimer = hs.timer.doAfter(0.5, function()
    local frontmostApp     = hs.application.frontmostApplication()
    local frontmostWindows = hs.fnutils.filter(frontmostApp:allWindows(), function(win) return win:isStandard() end)

    if frontmostApp:title() == "Finder" then
      frontmostApp:selectMenuItem({"Window", "Bring All to Front"})
    end
    -- break if this app is not frontmost (when/why?)
    if frontmostApp:title() ~= appName then
      print('Expected app in front: ' .. appName .. ' got: ' .. frontmostApp:title())
      return
    end

    if #frontmostWindows == 0 then
      -- check if there's app name in window menu (Calendar, Messages, etc...)
      if frontmostApp:findMenuItem({ 'Window', appName }) then
        -- select it, usually moves to space with this window
        frontmostApp:selectMenuItem({ 'Window', appName })
      else
        -- otherwise send cmd-n to create new window
        hs.eventtap.keyStroke({ 'cmd' }, 'n')
      end
    end
  end)
end

function obj:bindHotkeys(mapping)
  if mapping.hotkey then
    hs.hotkey.bind(
      mapping.hotkey[1],
      mapping.hotkey[2],
      function() self:enterHyperMode() end,
      function() self:exitHyperMode() end
    )
  else
    obj.logger.e("hotkey is not set")
    return
  end

  if mapping.appKeys then
    for _, app in ipairs(mapping.appKeys) do
      self.hyperKey:bind(app[1], app[2], function() self:launch(app[3]) end)
    end
  end

  if mapping.actionKeys then
    for _, action in ipairs(mapping.actionKeys) do
      self.hyperKey:bind(action[1], action[2], action[3])
    end
  end

end

return obj
