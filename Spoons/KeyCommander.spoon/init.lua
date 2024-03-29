local obj = {}
obj.__index = obj

-- Metadata
obj.name = "KeyCommander"
obj.version = "0.1"
obj.author = "Andriy Senyshyn <asenyshyn@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.logger = hs.logger.new("KeyCommander")

obj.hyperKey = hs.hotkey.modal.new({}, 'F17')

obj.defaultHotkey = {{}, "F18"}

function obj:enterHyperMode()
  obj.logger:d("enter hyper")
  self.hyperKey:enter()
end

function obj:exitHyperMode()
  obj.logger:d("exit hyper")
  self.hyperKey:exit()
end

-- build our own hyper key app launch shortcuts
function obj:launch(appName)
  if hs.application.launchOrFocus(appName) then
    local app = hs.application.get(appName)

    if app then
      app:activate(true)

      local win = app:mainWindow()
      if not win or win == hs.window.desktop() then
        if app:name() == "Finder" then
          app:selectMenuItem({"File", "New Finder Window"})
        end
      end

      app:selectMenuItem({"Window", "Bring All to Front"})
    end
  end
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
    obj.logger:e("hotkey is not set")
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
