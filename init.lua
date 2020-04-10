-- Hammerspoon configuration by Erik Whipp
--------- COMBINATIONS -----------------
local cmd_shift = {"cmd", "shift"}
local cmd_ctrl = {"cmd", "ctrl"}
local cmd_alt_ctrl = {"cmd", "alt", "ctrl"};

--------- PROGRAMS -----------------
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

--------- RELOAD CONFIG AUTO ------------

function reloadConfig(files)
    reloadCompleted = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then reloadCompleted = true end
    end
    if reloadCompleted then hs.reload() end
end
a
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Success")

--------- APPLICATION COMMANDS ---------
hs.hotkey.bind(cmd_shift, "T",
               function() hs.application.launchOrFocus(programs.main_terminal) end)

hs.hotkey.bind(cmd_shift, "B",
               function() hs.application.launchOrFocus(programs.main_communication) end)

hs.hotkey.bind(cmd_shift, "M",
               function() hs.application.launchOrFocus(programs.main_music_program) end)

hs.hotkey.bind(cmd_shift, "C",
               function() hs.application.launchOrFocus(programs.main_text_communcation) end)

hs.hotkey.bind(cmd_shift, "X",
               function() hs.application.launchOrFocus(programs.c_editor) end)

hs.hotkey.bind({"cmd"}, "W",
               function() hs.application.launchOrFocus(programs.main_browser) end)

hs.hotkey.bind({"cmd"}, "M",
               function() hs.application.launchOrFocus(programs.mail_program) end)

hs.hotkey.bind({"cmd"}, "E",
               function() hs.application.launchOrFocus(programs.main_editor) end)
-------- APPLICATIONS END  -------------

hs.loadSpoon("PomodoroClock")
hs.hotkey.bind(cmd_ctrl, "1", function() spoon.PomodoroClock:start() end)
hs.hotkey.bind(cmd_ctrl, '0', function() spoon.PomodoroClock:stop()  end)
hs.hotkey.bind(cmd_ctrl, '2', function() spoon.PomodoroClock:reset() end)

hs.loadSpoon("WindowManager")
hs.hotkey.bind(cmd_ctrl, "Left",    function() spoon.WindowManager:left()            end)
hs.hotkey.bind(cmd_ctrl, "Right",   function() spoon.WindowManager:right()           end)
hs.hotkey.bind(cmd_ctrl, "]",       function() spoon.WindowManager:top_right()       end)
hs.hotkey.bind(cmd_ctrl, "'",       function() spoon.WindowManager:bottom_right()    end)
hs.hotkey.bind(cmd_ctrl, "[",       function() spoon.WindowManager:top_left()        end)
hs.hotkey.bind(cmd_ctrl, ";",       function() spoon.WindowManager:bottom_left()     end)
hs.hotkey.bind(cmd_ctrl, "Down",    function() spoon.WindowManager:center()          end)
hs.hotkey.bind(cmd_ctrl, "Up",      function() spoon.WindowManager:full_screen()     end)
hs.hotkey.bind(cmd_shift, "1",      function() spoon.WindowManager:move_to_display(1)  end)
hs.hotkey.bind(cmd_shift, "2",      function() spoon.WindowManager:move_to_display(2)  end)
