
--- Inspired by
--- https://github.com/twpayne/dotfiles/blob/master/home/dot_hammerspoon/init.lua
hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.grid.setMargins({w=0, h=0})
hs.window.animationDuration = 0 -- disable animations

function moveFrontmostWindow(where)
  local window = hs.window.frontmostWindow()
  local screen = window:screen()
  hs.grid.set(window, where, screen)
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


---
--- I used to use 'Visor' which became 'TotalTerminal', then disappeared.
--- This replaces it.
--- It drops a terminal down from the top of the screen.
---
hs.hotkey.bind({"ctrl"}, "space", function()
  local app = hs.application.get("Terminal")
  if app:isFrontmost() then
    app:hide()
  else
    app:setFrontmost(true)
    local window = app:focusedWindow()
    local screen = window:screen()
    hs.grid.set(window, '0,0 12x4', screen)
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


