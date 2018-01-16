-- Hammerspoon configuration by Erik Whipp

---------Constants--------------------------------

local cmd_shift = {"cmd", "shift"}
local primary_monitor= "Color LCD"
local second_monitor = "SyncMaster"
local third_monitor = "DELL S2330MX"
local mainBrowser = "Safari"
local mainEditor = "xCode"
local ipadMonitor = "Display"
local mainTerm = "Terminal"

--------------------------------------------------
-- cmd + shift + l move windowSize right + 50 pixels
hs.hotkey.bind({"cmd", "shift"}, "h", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 50
  win:setFrame(f)
end)

-- cmd + shift + h resize window left + 50 pixels
hs.hotkey.bind({"cmd", "shift"}, "l", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 50
  win:setFrame(f)
end)

-- cmd shift + k resize window upward + 50 pixels
hs.hotkey.bind({"cmd", "shift"}, "k", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.y + 50
  win:setFrame(f)
end)

-- cmd shift + j resize window upward + 50 pixels
hs.hotkey.bind({"cmd", "shift"}, "j", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.y - 50
  win:setFrame(f)
end)


-- Tile two findows next to one another
-- first is left, second is right
hs.hotkey.bind({"cmd", "ctrl"}, "Left", function()
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
  hs.hotkey.bind({"cmd", "ctrl"}, "Right", function()
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

  -- Full Screen
  hs.hotkey.bind({"cmd", "ctrl"}, "Up", function()
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
  hs.hotkey.bind({"cmd", "ctrl"}, "Down", function()
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

-- Move between monitors

  -- reload the configuration automatically when file changes
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
local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Success")

  -- Launch various applications
hs.hotkey.bind({"cmd"}, "W", function()
  hs.application.launchOrFocus(mainBrowser)
end)

hs.hotkey.bind(cmd_shift, "T", function()
  hs.application.launchOrFocus("mainTerm")
end)

hs.hotkey.bind({"cmd"}, "M", function()
  hs.application.launchOrFocus("Mail")
end)

hs.hotkey.bind({"cmd"}, "E", function()
  hs.application.launchOrFocus("Atom")
end)

hs.hotkey.bind({"cmd", "shift"}, "M", function()
  hs.application.launchOrFocus("Spotify")
end)

hs.hotkey.bind({"cmd", "shift"}, "B", function()
  hs.application.launchOrFocus("qutebrowser")
end)

hs.hotkey.bind({"cmd", "shift"}, "C", function()
  hs.application.launchOrFocus("Messages")
end)

hs.hotkey.bind({"cmd", "shift"}, "X", function()
  hs.application.launchOrFocus("xCode")
end)

-- automatically play spotify
hs.hotkey.bind({"cmd", "ctrl"}, "P", function()
  hs.spotify.play()
  hs.spotify.displayCurrentTrack()
end)

-- stop spotify
hs.hotkey.bind({"cmd", "ctrl"}, "S", function()
  hs.spotify.pause()
end)

--------------------BEGIN POMORODO CLOCK-------------------------------
local pom={}
pom.bar = {
  indicator_height = 0.2, -- ratio from the height of the menubar (0..1)
  indicator_alpha  = 0.3,
  indicator_in_all_spaces = true,
  color_time_remaining = hs.drawing.color.green,
  color_time_used      = hs.drawing.color.red,

  c_left = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0)),
  c_used = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))
}

pom.config = {
  enable_color_bar = true,
  work_period_sec  = 25 * 60,
  rest_period_sec  = 5 * 60,

}

pom.var = {
  is_active        = false,
  disable_count    = 0,
  work_count       = 0,
  curr_active_type = "work", -- {"work", "rest"}
  time_left        = pom.config.work_period_sec,
  max_time_sec     = pom.config.work_period_sec
}

--------------------------------------------------------------------------------
-- Color bar for pomodoor
--------------------------------------------------------------------------------

function pom_del_indicators()
  pom.bar.c_left:delete()
  pom.bar.c_used:delete()
end

function pom_draw_on_menu(target_draw, screen, offset, width, fill_color)
  local screeng                  = screen:fullFrame()
  local screen_frame_height      = screen:frame().y
  local screen_full_frame_height = screeng.y
  local height_delta             = screen_frame_height - screen_full_frame_height
  local height                   = pom.bar.indicator_height * (height_delta)

  target_draw:setSize(hs.geometry.rect(screeng.x + offset, screen_full_frame_height, width, height))
  target_draw:setTopLeft(hs.geometry.point(screeng.x + offset, screen_full_frame_height))
  target_draw:setFillColor(fill_color)
  target_draw:setFill(true)
  target_draw:setAlpha(pom.bar.indicator_alpha)
  target_draw:setLevel(hs.drawing.windowLevels.overlay)
  target_draw:setStroke(false)
  if pom.bar.indicator_in_all_spaces then
    target_draw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
  end
  target_draw:show()
end

function pom_draw_indicator(time_left, max_time)
  local main_screen = hs.screen.mainScreen()
  local screeng     = main_screen:fullFrame()
  local time_ratio  = time_left / max_time
  local width       = math.ceil(screeng.w * time_ratio)
  local left_width  = screeng.w - width

  pom_draw_on_menu(pom.bar.c_left, main_screen, left_width, width,      pom.bar.color_time_remaining)
  pom_draw_on_menu(pom.bar.c_used, main_screen, 0,          left_width, pom.bar.color_time_used)

end
--------------------------------------------------------------------------------

-- update display
local function pom_update_display()
  local time_min = math.floor( (pom.var.time_left / 60))
  local time_sec = pom.var.time_left - (time_min * 60)
  local str = string.format ("[%s|%02d:%02d|#%02d]", pom.var.curr_active_type, time_min, time_sec, pom.var.work_count)
  pom_menu:setTitle(str)
