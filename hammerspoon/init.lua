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

hs.hotkey.bind(hyperShift, "M", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  -- 4:3 window
  local basew = math.floor(max.h * 4 / 3)
  local baseh = max.h
  local serials = {1, 0.9, 0.7, 0.5, 0.3}

  if f.w == math.floor(basew * serials[1]) then
    f.w = math.floor(basew * serials[2])
    f.h = math.floor(baseh * serials[2])
  elseif f.w == math.floor(basew * serials[2]) then
    f.w = math.floor(basew * serials[3])
    f.h = math.floor(baseh * serials[3])
  elseif f.w == math.floor(basew * serials[3]) then
    f.w = math.floor(basew * serials[4])
    f.h = math.floor(baseh * serials[4])
  elseif f.w == math.floor(basew * serials[4]) then
    f.w = math.floor(basew * serials[5])
    f.h = math.floor(baseh * serials[5])
  elseif f.w == math.floor(basew * serials[5]) then
    f.w = math.floor(basew * serials[1])
    f.h = math.floor(baseh * serials[1])
  else
    f.w = math.floor(basew * serials[1])
    f.h = math.floor(baseh * serials[1])
  end

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
