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
cmd_alt_ctrl = {"cmd", "alt", "ctrl"};
cmd = { "cmd" }

local programs = {
    main_browser="Safari",
    main_editor="Code",
    main_terminal="Terminal",
    main_communication="Slack",
    main_mail="Mail",
    main_music_program="Amazon Music",
    main_text_communcation="Messages",
    c_editor="xCode"
}

hs.loadSpoon("PomodoroClock")
hs.loadSpoon("WindowManager")

function obj:init() 
    print("[Key Listener]: Setting listeners")
    hs.hotkey.bind(cmd_shift, "T",      function() hs.application.launchOrFocus(programs.main_terminal)          end)
    hs.hotkey.bind(cmd_shift, "B",      function() hs.application.launchOrFocus(programs.main_communication)     end)
    hs.hotkey.bind(cmd_shift, "M",      function() hs.application.launchOrFocus(programs.main_music_program)     end)
    hs.hotkey.bind(cmd_shift, "C",      function() hs.application.launchOrFocus(programs.main_text_communcation) end)
    hs.hotkey.bind(cmd_shift, "X",      function() hs.application.launchOrFocus(programs.c_editor)               end)
    hs.hotkey.bind(cmd,       "W",      function() hs.application.launchOrFocus(programs.main_browser)           end)
    hs.hotkey.bind(cmd,       "M",      function() hs.application.launchOrFocus(programs.mail_program)           end)
    hs.hotkey.bind(cmd,       "E",      function() hs.application.launchOrFocus(programs.main_editor)            end)
    hs.hotkey.bind(cmd_ctrl,  "Left",   function() spoon.WindowManager:left()                                    end)
    hs.hotkey.bind(cmd_ctrl,  "Right",  function() spoon.WindowManager:right()                                   end)
    hs.hotkey.bind(cmd_ctrl,  "]",      function() spoon.WindowManager:top_right()                               end)
    hs.hotkey.bind(cmd_ctrl,  "'",      function() spoon.WindowManager:bottom_right()                            end)
    hs.hotkey.bind(cmd_ctrl,  "[",      function() spoon.WindowManager:top_left()                                end)
    hs.hotkey.bind(cmd_ctrl,  ";",      function() spoon.WindowManager:bottom_left()                             end)
    hs.hotkey.bind(cmd_ctrl,  "Down",   function() spoon.WindowManager:center()                                  end)
    hs.hotkey.bind(cmd_ctrl,  "Up",     function() spoon.WindowManager:full_screen()                             end)
    hs.hotkey.bind(cmd_shift, "1",      function() spoon.WindowManager:move_to_display(1)                        end)
    hs.hotkey.bind(cmd_shift, "2",      function() spoon.WindowManager:move_to_display(2)                        end)
    hs.hotkey.bind(cmd_ctrl,  "1",      function() spoon.PomodoroClock:start()                                   end)
    hs.hotkey.bind(cmd_ctrl,  "0",      function() spoon.PomodoroClock:stop()                                    end)
    hs.hotkey.bind(cmd_ctrl,  "2",      function() spoon.PomodoroClock:reset()                                   end)
end

return obj