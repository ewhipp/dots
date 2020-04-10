

--- === Pomodoro Clock ===
---
--- Mimics the functionality of a standard pomodoro clock
---
--- Configurable properties
---   time to work
---   time to rest
---   job to complete
---   bar indicator at the top of the screen height

--- Metadata
local obj = {}
obj.name = "Pomodoro Clock"
obj.version = "1.0"
obj.author = "ewhipp <whipp.erik@gmail.com>"
obj.license = "MIT"
obj.homepage = "nil"

local logger = hs.logger.new("Pomodoro Clock")
obj.logger = logger

-- Defaults
obj._attribs = {
    time_to_work = 25,
    time_to_rest = 5,
    job_to_complete = "",
    bar_height = 0.1
}

for key, val in pairs(obj._attribs) do obj[key] = val end

--- PomodoroClock:init()
--- Method
--- init.
---
--- Parameters: None
---
--- Returns:
---  * Initial Pomodoro clock
function obj:init()
    print('[Pomodoro]: Initializing PomodoroClock:init()')
    local pom = {}

    pom.bar = {
        indicator_height = obj.bar_height,
        indicator_in_all_spaces = true,
        color_time_remaining = hs.drawing.color.green,
        color_time_used = hs.drawing.color.red,
        time_unused = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0)),
        time_used = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0)) 
    }

    pom.config = {
        enable_color_bar = true,
        work_period_sec = self.time_to_work * 60,
        rest_period_sec = self.time_to_rest * 60
    }

    pom.var = {
        is_active = false,
        disable_count = 0,
        work_count = 0,
        work_objective = self.job_to_complete,
        curr_active_type = "work",
        time_left = pom.config.work_period_sec,
        max_time_sec = pom.config.work_period_sec
    }

    if not self.pom then self.pom = pom end
    return self

end

--- PomodoroClock:start()
--- Method
--- Starts the Pomodoro clock with current configuration
function obj:start()
    print(string.format("[Pomodoro]: Starting Pomodoro Clock\n[Time to work] = [%s]\t[Time to rest] = [%s]", 
      obj.time_to_work, 
      obj.time_to_rest)
    )
    local notification_window = hs.notify.new(
        function() return end, 
        { 
          title="Time to start working", 
          soundName="Glass.aiff"
        })
    notification_window:send()

    obj.pom.var.disable_count = 0;

    if (obj.pom.var.is_active) then
        return
    end

    pom_create_menu()
    pom_timer = hs.timer.new(1, pom_update_time)

    obj.pom.var.is_active = true
    pom_timer:start()
end

--- PomodoroClock:disable()
--- Method
--- Stops the Pomodoro clock at the current time
function obj:stop()
    print("[Pomodoro]: Stopping Pomodoro Clock")
    local pom_was_active = obj.pom.var.is_active
    obj.pom.var.is_active = false

    if (obj.pom.var.disable_count == 0) then
        if (pom_was_active) then 
            pom_timer:stop() 
        end

    elseif (obj.pom.var.disable_count == 1) then
        obj.pom.var.time_left = self.pom.config.work_period_sec
        obj.pom.var.curr_active_type = "work"
        pom_update_time()

    elseif (obj.pom.var.disable_count >= 2) then
        if pom_menu == nil then
            obj.pom.var.disable_count = 2
            return
        end

        pom_menu:delete()
        pom_menu = nil
        pom_timer:stop()
        pom_timer = nil
        pom_del_indicators()
    end

    obj.pom.var.disable_count = obj.pom.var.disable_count + 1
end

--------- COLOR BAR FOR POMODORO ---------

function pom_del_indicators()
    pom.bar.time_unused:delete()
    pom.bar.time_used:delete()
end

function pom_draw_time_left_on_menu(target_draw, screen, offset, width,
                                    fill_color)
    local screeng = screen:fullFrame()
    local screen_frame_height = screen:frame().y
    local screen_full_frame_height = screeng.y
    local height_delta = screen_frame_height - screen_full_frame_height
    local height = obj.pom.bar.indicator_height * (height_delta)

    -- AS THE TIME PROGRESSES
    target_draw:setSize(hs.geometry.rect(screeng.x + offset,
                                         screen_full_frame_height, width, height))
    target_draw:setTopLeft(hs.geometry.point(screeng.x + offset,
                                             screen_full_frame_height))
    target_draw:setFillColor(fill_color)
    target_draw:setFill(true)
    target_draw:setLevel(hs.drawing.windowLevels.overlay)
    target_draw:setStroke(false)
    if obj.pom.bar.indicator_in_all_spaces then
        target_draw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
    end

    target_draw:show()
end

function pom_draw_indicator(time_left, max_time)
    local main_screen = hs.screen.mainScreen()
    local screeng = main_screen:fullFrame()
    local time_ratio = time_left / max_time
    local width = math.ceil(screeng.w * time_ratio)
    local left_width = screeng.w - width

    pom_draw_time_left_on_menu(obj.pom.bar.time_unused, main_screen, left_width, width,
                               obj.pom.bar.color_time_remaining)
    pom_draw_time_left_on_menu(obj.pom.bar.time_used, main_screen, 0, left_width,
                               obj.pom.bar.color_time_used)
end

function pom_time_display()
    local time_min = math.floor((pom.var.time_left / 60))
    local time_sec = obj.pom.var.time_left - (time_min * 60)
    local str = string.format("[%s|%02d:%02d|#%02d]", pom.var.curr_active_type,
                              time_min, time_sec, pom.var.work_count)
    pom_menu:setTitle(str)
end

function pom_update_time()
    if obj.pom.var.is_active == false then
        return
    else
        obj.pom.var.time_left = obj.pom.var.time_left - 1

        if (obj.pom.var.time_left <= 0) then
            pom_disable()
            if obj.pom.var.curr_active_type == "work" then
                hs.alert.show("Work Complete!", 2)
                obj.pom.var.work_count = pom.var.work_count + 1
                obj.pom.var.curr_active_type = "rest"
                local notification_window = hs.notify.new(
                    function() return end, 
                    { 
                        title="Time to rest!", 
                        soundName="Glass.aiff"
                    })
                notification_window:send()
                obj.pom.var.time_left = pom.config.rest_period_sec
                obj.pom.var.max_time_sec = pom.config.rest_period_sec
            else
                local notification_window = hs.notify.new(
                    function() return end, 
                    { 
                        title="Time to work!", 
                        soundName="Glass.aiff"
                    })
                notification_window:send()
                obj.pom.var.curr_active_type = "work"
                obj.pom.var.time_left = pom.config.work_period_sec
                obj.pom.var.max_time_sec = pom.config.work_period_sec
            end
        end

        if (obj.pom.config.enable_color_bar == true) then
            pom_draw_indicator(obj.pom.var.time_left, obj.pom.var.max_time_sec)
        end

    end
end

function pom_timer()
    pom_update_time()
    pom_time_display()
end

function pom_create_menu()
    if pom_menu == nil then
        pom_menu = hs.menubar.new()
        obj.pom.bar.time_unused = hs.drawing.rectangle(hs.geometry.rect(0, 0, 0, 0))
        obj.pom.bar.time_used = hs.drawing.rectangle(hs.geometry.rect(0, 0, 0, 0))
    end
end

function pom_reset_timer() pom.var.work_count = 0; end

return obj