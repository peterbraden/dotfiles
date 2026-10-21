
--- Inspired by
--- https://github.com/twpayne/dotfiles/blob/master/home/dot_hammerspoon/init.lua
hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.grid.setMargins({w=0, h=0})
hs.window.animationDuration = 0 -- disable animations

function moveFrontmostWindow(where)
  local window = hs.window.frontmostWindow()
  if not window then
    return
  end
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


--- The drop-down terminal (ctrl+space) is Ghostty's quick terminal, see
--- ~/.config/ghostty/config.ghostty




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

-- Global, so the watcher isn't garbage-collected (which stops auto-reload)
configWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()


