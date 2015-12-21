-- key define
local hyper = {"ctrl", "alt", "cmd"}
local hyperShift = {"ctrl", "alt", "cmd", "shift"}

-- hello world
hs.hotkey.bind(hyper, "W", function()
  hs.alert.show("Hello World!")
end)

hs.hotkey.bind(hyperShift, "W", function()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

-- Move Window

-- vertical half screen
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

-- loop 3/4, 1/2, 1/4 screen width
hs.hotkey.bind(hyperShift, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  if f.w == math.floor(max.w / 4 * 3) then
    f.w = math.floor(max.w / 2)
    f.x = max.x
  elseif f.w == math.floor(max.w / 2) then
    f.w = math.floor(max.w / 4)
    f.x = max.x
  elseif f.w == math.floor(max.w / 4) then
    f.w = math.floor(max.w / 4 * 3)
    f.x = max.x
  else
    f.w = math.floor(max.w / 4 * 3)
    f.x = max.x
  end

  win:setFrame(f)
end)

hs.hotkey.bind(hyperShift, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  if f.w == math.floor(max.w / 4 * 3) then
    f.w = math.floor(max.w / 2)
    f.x = max.x + (max.w / 2)
  elseif f.w == math.floor(max.w / 2) then
    f.w = math.floor(max.w / 4)
    f.x = max.x + (max.w / 4 * 3)
  elseif f.w == math.floor(max.w / 4) then
    f.w = math.floor(max.w / 4 * 3)
    f.x = max.x + (max.w / 4)
  else
    f.w = math.floor(max.w / 4 * 3)
    f.x = max.x + (max.w / 4)
  end

  win:setFrame(f)
end)

-- horizonal half screen
hs.hotkey.bind(hyper, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y + (max.h - f.h)
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

-- loop 3/4, 1/2, 1/4 screen height
hs.hotkey.bind(hyperShift, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  if f.h == math.floor(max.h / 4 * 3) then
    f.h = math.floor(max.h / 2)
    f.y = max.y
  elseif f.h == math.floor(max.h / 2) then
    f.h = math.floor(max.h / 4)
    f.y = max.y
  elseif math.floor(max.h / 4) then
    f.h = math.floor(max.h / 4 * 3)
    f.y = max.y
  else
    f.h = math.floor(max.h / 4 * 3)
    f.y = max.y
  end

  win:setFrame(f)
end)

hs.hotkey.bind(hyperShift, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  if f.h == math.floor(max.h / 4 * 3) then
    f.h = math.floor(max.h / 2)
    f.y = max.y + (max.h - f.h)
  elseif f.h == math.floor(max.h / 2) then
    f.h = math.floor(max.h / 4)
    f.y = max.y + (max.h - f.h)
  elseif math.floor(max.h / 4) then
    f.h = math.floor(max.h / 4 * 3)
    f.y = max.y + (max.h - f.h)
  else
    f.h = math.floor(max.h / 4 * 3)
    f.y = max.y + (max.h - f.h)
  end

  win:setFrame(f)
end)

-- Maximize window
hs.hotkey.bind(hyper, "M", function()
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

-- Center window
hs.hotkey.bind(hyper, "C", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w - f.w) / 2
  f.y = max.y + (max.h - f.h) / 2
  win:setFrame(f,0)
end)

-- Resize and center window
hs.hotkey.bind(hyperShift, "C", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local percw = 75
  local perch = 90

  f.w = max.w / 100 * percw
  f.h = max.h / 100 * perch
  f.x = max.x + (max.w - f.w) / 2
  f.y = max.y + (max.h - f.h) / 2
  win:setFrame(f,0)
end)
