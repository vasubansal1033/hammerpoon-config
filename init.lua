hs.logger.defaultLogLevel="info"

hyper       = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}
ctrl_cmd    = {"cmd","ctrl"}

-- The below is to setup spoonInstall. This spoon needs to be manually downloaded and installed. One done, this spoon can be configured to install and configure other spoons automatically.
hs.loadSpoon("SpoonInstall")

-- Below is an array of useful shortcuts that I use daily
local shortcuts = {
    default = {
        { "Alt + Shift + J/K", "Move between windows in same screen" },
        { "Alt + Shift + H/L", "Increase decrease size of window" },
        { "Alt + Shift + Enter", "Swap with main" },
        { "Alt + Shift + t", "Toggle floating" },
        { "Alt + Shift + Space", "Change between layouts" },
        { "Alt + Ctrl + Shift + T", "Enable/Disable Amethyst" },
        { "Alt + Shift + D", "Toggle between focusing on a particular screen" },
        { "Cmd/Windows + Tab", "Cycle through active windows in Mac" },
        { "Ctrl + F2", "Shortcut for screen menu bar" }
    },
    vim = {
        {"%", "Jump to the matching parenthesis, bracket, or brace"},
        {"*", "Search forward for the word under the cursor"},
        {"#", "Search backward for the word under the cursor"},
        {":s/old/new/", "Replace the first occurrence of 'old' with 'new' in the current line"},
        {":s/old/new/g", "Replace all occurrences of 'old' with 'new' in the current line"},
        {"ci<\",',(,{,[,<", "Change inside the container characters"},
        {"ca<\",',(,{,[,<", "Change everything, including container characters"},
        {"ciw", "Change the word the cursor is on"},
        {"caw", "Change the entire word, including spaces around it"},
        {"va{", "Visually select everything inside a block of curly braces"},
        {"vi{", "Visually select the contents inside a block, excluding braces"},
        {".", "Repeat the last edit command"},
        {"g.", "Repeat the last change but on a new selection"},
        {">", "Indent selected lines"},
        {"<", "Unindent selected lines"},
        {">>", "Indent the current line"},
        {"<<", "Unindent the current line"},
        {":m +1", "Move the current line down by one line"},
        {":m -2", "Move the current line up by one line"},
        {"~", "Toggle the case of the character under the cursor"},
        {"g~iw", "Toggle the case of the word the cursor is on"},
        {":sort", "Sort selected lines alphabetically"}
    }
}

--- Global variables
local shortcutsCanvas = nil
local visibleContentStart = 1
local visibleContentEnd = 10  -- Number of shortcuts visible at a time

-- Function to determine if we're in Vim inside iTerm
local function isVimInIterm()
    local frontApp = hs.application.frontmostApplication()
    local frontAppName = frontApp:name()
    if frontAppName == "iTerm2" then
        local windowTitle = frontApp:focusedWindow():title()
        return windowTitle:match("nvim") ~= nil
    end
    return false
end

-- Function to get shortcuts for the current application
local function getAppSpecificShortcuts()
    if isVimInIterm() then
        return shortcuts.vim
    end
    local focusedApp = hs.application.frontmostApplication():name()
    return shortcuts[focusedApp] or shortcuts.default
end

