local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Badam"
obj.version = "1.0"
obj.author = "vasubansal1033 <vasubansal1998@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.commandEnum = {
    cmd = '⌘',
    shift = '⇧',
    alt = '⌥',
    ctrl = '⌃',
    tab = "↹",
    space = "␣",
}

-- App-specific hardcoded shortcuts
local appSpecificShortcuts = {
    ["iTerm2"] = {
        {
            category = "Vim",
            shortcuts = {
                {modifiers = obj.commandEnum.ctrl, keys = "P", description = "Telescope file viewer"},
                {modifiers = obj.commandEnum.ctrl, keys = "n", description = "Open file explorer on left"},
                {modifiers = "Q", keys = ":", description = "Open command history"},
                {modifiers = nil, keys = "%", description = "Jump to the matching parenthesis, bracket, or brace"},
                {modifiers = nil, keys = "*", description = "Search forward for the word under the cursor"},
                {modifiers = nil, keys = "#", description = "Search backward for the word under the cursor"},
                {modifiers = nil, keys = ":s/old/new/", description = "Replace the first occurrence of 'old' with 'new' in the current line"},
                {modifiers = nil, keys = ":s/old/new/g", description = "Replace all occurrences of 'old' with 'new' in the current line"},
                {modifiers = "ci", keys = "<, \", ', (, {, [, <", description = "Change inside the container characters"},
                {modifiers = "ca", keys = "<, \", ', (, {, [, <", description = "Change everything, including container characters"},
                {modifiers = "ci", keys = "w", description = "Change the word the cursor is on"},
                {modifiers = "ca", keys = "w", description = "Change the entire word, including spaces around it"},
                {modifiers = obj.commandEnum.shift, keys = "va{", description = "Visually select everything inside a block of curly braces"},
                {modifiers = obj.commandEnum.shift, keys = "vi{", description = "Visually select the contents inside a block, excluding braces"},
                {modifiers = nil, keys = ".", description = "Repeat the last edit command"},
                {modifiers = obj.commandEnum.shift, keys = "g.", description = "Repeat the last change but on a new selection"},
                {modifiers = nil, keys = ">", description = "Indent selected lines"},
                {modifiers = nil, keys = "<", description = "Unindent selected lines"},
                {modifiers = nil, keys = ">>", description = "Indent the current line"},
                {modifiers = nil, keys = "<<", description = "Unindent the current line"},
                {modifiers = nil, keys = ":m +1", description = "Move the current line down by one line"},
                {modifiers = nil, keys = ":m -2", description = "Move the current line up by one line"},
                {modifiers = nil, keys = "~", description = "Toggle the case of the character under the cursor"},
                {modifiers = nil, keys = "g~iw", description = "Toggle the case of the word the cursor is on"},
                {modifiers = nil, keys = ":sort", description = "Sort selected lines alphabetically"},
            }
        },
        {
            category = "ITerm2",
            shortcuts = {
                {modifiers = obj.commandEnum.cmd, keys = "_", description = "Undo the last change"},
                {modifiers = nil, keys = "bindkey", description = "List all keyboard mappings"},
                {modifiers = obj.commandEnum.cmd, keys = "1/2/3", description = "Change window"},
                {modifiers = obj.commandEnum.cmd, keys = "[ ]", description = "Cycle through current window panes"},
                {modifiers= obj.commandEnum.cmd, keys = "/", description = "Highlight cursor"},
                {modifiers = obj.commandEnum.cmd .. obj.commandEnum.alt, keys = "I", description = "Broadcast command to all panes"},
            }
        },
        {
            category = "Tmux",
            shortcuts = {
              {modifiers = obj.commandEnum.cmd, keys = "A", description = "Leader combination"},
              {modifiers = nil, keys = "C", description = "Create new window"},
              {modifiers = nil, keys = "N", description = "Cycle through windows"},
              {modifiers = nil, keys = "0/1/2..", description = "Move to that window"},
              {modifiers = nil, keys = ":", description = "Enter command mode"},
              {modifiers = nil, keys = "D", description = "Dettach from tmux session"},
            }
        }
        
    },
    ["Default"] = {
        {
            category = "Amethyst",
            shortcuts = {
                {modifiers = obj.commandEnum.alt .. obj.commandEnum.shift, keys = "J/K", description = "Move between windows in same screen"},
                {modifiers = obj.commandEnum.alt .. obj.commandEnum.shift, keys = "H/L", description = "Increase decrease size of window"},
                {modifiers = obj.commandEnum.alt .. obj.commandEnum.shift, keys = "T", description = "Toggle floating"},
                {modifiers = obj.commandEnum.alt .. obj.commandEnum.shift, keys = obj.commandEnum.space, description = "Change between layouts"},
                {modifiers = obj.commandEnum.alt .. obj.commandEnum.ctrl .. obj.commandEnum.shift, keys = "T", description = "Enable/Disable Amethyst"},
                {modifiers = obj.commandEnum.alt .. obj.commandEnum.shift, keys = "Enter", description = "Switch current window with main window"},
                {modifiers = obj.commandEnum.ctrl .. obj.commandEnum.shift .. obj.commandEnum.alt, keys = "J/K", description = "Switch current window with next/prev window"},
                {modifiers = obj.commandEnum.alt .. obj.commandEnum.shift, keys = "W/E/R", description = "Change focus to screen 1/2/3"},
                {modifiers = obj.commandEnum.ctrl .. obj.commandEnum.alt .. obj.commandEnum.shift, keys = "W/E/R", description = "Throw current window to screen 1/2/3"},
            }
        },
        {
            category = "Normal Mac",
            shortcuts = {
                {modifiers = obj.commandEnum.cmd , keys = obj.commandEnum.tab, description = "Cycle through active windows in Mac"},
                {modifiers = obj.commandEnum.ctrl, keys = "F2", description = "Shortcut for screen menu bar"},
            }
        }
    }
}

