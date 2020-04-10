--- === Window Manager ===
---
--- Allows the ability to move windows to specific areas in your workspace
--- To full left, full right, top-right corner, top-left corner,
--- bottom-right corner, bottom-left corner, to next display
---

--- Metadata
local obj = {}
obj.name = "Window Manager"
obj.version = "1.0"
obj.author = "ewhipp <whipp.erik@gmail.com>"
obj.license = "MIT"
obj.homepage = nil

local logger = hs.logger.new("Window Manager")
obj.logger = logger

--- WindowManager:left()
--- Method
--- Move focused window to the left half of the allotted screen size
function obj:left() 
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end

--- WindowManager:right()
--- Method
--- Move focused window to the right half of the allotted screen size
function obj:right()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end

--- WindowManager:top_right()
--- Method
--- Move focused window to the top right of the allotted screen size
function obj:top_right() 
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

--- WindowManager:bottom_right()
--- Method
--- Move focused window to the bottom right of the allotted screen size
function obj:bottom_right()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x + (max.w / 2)
    f.y = (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

--- WindowManager:top_left()
--- Method
--- Move focused window to the top left of the allotted screen size
function obj:top_left()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

--- WindowManager:bottom_left()
--- Method
--- Move focused window to the bottom left of the allotted screen size
function obj:bottom_left() 
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.h / 2
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

--- WindowManager:full_screen()
--- Method
--- Make focused window take entire screen real estate
function obj:full_screen()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end

--- WindowManager:center()
--- Method
--- Move focused window centered on the current screen
function obj:center() 
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + 200
    f.y = max.y - 100
    f.w = -140 + max.w - 300
    f.h = max.h - 100
    win:setFrame(f)
end

--- WindowManager:moveToDisplay()
--- Method
--- Move focused window to the numbered display
function obj:moveToDisplay(display)
    local displays = hs.screen.allScreens()
    local currentWindow = hs.window.focusedWindow()
    currentWindow:moveToScreen(displays[display], false, true)
end

return obj
