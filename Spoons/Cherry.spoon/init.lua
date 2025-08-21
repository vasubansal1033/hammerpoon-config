--- === Cherry ===
---
--- Cherry tomato (Enhanced Pomodoro Timer) -- A full-featured Pomodoro Timer for the menubar
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Cherry.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Cherry.spoon.zip)
---

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Cherry"
obj.version = "1.0"
obj.author = "Daniel Marques <danielbmarques@gmail.com> and Omar El-Domeiri <omar@doesnotexist.com>"
obj.license = "MIT"
obj.homepage = "https://github.com/Hammerspoon/Spoons"

-- Timer States
obj.TIMER_STOPPED = 0
obj.TIMER_RUNNING = 1
obj.TIMER_PAUSED = 2
obj.TIMER_BREAK = 3

-- Session Types
obj.SESSION_WORK = "work"
obj.SESSION_SHORT_BREAK = "short_break"
obj.SESSION_LONG_BREAK = "long_break"

-- Settings

-- Work session duration in minutes
obj.workDuration = 25

-- Short break duration in minutes
obj.shortBreakDuration = 5

-- Long break duration in minutes
obj.longBreakDuration = 15

-- Number of work sessions before long break
obj.sessionsUntilLongBreak = 4

-- set this to true to always show the menubar item
obj.alwaysShow = true

-- duration in seconds for alert to stay on screen
-- set to 0 to turn off alert completely
obj.alertDuration = 5

-- duration in seconds for state change alerts (start, stop, pause, resume)
-- set to 0 to turn off state alerts completely
obj.stateAlertDuration = 2

-- Font size for alert
obj.alertTextSize = 80

-- Font size for state change alerts
obj.stateAlertTextSize = 50

-- Auto-start breaks
obj.autoStartBreaks = false

-- Auto-start work sessions after breaks
obj.autoStartWork = false

-- Enhanced notifications with defaults
obj.workCompleteNotification = hs.notify.new({
    title = "Work Session Complete! 🍒",
    subTitle = "Time for a break",
    informativeText = "Great job! Take a well-deserved break.",
    withdrawAfter = 0
})

obj.breakCompleteNotification = hs.notify.new({
    title = "Break Over! 🍒",
    subTitle = "Ready to get back to work?",
    informativeText = "Feeling refreshed? Let's continue being productive!",
    withdrawAfter = 0
})

-- Default notification sound
obj.sound = hs.sound.getByName("Ping")

obj.defaultMapping = {
  start = {{"cmd", "ctrl", "alt"}, "C"},
  pause = {{"cmd", "ctrl", "alt"}, "P"},
  stop = {{"cmd", "ctrl", "alt"}, "S"},
  skip = {{"cmd", "ctrl", "alt"}, "N"}
}


--- Cherry:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for Cherry
---
--- Parameters:
---  * mapping - A table containing hotkey details for the following items:
---   * start - start the pomodoro timer (Default: cmd-ctrl-alt-C)
---   * pause - pause/resume the timer (Default: cmd-ctrl-alt-P)
---   * stop - stop the timer (Default: cmd-ctrl-alt-S)
---   * skip - skip current session (Default: cmd-ctrl-alt-N)
function obj:bindHotkeys(mapping)
  -- Clean up existing hotkeys
  if self.hotkeys then
    for _, hotkey in pairs(self.hotkeys) do
      hotkey:delete()
    end
  end
  self.hotkeys = {}

  local map = mapping or self.defaultMapping
  
  if map["start"] then
    table.insert(self.hotkeys, hs.hotkey.bind(map["start"][1], map["start"][2], function() self:start() end))
  end
  
  if map["pause"] then
    table.insert(self.hotkeys, hs.hotkey.bind(map["pause"][1], map["pause"][2], function() self:togglePause() end))
  end
  
  if map["stop"] then
    table.insert(self.hotkeys, hs.hotkey.bind(map["stop"][1], map["stop"][2], function() self:stop() end))
  end
  
  if map["skip"] then
    table.insert(self.hotkeys, hs.hotkey.bind(map["skip"][1], map["skip"][2], function() self:skip() end))
  end
end


function obj:init()
  self.menu = hs.menubar.new(self.alwaysShow)
  
  -- Initialize session tracking
  self.currentSession = self.SESSION_WORK
  self.completedSessions = 0
  self.currentCycle = 1
  self.timerState = self.TIMER_STOPPED
  self.todayStats = {
    workSessions = 0,
    shortBreaks = 0,
    longBreaks = 0,
    focusTime = 0 -- in minutes
  }
  
  self:reset()
end


function obj:reset()
  if self.timer then
    self.timer:stop()
    self.timer = nil
  end
  
  self.timerState = self.TIMER_STOPPED
  self.timerRunning = false
  self.timeLeft = 0
  
  self:updateMenu()
  self:updateMenubarTitle()
  
  if not self.alwaysShow then
      self.menu:removeFromMenuBar()
  end
end


