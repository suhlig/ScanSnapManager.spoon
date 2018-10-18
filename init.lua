local ssm = {}

-- This is a spooned version of http://www.hammerspoon.org/go/#usbevents

ssm.__index = ssm
ssm.name = "ScanSnapManager"
ssm.version = "1.0"
ssm.author = "Steffen Uhlig <steffen@familie-uhlig.net>"
ssm.homepage = "https://github.com/suhlig/ScanSnapManager.spoon"
ssm.license = "MIT - https://opensource.org/licenses/MIT"

function ssm:init()
  usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
  usbWatcher:start()
end

function usbDeviceCallback(data)
  hs.alert(data["productName"] .. " was " .. data["eventType"])

  if (string.sub(data["productName"], 1, 8) == "ScanSnap") then
    if (data["eventType"] == "added") then
      hs.application.launchOrFocus("ScanSnap Manager")

      -- open the settings panel with Control-S
      hs.eventtap.keyStroke({"cmd"}, "s")
    elseif (data["eventType"] == "removed") then
      -- TODO close the modal dialog with ESC

      app = hs.appfinder.appFromName("ScanSnap Manager")
      app:kill()
    end
  end
end

return ssm
