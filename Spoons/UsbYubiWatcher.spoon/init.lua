--- === UsbYubiWatcher ===
---
--- Notify about connected/disconnected USB devices. Wake/Lock mac on Yubikey plug/unplug
---
--- Download: [https://github.com](https://github.com)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "UsbYubiWatcher"
obj.version = "0.1"
obj.author = "Andriy Senyshyn <asenyshyn@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.watcher = nil
obj.notifyShow = hs.notify.show

obj.deviceActions = nil

function obj:findDeviceAction(name, action)
  for k,v in pairs(self.deviceActions) do
    if string.match(name, k) then
      return v[action]
    end
  end
  return nil
end

function obj:findConnectAction(name)
  return self:findDeviceAction(name, "connect")
end

function obj:findDisconnectAction(name)
  return self:findDeviceAction(name, "disconnect")
end


function obj:usbDeviceCallback(data)
  -- this line will let you know the name of each usb device you connect, useful for the string match below
  if (data["eventType"] == "added") then
    self.notifyShow("USB Watcher", "You just connected", data["productName"])

    local cb = self:findConnectAction(data["productName"])
    if cb then
      cb()
    end
  elseif data["eventType"] == "removed" then
    self.notifyShow("USB Watcher", "You just removed", data["productName"])

    local cb = self:findDisconnectAction(data["productName"])
    if cb then
      cb()
    end
  end
end

function obj:start()
  self:stop()
  self.watcher = hs.usb.watcher.new(function(data) self:usbDeviceCallback(data) end)
  self.watcher:start()
  return self
end

function obj:stop()
  if self.watcher then
    self.watcher:stop()
  end
  self.watcher = nil
  return self
end

return obj
