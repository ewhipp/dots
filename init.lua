-- Hammerspoon configuration by Erik Whipp
--------- COMBINATIONS -----------------
local cmd_shift = {"cmd", "shift"}
local cmd_ctrl = {"cmd", "ctrl"}
local cmd_alt_ctrl = {"cmd", "alt", "ctrl"};

--------- MONITORS -----------------

function moveToDisplay(display)
    return function()
        local displays = hs.screen.allScreens()
        local currentWindow = hs.window.focusedWindow()
        currentWindow:moveToScreen(displays[display], false, true)
    end
end

hs.hotkey.bind(cmd_shift, "1", moveToDisplay(1))
hs.hotkey.bind(cmd_shift, "2", moveToDisplay(2))

--------- PROGRAMS -----------------

local mainBrowser = "Google Chrome"
local mainEditor = "Code"
local mainTerm = "Terminal"
local slack = "Slack"
local mail_program = "Mail"
local music_program = "Amazon Music"

--------- LOCK SCREEN ------------

hs.hotkey.bind(cmd_alt_ctrl, "Up", function() hs.caffeinate.lockScreen() end)

--------- SCREEN BLOCKS ------------
-- Left
hs.hotkey.bind(cmd_ctrl, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- Right
hs.hotkey.bind(cmd_ctrl, "Right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- Corners of the Screen
-- Top Right
hs.hotkey.bind({"cmd", "ctrl"}, "]", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- Bottom Right
hs.hotkey.bind({"cmd", "ctrl"}, "'", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x + (max.w / 2)
    f.y = (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- Top left
hs.hotkey.bind({"cmd", "ctrl"}, "[", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- Bottom left
hs.hotkey.bind({"cmd", "ctrl"}, ";", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.h / 2
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- Full Screen
hs.hotkey.bind(cmd_ctrl, "Up", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end)

-- move to mid screen
hs.hotkey.bind(cmd_ctrl, "Down", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + 200
    f.y = max.y - 100
    f.w = -140 + max.w - 300
    f.h = max.h - 100
    win:setFrame(f)
end)

--------- RELOAD CONFIG AUTO ------------

function reloadConfig(files)
    reloadCompleted = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then reloadCompleted = true end
    end
    if reloadCompleted then hs.reload() end
end

-- DO IT --
local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/",
                                     reloadConfig):start()
hs.alert.show("Success")

--------- APPLICATION COMMANDS ---------
hs.hotkey.bind(cmd_shift, "T",
               function() hs.application.launchOrFocus(mainTerm) end)

hs.hotkey.bind(cmd_shift, "B",
               function() hs.application.launchOrFocus(slack) end)

hs.hotkey.bind(cmd_shift, "M",
               function() hs.application.launchOrFocus(music_program) end)

hs.hotkey.bind(cmd_shift, "C",
               function() hs.application.launchOrFocus("Messages") end)

hs.hotkey.bind(cmd_shift, "X",
               function() hs.application.launchOrFocus("xCode") end)

hs.hotkey.bind(cmd_shift, "J",
               function() hs.application.launchOrFocus(m_Control) end)

hs.hotkey.bind({"cmd"}, "W",
               function() hs.application.launchOrFocus(mainBrowser) end)

hs.hotkey.bind({"cmd"}, "M",
               function() hs.application.launchOrFocus(mail_program) end)

hs.hotkey.bind({"cmd"}, "E",
               function() hs.application.launchOrFocus(mainEditor) end)
-------- APPLICATIONS END  -------------

hs.loadSpoon("PomodoroClock")
hs.hotkey.bind(cmd_ctrl, "1", function() spoon.PomodoroClock:start() end)
hs.hotkey.bind(cmd_ctrl, '0', function() spoon.PomodoroClock:stop() end)
hs.hotkey.bind(cmd_ctrl, '2', function() spoon.PomodoroClock:reset() end)


--------- OPEN WEBSITES -------------

function openGoogleDrive()
    local googleDrive = "https://drive.google.com/drive/u/0/my-drive"
    hs.execute("open " .. googleDrive)
    hs.application.launchOrFocus(mainBrowser)
end

hs.hotkey.bind(cmd_alt_ctrl, "W", function() openGoogleDrive() end)

--------- FOCUS MONITOR -------------

