--- === Application Launcher ===
---
--- Responsible for launching and listening to keys for application launching


--- Metadata
local obj = {}
obj.name = "Key Listener"
obj.version = "1.0"
obj.author = "ewhipp <whipp.erik@gmail.com>"
obj.license = "MIT"
obj.homepage = nil

local logger = hs.logger.new("Key Listener")
obj.logger = logger

cmd_shift = {"cmd", "shift"}
cmd_ctrl = {"cmd", "ctrl"}
cmd_alt_ctrl = {"cmd", "alt", "ctrl"}
cmd = { "cmd" }
ctrl_shift = { "ctrl", "shift" }
opt_shift = { "alt", "shift"}

local programs = {
    main_browser="Firefox",
    work_browser="Google Chrome",
    main_editor="Visual Studio Code",
    main_terminal="Terminal",
    main_communication="Discord",
    work_communication="Slack", 
    notes="Obsidian",
    pmanager="1password"
}

hs.loadSpoon("PomodoroClock")
hs.loadSpoon("WindowManager")
hs.loadSpoon("SpaceManager")

function show_listeners()
    local shell_command = string.gsub("open /Users/" .. hs.execute("whoami") .. "/.hammerspoon/commands.txt", "\n", "")
    hs.execute(shell_command)
end


function obj:init() 
    print("[Key Listener]: Setting listeners")
    hs.hotkey.bind(cmd,       "W",      function() hs.application.launchOrFocus(programs.work_browser)           end)
    hs.hotkey.bind(cmd_shift, "W",      function() hs.application.launchOrFocus(programs.main_browser)           end)
    hs.hotkey.bind(cmd,       "M",      function() hs.application.launchOrFocus(programs.notes)                  end)
    hs.hotkey.bind(cmd,       "E",      function() hs.application.launchOrFocus(programs.main_editor)            end)
    hs.hotkey.bind(cmd_shift, "T",      function() hs.application.launchOrFocus(programs.main_terminal)          end)
    hs.hotkey.bind(cmd_shift, "B",      function() hs.application.launchOrFocus(programs.work_communication)     end)
    hs.hotkey.bind(ctrl_shift,"B",      function() hs.application.launchOrFocus(programs.main_communication)     end)
    hs.hotkey.bind(ctrl_shift,"P",      function() hs.application.launchOrFocus(programs.pmanager)               end)
    hs.hotkey.bind(cmd_ctrl,  "Left",   function() spoon.WindowManager:left()                                    end)
    hs.hotkey.bind(cmd_ctrl,  "Right",  function() spoon.WindowManager:right()                                   end)
    hs.hotkey.bind(cmd_ctrl,  "]",      function() spoon.WindowManager:top_right()                               end)
    hs.hotkey.bind(cmd_ctrl,  "'",      function() spoon.WindowManager:bottom_right()                            end)
    hs.hotkey.bind(cmd_ctrl,  "[",      function() spoon.WindowManager:top_left()                                end)
    hs.hotkey.bind(cmd_ctrl,  ";",      function() spoon.WindowManager:bottom_left()                             end)
    hs.hotkey.bind(cmd_ctrl,  "Down",   function() spoon.WindowManager:center()                                  end)
    hs.hotkey.bind(cmd_ctrl,  "Up",     function() spoon.WindowManager:full_screen()                             end)
    hs.hotkey.bind(cmd_ctrl,  "1",      function() spoon.PomodoroClock:start()                                   end)
    hs.hotkey.bind(cmd_ctrl,  "0",      function() spoon.PomodoroClock:stop()                                    end)
    hs.hotkey.bind(cmd_ctrl,  "2",      function() spoon.PomodoroClock:reset()                                   end)
    hs.hotkey.bind(cmd_shift, "1",      function() spoon.WindowManager:move_to_display(1)                        end)
    hs.hotkey.bind(cmd_shift, "2",      function() spoon.WindowManager:move_to_display(2)                        end)
    hs.hotkey.bind(ctrl_shift,"H",      show_listeners)
    hs.hotkey.bind(opt_shift, "1",       function() spoon.SpaceManager:move_window_to_space(1)                    end)
    hs.hotkey.bind(opt_shift, "2",       function() spoon.SpaceManager:move_window_to_space(2)                    end)
    hs.hotkey.bind(opt_shift, "3",       function() spoon.SpaceManager:move_window_to_space(3)                    end)
    hs.hotkey.bind(opt_shift, "4",       function() spoon.SpaceManager:move_window_to_space(4)                    end)
    hs.hotkey.bind(opt_shift, "5",       function() spoon.SpaceManager:move_window_to_space(5)                    end)
    hs.hotkey.bind(opt_shift, "6",       function() spoon.SpaceManager:move_window_to_space(6)                    end)
    hs.hotkey.bind(opt_shift, "N" ,      function() spoon.SpaceManager:create_new_space()                         end)
    hs.hotkey.bind(opt_shift, "L" ,      function() spoon.SpaceManager:debug_spaces()                             end)
end

return obj
