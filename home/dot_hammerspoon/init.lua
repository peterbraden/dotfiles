
--- Inspired by
--- https://github.com/twpayne/dotfiles/blob/master/home/dot_hammerspoon/init.lua
hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.grid.setMargins({w=0, h=0})
hs.window.animationDuration = 0 -- disable animations

function moveFrontmostWindow(where)
  local window = hs.window.frontmostWindow()
  if window ~= nil then
    local screen = window:screen()
    hs.grid.set(window, where, screen)
  end
end

function findBiggestScreen()
  local biggestScreen = nil
  local biggestArea = 0
  for _, screen in ipairs(screens) do
      local frame = screen:frame()
      local area = frame.w * frame.h
      if area > biggestArea then
          biggestArea = area
          biggestScreen = screen
      end
  end

  return biggestScreen
end


hs.hotkey.bind({"ctrl", "alt"}, "left", function()
  moveFrontmostWindow('0,0 6x12')
end)

hs.hotkey.bind({"ctrl", "alt"}, "right", function()
  moveFrontmostWindow('6,0 6x12')
end)

hs.hotkey.bind({"ctrl", "alt"}, "down", function()
  moveFrontmostWindow('0,0 12x12') --- Full screen
end)


-- Magic layout onto big monitor or move to other screen
hs.hotkey.bind({"ctrl", "alt"}, "up", function()
    local screens = hs.screen.allScreens()
    if #screens < 2 then
        hs.alert.show("Need at least 2 screens")
        return
    end

    biggestScreen = findBiggestScreen()

    -- Find a "secondary" screen (not biggest)
    local secondaryScreen = nil
    for _, screen in ipairs(screens) do
        if screen:id() ~= biggestScreen:id() then
            secondaryScreen = screen
            break
        end
    end

    if not biggestScreen or not secondaryScreen then
        hs.alert.show("Unable to find screens")
        return
    end

    -- Decide if most windows are on the biggest screen
    local allWindows = hs.window.visibleWindows()
    local onBiggest = 0
    for _, win in ipairs(allWindows) do
        if win:screen():id() == biggestScreen:id() then
            onBiggest = onBiggest + 1
        end
    end

    local targetScreen = (onBiggest >= #allWindows / 2) and secondaryScreen or biggestScreen
    local targetFrame = targetScreen:frame()

    for _, win in ipairs(allWindows) do
        local winFrame = win:frame()
        local fromScreenFrame = win:screen():frame()

        -- Calculate relative position/size
        local relX = (winFrame.x - fromScreenFrame.x) / fromScreenFrame.w
        local relY = (winFrame.y - fromScreenFrame.y) / fromScreenFrame.h
        local relW = winFrame.w / fromScreenFrame.w
        local relH = winFrame.h / fromScreenFrame.h

        -- Move to target screen, preserving relative position/size
        win:setFrame({
            x = targetFrame.x + relX * targetFrame.w,
            y = targetFrame.y + relY * targetFrame.h,
            w = relW * targetFrame.w,
            h = relH * targetFrame.h
        }, 0)
    end

    hs.alert.show("Moved windows to " .. targetScreen:name())
end)



---
--- I used to use 'Visor' which became 'TotalTerminal', then disappeared.
--- This replaces it.
--- It drops a terminal down from the top of the screen.
---
hs.hotkey.bind({"ctrl"}, "space", function()
  local app = hs.application.get("Terminal")
  if app ~= nil then
    if app:isFront() then
      app:hide()
    else
      app:setFrontmost(true)
      local window = app:focusedWindow()
      local screen = window:screen()
      hs.grid.set(window, '0,0 12x4', screen)
    end
  end
end)




--
-- Auto-reload config on change.
--

function reloadConfig(files)
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      hs.reload()
    end
  end
end

hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()