local function generateHtml(application)
    local app_title = application:title()
    local shortcuts = appSpecificShortcuts[app_title] or appSpecificShortcuts["Default"]

    local html = [[
        <!DOCTYPE html>
        <html>
        <head>
        <style type="text/css">
            * { margin: 0; padding: 0; }
            html, body {
              background-color: #f0f0f0;
              font-family: Arial, sans-serif;
              font-size: 18px;
              line-height: 1.6;
            }
            h2 {
                text-align: center;
                margin-top: 20px;
                color: #333;
            }
            .category {
                font-weight: bold;
                font-size: 22px;
                margin-top: 20px;
                text-align: center;
                cursor: pointer;
                background-color: #ddd;
                padding: 10px;
                border-radius: 5px;
                user-select: none;
                transition: background-color 0.3s ease;
            }
            .category.expanded {
                background-color: #cce7ff; /* Light blue when expanded */
            }
            .shortcuts {
                display: none; /* Initially hidden */
                margin-top: 10px;
            }
            .shortcut {
                display: flex;
                justify-content: space-between;
                padding: 10px;
                margin: 5px 0;
                background-color: #fff;
                border: 1px solid #ddd;
                border-radius: 5px;
            }
            .modifiers {
                width: 60px;
                text-align: center;
                font-weight: bold;
                background-color: #e1e1e1;
                border-radius: 3px;
            }
            .keys {
                width: auto;
                padding: 0 10px;
                text-align: center;
                background-color: #f5f5f5;
                border-radius: 3px;
            }
            .description {
                flex: 1;
                padding-left: 15px;
                text-align: left;
            }
            .container {
                padding: 20px;
            }
        </style>

        <script>
            function toggleCategory(event) {
                const categoryDiv = event.target;
                const shortcutsDiv = categoryDiv.nextElementSibling;

                if (shortcutsDiv.style.display === "none" || shortcutsDiv.style.display === "") {
                    shortcutsDiv.style.display = "block";
                    categoryDiv.classList.add("expanded"); // Change color when expanded
                } else {
                    shortcutsDiv.style.display = "none";
                    categoryDiv.classList.remove("expanded"); // Revert color when collapsed
                }
            }
            
        </script>

        </head>
        <body>
        <div class="container">
    ]]

    for _, section in ipairs(shortcuts) do
        html = html .. "<div class='category' onclick='toggleCategory(event)'>" .. section.category .. "</div><div class='shortcuts'>"
        for _, shortcut in ipairs(section.shortcuts) do
            html = html .. [[ <div class="shortcut"> ]]
            if shortcut.modifiers then
                html = html .. [[<div class="modifiers">]] .. shortcut.modifiers .. [[</div>]]
            end
            html = html .. [[
                    <div class="keys">]] .. shortcut.keys .. [[</div>
                    <div class="description">]] .. shortcut.description .. [[</div>
                </div>
            ]]
        end
        html = html .. "</div>"
    end

    html = html .. "</div></body></html>"
    return html
end

function obj:init()
    self:createWebView()
    self:startScreenWatcher()
end

function obj:createWebView()
    if self.sheetView then
        self.sheetView:delete() -- Remove existing webview before creating a new one
    end

    self.sheetView = hs.webview.new({x = 0, y = 0, w = 0, h = 0})
    self.sheetView:windowTitle("CheatSheets")
    self.sheetView:windowStyle("utility")
    self.sheetView:allowGestures(true)
    self.sheetView:allowNewWindows(false)
    self.sheetView:level(hs.drawing.windowLevels.tornOffMenu)

    self:centerWebView()
    self.sheetView:hide()
end

function obj:centerWebView()
    -- Get the current primary screen and its resolution
    local cscreen = hs.screen.primaryScreen()
    local cres = cscreen:fullFrame()

    -- Define the webview size (e.g., 50% width, 75% height)
    local webviewWidth = cres.w * 0.50
    local webviewHeight = cres.h * 0.75

    -- Calculate center position
    local centerX = cres.x + (cres.w - webviewWidth) / 2
    local centerY = cres.y + (cres.h - webviewHeight) / 2

    self.sheetView:frame({
        x = centerX,
        y = centerY,
        w = webviewWidth,
        h = webviewHeight
    })

    -- Show the webview after positioning
    self.sheetView:show()
end

function obj:startScreenWatcher()
    self.screenWatcher = hs.screen.watcher.new(function()
        self.sheetView:hide()
        self:centerWebView() -- Re-center the webview when screen configuration changes
    end)
    self.screenWatcher:start()
end

--- Show the app-specific keybindings in a view
function obj:show()
    local capp = hs.application.frontmostApplication()
    local webcontent = generateHtml(capp)
    self.sheetView:html(webcontent)
    self.sheetView:show()
end

--- Hide the cheatsheet view.
function obj:hide()
    self.sheetView:hide()
end

--- Alternatively show/hide the cheatsheet view.
function obj:toggle()
    if self.sheetView and self.sheetView:hswindow() and self.sheetView:hswindow():isVisible() then
        self:hide()
    else
        self:show()
    end
end

--- Binds hotkeys for KSheet
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---   * show - Show the keybinding view
---   * hide - Hide the keybinding view
---   * toggle - Show if hidden, hide if shown
function obj:bindHotkeys(mapping)
    local actions = {
        toggle = hs.fnutils.partial(self.toggle, self),
        show = hs.fnutils.partial(self.show, self),
        hide = hs.fnutils.partial(self.hide, self)
    }
    hs.spoons.bindHotkeysToSpec(actions, mapping)
end

return obj
