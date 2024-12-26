local obj = {}
obj.__index = obj

-- Metadata
obj.name = "WindowResizing"
obj.version = "1.0"
obj.author = "vasubansal1033 <vasubansal1998@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Upper-Left corner
function obj:upperLeft()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x / 2
    f.y = max.y / 2
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

-- Upper-Right corner
function obj:upperRight()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y / 2
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

-- Lower-Right corner
function obj:lowerRight()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y + (max.h / 2)
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end

-- Lower-Left corner
function obj:lowerLeft()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x / 2
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

-- Maximize
function obj:maximize()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end

-- Left
function obj:left()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end

-- Right
function obj:right()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end

-- Up
function obj:up()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = 0
    f.y = 0
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end

-- Down
function obj:down()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = 0
    f.y = max.y + (max.h / 2)
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end

function obj:bindHotkeys(mapping)
    local actions = {
        upperLeft = hs.fnutils.partial(self.upperLeft, self),
        upperRight = hs.fnutils.partial(self.upperRight, self),
        lowerLeft = hs.fnutils.partial(self.lowerLeft, self),
        lowerRight = hs.fnutils.partial(self.lowerRight, self),
        maximize = hs.fnutils.partial(self.maximize, self),
        left = hs.fnutils.partial(self.left, self),
        right = hs.fnutils.partial(self.right, self),
        up = hs.fnutils.partial(self.up, self),
        down = hs.fnutils.partial(self.down, self),
    }

    hs.spoons.bindHotkeysToSpec(actions, mapping)
end

return obj