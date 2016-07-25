mouseHeld = {}
keysHeld = {}

love.update = function(dt)
  x,y = love.mouse.getPosition()
  
  local hover = true
  for button, _ in pairs(mouseHeld) do
    root:receiveOutsideSignal("mouse.held", { button = button }, {{ x = x, y = y,}})
    hover = false
  end
  if hover then
    root:receiveOutsideSignal("mouse.hover", {}, {{ x = x, y = y }})
  end
  
  for key, scancode in pairs(keysHeld) do
    root:receiveOutsideSignal("key.held", { key = key, scancode = scancode })
  end
  root:update(dt)
end

love.mousepressed = function(x,y,button)
  root:receiveOutsideSignal("mouse.down", { button = button }, {{ x = x, y = y,}})
  mouseHeld[button] = true
end

love.mousereleased = function(x,y,button)
  root:receiveOutsideSignal("mouse.up", { button = button }, {{ x = x, y = y,}})
  mouseHeld[button] = nil
end

love.keypressed = function(key,scancode)
  root:receiveOutsideSignal("key.down", { key = key, scancode = scancode })
  keysHeld[key] = scancode  
end

love.keyreleased = function(key)
  root:receiveOutsideSignal("key.up", { key = key, scancode = keysHeld[key] })
  keysHeld[key] = nil
end