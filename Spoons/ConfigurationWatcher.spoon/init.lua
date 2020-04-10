--- === Configuration Watcher ===
---
--- Responsible for watching and reconfiguring Hammerspoon when changes are made to init.lua


--- Metadata
local obj = {}
obj.name = "Configuration Watcher"
obj.version = "1.0"
obj.author = "ewhipp <whipp.erik@gmail.com>"
obj.license = "MIT"
obj.homepage = nil

local logger = hs.logger.new("Configuration Watcher")
obj.logger = logger

function reloadConfig(files)
    reloadCompleted = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then reloadCompleted = true end
    end
    if reloadCompleted then hs.reload() end
end


function obj:init()
    hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
    hs.notify.show("Successfully reloaded configuration.", "", "Press CTRL+SHIFT+H to view commands.")
end

return obj