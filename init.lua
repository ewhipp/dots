-- Hammerspoon configuration by Erik Whipp

--------- COMBINATIONS -----------------

local cmd_shift = {"cmd", "shift"}
local cmd_ctrl = {"cmd", "ctrl"}
local cmd_alt_ctrl = {"cmd", "alt", "ctrl"};

--------- MONITORS -----------------

local primary_monitor= "Color LCD"
local second_monitor = "SyncMaster"
local third_monitor = "DELL U2414H"
local work_monitor = "ASUS PB238"

--------- PROGRAMS -----------------

local mainBrowser = "Google Chrome"
local mainEditor = "IntelliJ IDEA"
local ipadMonitor = "Display"
local mainTerm = "Terminal"
local slack = "Slack"
local m_Control = "MoneyControl"
local mail_program = "Microsoft Outlook"

--------- LOCK SCREEN ------------

hs.hotkey.bind(cmd_alt_ctrl, "Up", function()
  hs.caffeinate.lockScreen()
end)

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
  hs.hotkey.bind({ "cmd", "ctrl"}, "]", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w  / 2
  f.h = max.h / 2
  win:setFrame(f)
  end)

  -- Bottom Right
  hs.hotkey.bind({ "cmd", "ctrl"}, "'", function()
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
  hs.hotkey.bind({ "cmd", "ctrl"}, "[", function()
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
  hs.hotkey.bind({ "cmd", "ctrl"}, ";", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x 
  f.y = max.h / 2
  f.w = max.w  / 2
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
  f.y = max.y -100
  f.w = -140 + max.w -300
  f.h = max.h - 100
  win:setFrame(f)
end)

--------- RELOAD CONFIG AUTO ------------

function reloadConfig(files)
  reloadCompleted = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      reloadCompleted = true
    end
  end
  if reloadCompleted then
    hs.reload()
  end
end

-- DO IT --
local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Success")


--------- APPLICATION COMMANDS ---------
hs.hotkey.bind(cmd_shift, "T", function()
  hs.application.launchOrFocus(mainTerm)
end)

hs.hotkey.bind(cmd_shift, "B", function()
  hs.application.launchOrFocus(slack)
end)

hs.hotkey.bind(cmd_shift, "M", function()
  hs.application.launchOrFocus("Spotify")
end)

hs.hotkey.bind(cmd_shift, "C", function()
  hs.application.launchOrFocus("Messages")
end)

hs.hotkey.bind(cmd_shift, "X", function()
  hs.application.launchOrFocus("xCode")
end)

hs.hotkey.bind(cmd_shift, "J", function()
  hs.application.launchOrFocus(m_Control)
end)

hs.hotkey.bind({"cmd"}, "W", function()
  hs.application.launchOrFocus(mainBrowser)
end)

hs.hotkey.bind({"cmd"}, "M", function()
  hs.application.launchOrFocus(mail_program)
end)

hs.hotkey.bind({"cmd"}, "E", function()
  hs.application.launchOrFocus(mainEditor)
end)

--------- CONTROL SPOTIFY ---------

hs.hotkey.bind(cmd_ctrl, "P", function()
  hs.spotify.play()
  hs.spotify.displayCurrentTrack()
end)

hs.hotkey.bind({"cmd", "ctrl"}, "S", function()
  hs.spotify.pause()
end)

--------- OPEN WEBSITES -------------

function openGoogleDrive()
  local googleDrive = "https://drive.google.com/drive/u/0/my-drive"
  hs.execute("open " .. googleDrive)
  hs.application.launchOrFocus(mainBrowser)
end

hs.hotkey.bind(cmd_alt_ctrl, "W", function() openGoogleDrive() end)

--------- FOCUS MONITOR -------------

hs.hotkey.bind(cmd_shift, "1", function()
  local win = hs.window.focusedWindow()
  if (win) then
    win:moveToScreen(hs.screen.get(primary_monitor))
    win:maximize()
  end
end)

hs.hotkey.bind(cmd_shift, "2", function() 
  local win = hs.window.focusedWindow()
  if (win) then
    win:moveToScreen(hs.screen.get(third_monitor))
    win:maximize()
  end
end)

hs.hotkey.bind(cmd_shift, "5", function() 
  local win = hs.window.focusedWindow()
  if (win) then
    win:moveToScreen(hs.screen.get(work_monitor))
    win:maximize()
  end
end)

function hs.screen.get(screen_name)
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    if screen:name() == screen_name then
      return screen
    end
  end
end