function obj:updateMenubarTitle()
  local title = "🍒"
  
  if self.timerState == self.TIMER_RUNNING or self.timerState == self.TIMER_PAUSED then
    local minutes = math.floor(self.timeLeft / 60)
    local seconds = self.timeLeft - (minutes * 60)
    local timeStr = string.format("%02d:%02d", minutes, seconds)
    
    local sessionIcon = "🍒"
    if self.currentSession == self.SESSION_SHORT_BREAK then
      sessionIcon = "☕"
    elseif self.currentSession == self.SESSION_LONG_BREAK then
      sessionIcon = "🌴"
    end
    
    local statusIcon = ""
    if self.timerState == self.TIMER_PAUSED then
      statusIcon = " ⏸"
    end
    
    title = timeStr .. " " .. sessionIcon .. statusIcon
  else
    -- Show completed sessions when stopped
    if self.completedSessions > 0 then
      title = "🍒" .. self.completedSessions
    end
  end
  
  self.menu:setTitle(title)
end

function obj:updateMenu()
  local items = {}
  
  if self.timerState == self.TIMER_STOPPED then
    table.insert(items, { title = "🍒 Start Pomodoro", fn = function() self:startWork() end })
    table.insert(items, { title = "☕ Start Short Break", fn = function() self:startShortBreak() end })
    table.insert(items, { title = "🌴 Start Long Break", fn = function() self:startLongBreak() end })
    table.insert(items, { title = "-" })
  elseif self.timerState == self.TIMER_RUNNING then
    table.insert(items, { title = "⏸ Pause", fn = function() self:pause() end })
    table.insert(items, { title = "⏹ Stop", fn = function() self:stop() end })
    table.insert(items, { title = "⏭ Skip Session", fn = function() self:skip() end })
    table.insert(items, { title = "-" })
  elseif self.timerState == self.TIMER_PAUSED then
    table.insert(items, { title = "▶️ Resume", fn = function() self:resume() end })
    table.insert(items, { title = "⏹ Stop", fn = function() self:stop() end })
    table.insert(items, { title = "⏭ Skip Session", fn = function() self:skip() end })
    table.insert(items, { title = "-" })
  end
  
  -- Current session info
  local sessionName = "Work Session"
  if self.currentSession == self.SESSION_SHORT_BREAK then
    sessionName = "Short Break"
  elseif self.currentSession == self.SESSION_LONG_BREAK then
    sessionName = "Long Break"
  end
  
  table.insert(items, { title = "Current: " .. sessionName, disabled = true })
  table.insert(items, { title = "Sessions Completed: " .. self.completedSessions, disabled = true })
  table.insert(items, { title = "Cycle: " .. self.currentCycle, disabled = true })
  table.insert(items, { title = "-" })
  
  -- Statistics
  table.insert(items, { title = "Today's Stats:", disabled = true })
  table.insert(items, { title = "  Work Sessions: " .. self.todayStats.workSessions, disabled = true })
  table.insert(items, { title = "  Focus Time: " .. self.todayStats.focusTime .. " min", disabled = true })
  table.insert(items, { title = "-" })
  
  -- Settings shortcuts
  table.insert(items, { title = "⚙️ Settings", fn = function() self:showSettings() end })
  table.insert(items, { title = "📊 Reset Today's Stats", fn = function() self:resetTodayStats() end })
  
  self.menu:setMenu(items)
end


--- Cherry:popup()
--- Method
--- Popup an alert or notification when time is up.
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function obj:showStateAlert(message)
  if self.stateAlertDuration > 0 then
    hs.alert.show(message, { textSize = self.stateAlertTextSize }, self.stateAlertDuration)
  end
end

function obj:popup()
  local alertText = "Session Complete! 🍒"
  local notification = nil
  
  if self.currentSession == self.SESSION_WORK then
    alertText = "Work Session Complete! 🍒"
    notification = self.workCompleteNotification
    self.todayStats.workSessions = self.todayStats.workSessions + 1
    self.todayStats.focusTime = self.todayStats.focusTime + self.workDuration
  elseif self.currentSession == self.SESSION_SHORT_BREAK then
    alertText = "Short Break Over! ☕"
    notification = self.breakCompleteNotification
    self.todayStats.shortBreaks = self.todayStats.shortBreaks + 1
  elseif self.currentSession == self.SESSION_LONG_BREAK then
    alertText = "Long Break Over! 🌴"
    notification = self.breakCompleteNotification
    self.todayStats.longBreaks = self.todayStats.longBreaks + 1
  end
  
  if 0 < self.alertDuration then
    hs.alert.show(alertText, { textSize = self.alertTextSize }, self.alertDuration)
  end
  
  if notification then
    notification:send()
  end
  
  if self.sound then
    self.sound:play()
  end
end


function obj:tick()
  self.timeLeft = self.timeLeft - 1
  self:updateMenubarTitle()
  
  if self.timeLeft <= 0 then
    self:completeSession()
  end
end