-- Function to toggle the shortcuts display
local function toggleShortcuts()
    if shortcutsCanvas then
        -- If the canvas already exists, delete it (hide the shortcuts)
        shortcutsCanvas:delete()
        shortcutsCanvas = nil
        visibleContentStart = 1
        visibleContentEnd = 8
    else
        -- Get shortcuts for the current app
        local appShortcuts = getAppSpecificShortcuts()

        -- Get screen dimensions
        local screenFrame = hs.screen.mainScreen():frame()

        -- Construct the visible message
        local function getVisibleMessage()
            local message = ""
            for i = visibleContentStart, math.min(visibleContentEnd, #appShortcuts) do
                local shortcut = appShortcuts[i]
                message = message .. shortcut[1] .. " - " .. shortcut[2] .. "\n"
            end
            return message
        end

        -- Create a canvas centered on the screen
        shortcutsCanvas = hs.canvas.new({
            x = screenFrame.x + (screenFrame.w / 2) - 200,  -- Center horizontally
            y = screenFrame.y + (screenFrame.h / 2) - 150,  -- Center vertically
            w = 600,  -- Width of the window
            h = 300   -- Height of the window
        }):show()

        -- Add elements to the canvas
        shortcutsCanvas:appendElements({
            {
                type = "rectangle",
                action = "fill",
                fillColor = { hex = "#000000", alpha = 0.7 }  -- Black with 70% opacity
            },
            -- Bold Title
            {
                type = "text",
                text = "Useful Shortcuts",
                textSize = 24,  -- Larger font size for the title
                textColor = { hex = "#FFFFFF" },  -- White text
                textAlignment = "center",
                frame = { x = "5%", y = "5%", w = "90%", h = "15%" }  -- Position the title at the top
            },
            -- Shortcut List
            {
                type = "text",
                text = getVisibleMessage(),
                textSize = 18,  -- Regular font size for the list
                textColor = { hex = "#FFFFFF" },  -- White text
                frame = { x = "5%", y = "20%", w = "90%", h = "75%" }  -- Position the text below the divider
            }
        })
    end
end

-- Function to handle scrolling in the canvas
local function scrollShortcuts(direction)
    if not shortcutsCanvas then return end

    -- Get shortcuts for the current app
    local appShortcuts = getAppSpecificShortcuts()
    local totalShortcuts = #appShortcuts

    -- Update visible content range
    if direction == "up" and visibleContentStart > 1 then
        visibleContentStart = visibleContentStart - 1
        visibleContentEnd = visibleContentEnd - 1
    elseif direction == "down" and visibleContentEnd < totalShortcuts then
        visibleContentStart = visibleContentStart + 1
        visibleContentEnd = visibleContentEnd + 1
    end

    -- Ensure visibleContentEnd does not exceed totalShortcuts
    visibleContentEnd = math.min(visibleContentEnd, totalShortcuts)

    -- Ensure visibleContentStart does not go below 1
    visibleContentStart = math.max(1, visibleContentStart)

    -- Update the displayed message
    local message = ""
    for i = visibleContentStart, visibleContentEnd do
        local shortcut = appShortcuts[i]
        message = message .. shortcut[1] .. " - " .. shortcut[2] .. "\n"
    end
    shortcutsCanvas[3].text = message
end

-- Bind the helper to Ctrl + Alt + /
hs.hotkey.bind({ "ctrl", "alt" }, "/", toggleShortcuts)

-- Bind scrolling functionality
hs.hotkey.bind({}, "up", function() scrollShortcuts("up") end)
hs.hotkey.bind({}, "down", function() scrollShortcuts("down") end)



-- Window Resizing. No other spoon is used for this.
-- Upper-Left corner
hs.hotkey.bind(hyper, "1", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x / 2
    f.y = max.y / 2
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)
-- Upper-Right corner
hs.hotkey.bind(hyper, "2", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y / 2
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)
-- Lower-Right corner
hs.hotkey.bind(hyper, "3", function()
local win = hs.window.focusedWindow()
local f = win:frame()
local screen = win:screen()
local max = screen:frame()

f.x = max.x + (max.w / 2)
f.y = max.y + (max.h / 2)
f.w = max.w
f.h = max.h / 2
win:setFrame(f)
end)
-- Lower-Left corner
hs.hotkey.bind(hyper, "4", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x / 2
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)
-- Maximize
hs.hotkey.bind(hyper, "m", function()
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
-- Left
hs.hotkey.bind(hyper, "Left", function()
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
hs.hotkey.bind(hyper, "Right", function()
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
-- Up
hs.hotkey.bind(hyper, "Up", function()
local win = hs.window.focusedWindow()
local f = win:frame()
local screen = win:screen()
local max = screen:frame()

f.x = 0
f.y = 0
f.w = max.w
f.h = max.h / 2
win:setFrame(f)
end)
-- Down
hs.hotkey.bind(hyper, "Down", function()
local win = hs.window.focusedWindow()
local f = win:frame()
local screen = win:screen()
local max = screen:frame()

f.x = 0
f.y = max.y + (max.h / 2)
f.w = max.w
f.h = max.h / 2
win:setFrame(f)
end)

-- Better Clipboard
-- Using TextClipboardHistory spoon for this.
spoon.SpoonInstall:andUse("TextClipboardHistory",
               {
                 disable = false,
                 config = {
                   show_in_menubar = false,
                   hist_size = 100,
                 },
                 hotkeys = {
                   toggle_clipboard = { { "cmd", "shift" }, "v" } },
                 start = true,
               }
)

-- call init-local which contains the google authenticator code generation setup

local localstuff=loadfile(hs.configdir .. "/init-local.lua")
if localstuff then
   localstuff()
end
