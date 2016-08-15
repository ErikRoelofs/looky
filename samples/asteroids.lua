return function(lc)
  
  lives = 5
  score = 0
  
  local stackroot = lc:build("stackroot", {})
  
  local game = lc:build("text", { width = "fill", height = "fill", gravity = { "center", "center" }, data = function() return "hi" end })
  
  local livesView = lc:build("numberAsImage", { width = "wrap", height = "wrap", image = "images/asteroids/ship.png", maxValue = 6, value = { value = 5 } })
  
  local scoreView = lc:build("text", { width = 250, height = "wrap", data = function() return "Score: " .. score end, padding = lc.padding( 15 ), gravity = { "end", "center" } })
  
  local main = lc:build("4pane", { width = "fill", height = "fill", back = game, bottomleft = livesView, topright = scoreView } )
  
  stackroot:addChild(main)
  stackroot:layoutingPass()
  
  love.update = function(dt)
    fps = 1 / dt
    score = score + 1
    stackroot:update(dt)
  end
  
  love.draw = function()
    stackroot:render()
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("fps: " .. fps, 5, 5 )
  end
end