end

-- stop the clock
-- Stateful:
-- * Disabling once will pause the countdown
-- * Disabling twice will reset the countdown
-- * Disabling trice will shut down and hide the pomodoro timer
function pom_disable()

  local pom_was_active = pom.var.is_active
  pom.var.is_active = false

  if (pom.var.disable_count == 0) then
     if (pom_was_active) then
      pom_timer:stop()
    end
  elseif (pom.var.disable_count == 1) then
    pom.var.time_left         = pom.config.work_period_sec
    pom.var.curr_active_type  = "work"
    pom_update_display()
  elseif (pom.var.disable_count >= 2) then
    if pom_menu == nil then
      pom.var.disable_count = 2
      return
    end

    pom_menu:delete()
    pom_menu = nil
    pom_timer:stop()
    pom_timer = nil
    pom_del_indicators()
  end

  pom.var.disable_count = pom.var.disable_count + 1

end

-- update pomodoro timer
local function pom_update_time()
  if pom.var.is_active == false then
    return
  else
    pom.var.time_left = pom.var.time_left - 1

    if (pom.var.time_left <= 0 ) then
      pom_disable()
      if pom.var.curr_active_type == "work" then
        hs.alert.show("Work Complete!", 2)
        pom.var.work_count        =  pom.var.work_count + 1
        pom.var.curr_active_type  = "rest"
        pom.var.time_left         = pom.config.rest_period_sec
        pom.var.max_time_sec      = pom.config.rest_period_sec
      else
          hs.alert.show("Done resting", 2)
          pom.var.curr_active_type  = "work"
          pom.var.time_left         = pom.config.work_period_sec
          pom.var.max_time_sec     = pom.config.work_period_sec
      end
    end

    -- draw color bar indicator, if enabled.
    if (pom.config.enable_color_bar == true) then
      pom_draw_indicator(pom.var.time_left, pom.var.max_time_sec)
    end

  end
end

-- update menu display
local function pom_update_menu()
  pom_update_time()
  pom_update_display()
end

local function pom_create_menu(pom_origin)
  if pom_menu == nil then
    pom_menu = hs.menubar.new()
    pom.bar.c_left = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))
    pom.bar.c_used = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))
  end
end

-- start the pomodoro timer
function pom_enable()
  pom.var.disable_count = 0;
  if (pom.var.is_active) then
    return
  end

  pom_create_menu()
  pom_timer = hs.timer.new(1, pom_update_menu)

  pom.var.is_active = true
  pom_timer:start()
end

-- reset work count
-- TODO - reset automatically every day
function pom_reset_work()
  pom.var.work_count = 0;
end

hs.hotkey.bind("cmd", '1', function() pom_enable() end)
hs.hotkey.bind("cmd", '0', function() pom_disable() end)
---------------------------END POM CLOCK--------------------------------------

-- focus windows
hs.hotkey.bind("cmd", "L", hs.window.focusWindowEast)
hs.hotkey.bind("cmd", "H", hs.window.focusWindowWest)
hs.hotkey.bind("cmd", "K", hs.window.focusWindowNorth)
hs.hotkey.bind("cmd", "J", hs.window.focusWindowSouth)

-- move windows to different workspace
-- Switch windows to next space at left or right
function moveWindowOneSpace(direction)
  _mouseOrigin = hs.mouse.getAbsolutePosition()
  local win = hs.window.focusedWindow()
  _clickPoint = win:zoomButtonRect()

  _clickPoint.x = _clickPoint.x + _clickPoint.w + 5
  _clickPoint.y = _clickPoint.y + (_clickPoint.h / 2)

  local mouseClickEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, _clickPoint)
  mouseClickEvent:post()

  hs.timer.usleep(100000)

  local nextSpaceDownEvent = hs.eventtap.event.newKeyEvent({"ctrl"}, direction, true)
  nextSpaceDownEvent:post()
end

function moveWindowOneSpaceEnd(direction)
  local nextSpaceUpEvent = hs.eventtap.event.newKeyEvent({"ctrl"}, direction, false)
  nextSpaceUpEvent:post()
  hs.timer.usleep(100000)
  local mouseReleaseEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, _clickPoint)
  mouseReleaseEvent:post()
  hs.timer.usleep(100000)
  hs.mouse.setAbsolutePosition(_mouseOrigin)
end

-- hotkey for moving windows
hk1 = hs.hotkey.bind({"cmd","shift"}, "right",
  function() moveWindowOneSpace("right")
end)
hk2 = hs.hotkey.bind({"cmd","shift"}, "left",
  function() moveWindowOneSpace("left")
end)

-- Open google drive from hotkey
function openGoogleDrive()
  local googleDrive = "https://drive.google.com/drive/u/0/my-drive"
  hs.execute("open " .. googleDrive)
  hs.application.launchOrFocus(mainBrowser)
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function() openGoogleDrive()
end)

-- move to different monitors
hs.hotkey.bind({"cmd", "shift"}, "1", function()
  local win = hs.window.focusedWindow()
  if (win) then
    win:moveToScreen(hs.screen.get(primary_monitor))
    win:maximize()
  end
end)

hs.hotkey.bind( cmd_shift, "2", function()
  local win = hs.window.focusedWindow()
  if (win) then
    win:moveToScreen(hs.screen.get(second_monitor))
    win:maximize()
  end
end)

hs.hotkey.bind( cmd_shift, "3", function()
  local win = hs.window.focusedWindow()
  if (win) then
    win:moveToScreen(hs.screen.get(third_monitor))
    win:maximize()
  end
end)

hs.hotkey.bind( cmd_shift, "2", function()
  local win = hs.window.focusedWindow()
  if (win) then
    win:moveToScreen(hs.screen.get(ipadMonitor))
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