function obj:completeSession()
  -- Stop the timer
  if self.timer then
    self.timer:stop()
    self.timer = nil
  end
  self.timerRunning = false
  
  -- Show completion notification
  self:popup()
  
  -- Update session tracking
  if self.currentSession == self.SESSION_WORK then
    self.completedSessions = self.completedSessions + 1
    
    -- Determine next session
    if self.completedSessions % self.sessionsUntilLongBreak == 0 then
      self.currentSession = self.SESSION_LONG_BREAK
      self.currentCycle = self.currentCycle + 1
    else
      self.currentSession = self.SESSION_SHORT_BREAK
    end
  else
    -- After any break, return to work
    self.currentSession = self.SESSION_WORK
  end
  
  -- Auto-start next session if enabled
  if (self.currentSession == self.SESSION_WORK and self.autoStartWork) or
     (self.currentSession ~= self.SESSION_WORK and self.autoStartBreaks) then
    hs.timer.doAfter(2, function() self:startCurrentSession() end)
  else
    self.timerState = self.TIMER_STOPPED
    self:updateMenu()
    self:updateMenubarTitle()
  end
end

--- Cherry:start() - Legacy method for backward compatibility
--- Method
--- Starts a work session
---
--- Parameters:
---  * resume - boolean when true resumes countdown at current value of self.timeLeft
---
--- Returns:
---  * None
function obj:start(resume)
  self:startWork(resume)
end

function obj:startCurrentSession()
  if self.currentSession == self.SESSION_WORK then
    self:startWork()
  elseif self.currentSession == self.SESSION_SHORT_BREAK then
    self:startShortBreak()
  elseif self.currentSession == self.SESSION_LONG_BREAK then
    self:startLongBreak()
  end
end

function obj:startWork(resume)
  self:startSession(self.workDuration, self.SESSION_WORK, resume)
end

function obj:startShortBreak(resume)
  self:startSession(self.shortBreakDuration, self.SESSION_SHORT_BREAK, resume)
end

function obj:startLongBreak(resume)
  self:startSession(self.longBreakDuration, self.SESSION_LONG_BREAK, resume)
end

function obj:startSession(duration, sessionType, resume)
  if not self.menu:isInMenuBar() then
    self.menu:returnToMenuBar()
  end
  
  if not resume then
    self.timeLeft = duration * 60
    self.currentSession = sessionType
    
    -- Show start alert
    local alertMessage = "Started! 🍒"
    if sessionType == self.SESSION_WORK then
      alertMessage = "Work Session Started! 🍒"
    elseif sessionType == self.SESSION_SHORT_BREAK then
      alertMessage = "Short Break Started! ☕"
    elseif sessionType == self.SESSION_LONG_BREAK then
      alertMessage = "Long Break Started! 🌴"
    end
    self:showStateAlert(alertMessage)
  else
    -- Resume alert
    self:showStateAlert("Timer Resumed! ▶️")
  end
  
  self.timerState = self.TIMER_RUNNING
  self.timerRunning = true
  self.timer = hs.timer.doWhile(function() return self.timerRunning end, function() self:tick() end, 1)
  
  self:updateMenu()
  self:updateMenubarTitle()
end

function obj:pause()
  if self.timerState == self.TIMER_RUNNING then
    self.timerRunning = false
    self.timerState = self.TIMER_PAUSED
    self:showStateAlert("Timer Paused! ⏸")
    self:updateMenu()
    self:updateMenubarTitle()
  end
end

function obj:resume()
  if self.timerState == self.TIMER_PAUSED then
    self.timerRunning = true
    self.timerState = self.TIMER_RUNNING
    self.timer = hs.timer.doWhile(function() return self.timerRunning end, function() self:tick() end, 1)
    self:showStateAlert("Timer Resumed! ▶️")
    self:updateMenu()
    self:updateMenubarTitle()
  end
end

function obj:togglePause()
  if self.timerState == self.TIMER_RUNNING then
    self:pause()
  elseif self.timerState == self.TIMER_PAUSED then
    self:resume()
  end
end

function obj:stop()
  if self.timer then
    self.timer:stop()
    self.timer = nil
  end
  self.timerRunning = false
  self.timerState = self.TIMER_STOPPED
  self.timeLeft = 0
  self:showStateAlert("Timer Stopped! ⏹")
  self:updateMenu()
  self:updateMenubarTitle()
end

function obj:skip()
  if self.timerState == self.TIMER_RUNNING or self.timerState == self.TIMER_PAUSED then
    self:showStateAlert("Session Skipped! ⏭")
    self:completeSession()
  end
end

function obj:resetTodayStats()
  self.todayStats = {
    workSessions = 0,
    shortBreaks = 0,
    longBreaks = 0,
    focusTime = 0
  }
  self:updateMenu()
  hs.alert.show("Today's statistics reset! 📊", 2)
end

function obj:showSettings()
  local settingsText = string.format([[
🍒 Cherry Pomodoro Settings:

Work Duration: %d minutes
Short Break: %d minutes  
Long Break: %d minutes
Sessions until Long Break: %d

Auto-start Breaks: %s
Auto-start Work: %s

Customize these settings in your init.lua file.
]], 
    self.workDuration, 
    self.shortBreakDuration, 
    self.longBreakDuration, 
    self.sessionsUntilLongBreak,
    self.autoStartBreaks and "Yes" or "No",
    self.autoStartWork and "Yes" or "No"
  )
  
  hs.alert.show(settingsText, 8)
end


return obj
