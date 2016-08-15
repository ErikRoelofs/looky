return function(lc)
  
  lives = 5
  
  local stackroot = lc:build("stackroot", {})
  
  local game = lc:build("text", { width = "fill", height = "fill", gravity = { "center", "center" }, data = function() return "hi" end })
  
  local livesView = lc:build("numberAsImage", { width = "wrap", height = "wrap", image = "images/asteroids/ship.png", maxValue = 6, value = { value = 5 } })
  
  local main = lc:build("4pane", { width = "fill", height = "fill", back = game, bottomleft = livesView } )
  
  stackroot:addChild(main)
  stackroot:layoutingPass()
  
  love.update = function(dt)
    fps = 1 / dt
    stackroot:update(dt)
  end
  
  love.draw = function()
    stackroot:render()
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("fps: " .. fps, 5, 5 )
  end
end
