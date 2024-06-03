local obj = {}
obj.name = 'Space Manager'
obj.version = '0.1'
obj.author = 'ewhipp <engineering.scientist167@passmail.net>'
obj.license = 'MIT'
obj.homepage = nil

local logger = hs.logger.new("Pomodoro Clock")
obj.logger = logger

obj._expected_monitors = {
    primary = hs.screen.find('Built%-in'),
    secondary = hs.screen.find('Alienware'), -- to fill in
    tertiary = 'Samsung', -- to fill in
    mini_secondary = hs.screen.find('DELL P1424H')
}


for key, val in pairs(obj._expected_monitors) do obj[key] = val end

function obj:init() 
    local needed_spaces = 6
    local spaces = hs.spaces.allSpaces()
    obj.spaces = {}

    for k, space_ids in pairs(spaces) do 
        for a, space_id in pairs(space_ids) do
            obj.spaces[a] = space_id
            needed_spaces = needed_spaces - 1
        end
    end

    while needed_spaces >= 0 do
        hs.spaces.addSpaceToScreen(hs.screen.primaryScreen())
        needed_spaces = needed_spaces - 1
    end
end

function obj:create_new_space() 
    if obj.secondary ~= nil then
        hs.spaces.addSpaceToScreen(obj.secondary, false)
    else 
        hs.spaces.addSpaceToScreen(hs.screen.primaryScreen(), false)
    end
end

function obj:go_to_space(space_number)
    hs.spaces.gotoSpace(space_number) 
end

function obj:move_window_to_space(space)
    print(space)
    local space_id = obj.spaces[space]
    print("[SpaceManager] Going to space_id: " .. tostring(space_id) .. "\tspace: " .. tostring(space))
    local window = hs.window.focusedWindow()
    hs.spaces.moveWindowToSpace(window, space_id, true)
    hs.spaces.gotoSpace(space_id)
end

function obj:debug_spaces() 
    for k,v in pairs(obj.spaces) do
        print(k,v)
    end
end
return obj