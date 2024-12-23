hs.logger.defaultLogLevel="info"

hyper       = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}
ctrl_cmd    = {"cmd","ctrl"}

-- The below is to setup spoonInstall. This spoon needs to be manually downloaded and installed. One done, this spoon can be configured to install and configure other spoons automatically.
hs.loadSpoon("SpoonInstall")

hs.loadSpoon("Badam")
spoon.Remembrall:bindHotkeys({
    toggle = {{"cmd", "shift"}, "/"}
})

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
