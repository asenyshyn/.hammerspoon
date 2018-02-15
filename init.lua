require "hyper"
require "actions"

-- Spoons
mousecircle = hs.loadSpoon('MouseCircle', false)
caffeine = hs.loadSpoon('Caffeine', false)

-- Reload config spoon
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()


local usbWatcher = nil

-- This is our usbWatcher function
-- lock when yubikey is removed
function usbDeviceCallback(data)
  -- this line will let you know the name of each usb device you connect, useful for the string match below
  if (data["eventType"] == "added") then
    hs.notify.show("USB", "You just connected", data["productName"])

    if string.match(data["productName"], "Yubikey") then
      os.execute("caffeinate -u -t 5")
    end
  elseif data["eventType"] == "removed" then
    hs.notify.show("USB", "You just removed", data["productName"])

    if string.match(data["productName"], "Yubikey") then
      -- hs.messages.iMessage("+000000000000", "Your Yubikey was just removed from your Work iMac.")
      os.execute("pmset displaysleepnow")
    end
  end
end

-- Start the usb watcher
usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()
