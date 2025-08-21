# Cherry.spoon - Enhanced Pomodoro Timer

An advanced Pomodoro Timer for Hammerspoon with full session management, statistics tracking, and beautiful UI.

## Features

### 🍒 Core Pomodoro Functionality
- **Work Sessions**: 25-minute focused work periods
- **Short Breaks**: 5-minute refreshing breaks  
- **Long Breaks**: 15-minute restorative breaks
- **Automatic Cycling**: Smart session progression with configurable long break intervals

### 📊 Session Management & Tracking
- **Session Tracking**: Keep track of completed sessions and current cycle
- **Daily Statistics**: Monitor work sessions, break time, and total focus time
- **Visual Progress**: See your productivity at a glance in the menu bar

### 🎨 Enhanced User Interface
- **Smart Menu Bar**: Dynamic icons showing session type (🍒 work, ☕ short break, 🌴 long break)
- **Rich Context Menu**: Full control with session info, statistics, and settings
- **Visual Status**: Pause indicator and session counter directly in menu bar
- **Beautiful Notifications**: Contextual alerts with encouraging messages
- **State Change Alerts**: Visual feedback for start, stop, pause, resume, and skip actions

### ⌨️ Keyboard Shortcuts
- **Cmd+Ctrl+Alt+C**: Start/Resume timer
- **Cmd+Ctrl+Alt+P**: Pause/Resume timer  
- **Cmd+Ctrl+Alt+S**: Stop timer
- **Cmd+Ctrl+Alt+N**: Skip current session

### ⚙️ Customization Options
- Configurable session durations
- Auto-start options for breaks and work sessions
- Custom notification settings
- Adjustable alert duration and text size

## Installation

1. Download Cherry.spoon to your `~/.hammerspoon/Spoons/` directory
2. Add to your `~/.hammerspoon/init.lua`:

```lua
hs.loadSpoon("Cherry")

-- Optional: Customize settings
spoon.Cherry.workDuration = 25          -- Work session length in minutes
spoon.Cherry.shortBreakDuration = 5     -- Short break length in minutes  
spoon.Cherry.longBreakDuration = 15     -- Long break length in minutes
spoon.Cherry.sessionsUntilLongBreak = 4 -- Work sessions before long break
spoon.Cherry.autoStartBreaks = false    -- Auto-start break timers
spoon.Cherry.autoStartWork = false      -- Auto-start work after breaks
spoon.Cherry.alwaysShow = true          -- Always show in menu bar

-- Bind hotkeys (optional - uses defaults if not specified)
spoon.Cherry:bindHotkeys({
  start = {{"cmd", "ctrl", "alt"}, "C"},
  pause = {{"cmd", "ctrl", "alt"}, "P"}, 
  stop = {{"cmd", "ctrl", "alt"}, "S"},
  skip = {{"cmd", "ctrl", "alt"}, "N"}
})

-- Start the spoon
spoon.Cherry:start()
```

## Usage

### Getting Started
1. Click the 🍒 icon in your menu bar or press **Cmd+Ctrl+Alt+C** to start a work session
2. Focus on your task for 25 minutes
3. When the timer completes, you'll get a notification to take a break
4. Start your break manually or enable auto-start in settings
5. After 4 work sessions, you'll automatically be prompted for a long break

### Menu Bar Interface
- **🍒 25:00**: Work session with time remaining
- **☕ 05:00**: Short break with time remaining  
- **🌴 15:00**: Long break with time remaining
- **⏸**: Indicates timer is paused
- **🍒4**: Shows completed sessions when timer is stopped

### Context Menu Options
Right-click the menu bar icon to access:
- **Start Different Sessions**: Work, short break, or long break
- **Timer Controls**: Pause, resume, stop, or skip
- **Session Info**: Current session type, completed sessions, cycle number
- **Statistics**: Today's work sessions and focus time
- **Settings**: View current configuration
- **Reset Stats**: Clear today's statistics

### Visual Alerts
Cherry.spoon provides immediate visual feedback for all timer state changes:
- **🍒 Work Session Started!** - When starting a pomodoro work session
- **☕ Short Break Started!** - When starting a 5-minute break
- **🌴 Long Break Started!** - When starting a 15-minute break
- **⏸ Timer Paused!** - When pausing the current timer
- **▶️ Timer Resumed!** - When resuming a paused timer
- **⏹ Timer Stopped!** - When stopping the timer completely
- **⏭ Session Skipped!** - When skipping to the next session
- **Session Complete!** - When any session finishes naturally

These alerts appear briefly in the center of your screen and can be customized or disabled through the configuration settings.

### Keyboard Shortcuts
All shortcuts can be customized in your configuration:
- **Start/Resume**: Begin a new work session or resume paused timer
- **Pause/Resume**: Toggle timer pause state
- **Stop**: Stop current timer and reset to stopped state  
- **Skip**: Complete current session immediately and advance to next

## Configuration Reference

### Timer Durations
```lua
spoon.Cherry.workDuration = 25          -- Minutes for work sessions
spoon.Cherry.shortBreakDuration = 5     -- Minutes for short breaks
spoon.Cherry.longBreakDuration = 15     -- Minutes for long breaks
spoon.Cherry.sessionsUntilLongBreak = 4 -- Work sessions before long break
```

### Automation Settings
```lua
spoon.Cherry.autoStartBreaks = false    -- Auto-start break timers
spoon.Cherry.autoStartWork = false      -- Auto-start work after breaks
```

### Display Settings  
```lua
spoon.Cherry.alwaysShow = true          -- Always show menu bar item
spoon.Cherry.alertDuration = 5          -- Session complete alert display time (seconds)
spoon.Cherry.alertTextSize = 80         -- Session complete alert text size
spoon.Cherry.stateAlertDuration = 2     -- State change alert display time (seconds)
spoon.Cherry.stateAlertTextSize = 50    -- State change alert text size
```

### Custom Notifications
```lua
spoon.Cherry.workCompleteNotification = hs.notify.new({
    title = "Custom Work Complete! 🍒",
    subTitle = "Custom subtitle",
    informativeText = "Custom message",
    withdrawAfter = 0
})

spoon.Cherry.breakCompleteNotification = hs.notify.new({
    title = "Custom Break Over! 🍒", 
    subTitle = "Custom subtitle",
    informativeText = "Custom message",
    withdrawAfter = 0
})
```

### Custom Sound
```lua
-- Use system sound
spoon.Cherry.sound = hs.sound.getByName("Glass")

-- Use custom sound file
spoon.Cherry.sound = hs.sound.getByFile("/path/to/sound.wav")

-- Disable sound
spoon.Cherry.sound = nil
```

## Changelog

### Version 1.0
- Complete rewrite with enhanced functionality
- Added break timer support (short and long breaks)
- Implemented session tracking and cycle management  
- Added daily statistics tracking
- Enhanced UI with dynamic icons and rich context menu
- Expanded keyboard shortcut support
- Improved notification system with contextual messages
- Added auto-start options for seamless workflow
- Backward compatibility with original Cherry.spoon API

### Version 0.1 (Original)
- Basic pomodoro timer functionality
- Simple menu bar integration
- Basic start/stop controls

## License

MIT License - Feel free to modify and distribute!
