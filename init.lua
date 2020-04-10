-- Hammerspoon configuration by Erik Whipp
local cmd_shift = {"cmd", "shift"}
local cmd_ctrl = {"cmd", "ctrl"}
local cmd_alt_ctrl = {"cmd", "alt", "ctrl"};
local cmd = { "cmd" }

hs.loadSpoon("ConfigurationWatcher")
hs.loadSpoon("ApplicationLauncher")
hs.loadSpoon("PomodoroClock")
hs.loadSpoon("WindowManager")

hs.hotkey.bind(cmd_ctrl, "Left",    function() spoon.WindowManager:left()              end)
hs.hotkey.bind(cmd_ctrl, "Right",   function() spoon.WindowManager:right()             end)
hs.hotkey.bind(cmd_ctrl, "]",       function() spoon.WindowManager:top_right()         end)
hs.hotkey.bind(cmd_ctrl, "'",       function() spoon.WindowManager:bottom_right()      end)
hs.hotkey.bind(cmd_ctrl, "[",       function() spoon.WindowManager:top_left()          end)
hs.hotkey.bind(cmd_ctrl, ";",       function() spoon.WindowManager:bottom_left()       end)
hs.hotkey.bind(cmd_ctrl, "Down",    function() spoon.WindowManager:center()            end)
hs.hotkey.bind(cmd_ctrl, "Up",      function() spoon.WindowManager:full_screen()       end)
hs.hotkey.bind(cmd_shift, "1",      function() spoon.WindowManager:move_to_display(1)  end)
hs.hotkey.bind(cmd_shift, "2",      function() spoon.WindowManager:move_to_display(2)  end)
hs.hotkey.bind(cmd_ctrl, "1",       function() spoon.PomodoroClock:start()             end)
hs.hotkey.bind(cmd_ctrl, '0',       function() spoon.PomodoroClock:stop()              end)
hs.hotkey.bind(cmd_ctrl, '2',       function() spoon.PomodoroClock:reset()             end)
