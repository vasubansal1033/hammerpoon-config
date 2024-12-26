hs.logger.defaultLogLevel="info"

hyper       = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}
ctrl_cmd    = {"cmd","ctrl"}
cmd_shift   = {"cmd", "shift"}

-- The below is to setup spoonInstall. This spoon needs to be manually downloaded and installed. One done, this spoon can be configured to install and configure other spoons automatically.
hs.loadSpoon("SpoonInstall")

hs.loadSpoon("Badam")
spoon.Badam:bindHotkeys({
    toggle = {cmd_shift, "/"}
})

-- Below is to setup ReloadConfiguration
hs.loadSpoon("ReloadConfiguration")
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
    hs.alert.show("Hammerspoon configuration reloaded")
end)
-- Window Resizing. No other spoon is used for this.
hs.loadSpoon("WindowResizing")
spoon.WindowResizing:bindHotkeys({
    upperLeft  = {hyper, "1"},
    upperRight = {hyper, "2"},
    lowerLeft = {hyper, "3"},
    lowerRight = {hyper, "4"},
    maximize = {hyper, "m"},
    left = {hyper, "Left"},
    right = {hyper, "Right"},
    up = {hyper, "Up"},
    down = {hyper, "Down"},
})

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

-- -- call init-local which contains the google authenticator code generation setup
-- local localstuff=loadfile(hs.configdir .. "/init-local.lua")
-- if localstuff then
--    localstuff()
-- end
