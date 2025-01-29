

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
    hs.grid.set(window, '0,0 3x1', screen)
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


