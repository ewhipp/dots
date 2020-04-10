--- === Application Launcher ===
---
--- Responsible for launching and listening to keys for application launching


--- Metadata
local obj = {}
obj.name = "Application Launcher"
obj.version = "1.0"
obj.author = "ewhipp <whipp.erik@gmail.com>"
obj.license = "MIT"
obj.homepage = nil

local logger = hs.logger.new("Application Launcher")
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

function obj:init() 
    print("[Application Launcher]: Setting listeners")
    hs.hotkey.bind(cmd_shift, "T", function() hs.application.launchOrFocus(programs.main_terminal)          end)
    hs.hotkey.bind(cmd_shift, "B", function() hs.application.launchOrFocus(programs.main_communication)     end)
    hs.hotkey.bind(cmd_shift, "M", function() hs.application.launchOrFocus(programs.main_music_program)     end)
    hs.hotkey.bind(cmd_shift, "C", function() hs.application.launchOrFocus(programs.main_text_communcation) end)
    hs.hotkey.bind(cmd_shift, "X", function() hs.application.launchOrFocus(programs.c_editor)               end)
    hs.hotkey.bind(cmd,       "W", function() hs.application.launchOrFocus(programs.main_browser)           end)
    hs.hotkey.bind(cmd,       "M", function() hs.application.launchOrFocus(programs.mail_program)           end)
    hs.hotkey.bind(cmd,       "E", function() hs.application.launchOrFocus(programs.main_editor)            end)
end

return obj