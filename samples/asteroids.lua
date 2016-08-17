return function(lc)
  
  lc:registerFont("big", love.graphics.newFont( 32 ))
  
  lives = 5
  score = 0
  level = 4
  
  player = {
    x = 100,
    y = 100,
    r = 0,
    spd = 0,
    acc = 10,
    maxRot = 5,
    maxSpd = 10,
    power = 5,
    maxPower = 5,
    powerChrg = 1,
    image = love.graphics.newImage("images/asteroids/ship.png")
  }
  
  render = function()
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(player.image, player.x, player.y, player.r, 1, 1, player.image:getWidth() / 2, player.image:getHeight() / 2)
  end
  
  local stackroot = lc:build("stackroot", {})
  
  local game = lc:build("freeform", { width = "fill", height = "fill", render = render })
  
  local livesView = lc:build("numberAsImage", { width = "wrap", height = "wrap", image = "images/asteroids/ship.png", maxValue = 6, value = { value = 5 }, padding = lc.padding( 15 ) })
  
  local levelView = lc:build("text", { width = "wrap", height = "wrap", data = function() return "Level: " .. level end, padding = lc.padding( 15 ), font = "big" })
  
  local shipView = lc:build("linear", { width = 250, height = "wrap", direction = "v", padding = lc.padding( 15 ) })
    
  shipView:addChild( lc:build("numberAsBar", { width = "fill", height = 25, filledColor = { 255, 255, 0, 255 }, emptyColor = { 0, 255, 255, 255 }, value = function() return math.abs(player.spd) end, maxValue = player.maxSpd, background = { 255, 0, 0, 100 }, padding = lc.padding(2), border = { color = { 0, 255, 0, 100 }, thickness = 2 }, notches = { color = { 0, 0, 255, 255 }, amount = 10, largerEvery = 3 }} ))
  shipView:addChild( lc:build("numberAsBar", { width = "fill", height = 25, filledColor = { 255, 255, 0, 255 }, value = function() return player.power end, maxValue = player.maxPower } ))
  
  local scoreView = lc:build("text", { width = 250, height = "wrap", data = function() return "Score: " .. score end, padding = lc.padding( 15 ), gravity = { "end", "center" }, font = "big" })
  
  local main = lc:build("4pane", { width = "fill", height = "fill", back = game, bottomleft = livesView, topright = scoreView, topleft = levelView, bottomright = shipView } )
  
  stackroot:addChild(main)
  stackroot:layoutingPass()
  
  love.update = function(dt)
    fps = 1 / dt
    score = score + 1
    stackroot:update(dt)
    
    if love.keyboard.isDown("w") then
      player.spd = player.spd + player.acc * dt
    end
    if love.keyboard.isDown("s") then
      player.spd = player.spd - player.acc * dt
    end
    if love.keyboard.isDown("d") then
      player.r = player.r + player.maxRot * dt
    end
    if love.keyboard.isDown("a") then
      player.r = player.r - player.maxRot * dt      
    end
    
    player.spd = player.spd - ( player.spd * 0.4 * dt )
    
    if player.spd > player.maxSpd then
      player.spd = player.maxSpd
    end
    if player.spd < -player.maxSpd then
      player.spd = -player.maxSpd
    end
    
    player.power = player.power + player.powerChrg * dt
    if player.power > player.maxPower then
      player.power = player.maxPower
    end
    
    player.x = player.x + player.spd * math.sin(player.r)
    player.y = player.y + player.spd * (math.cos(player.r)*-1)
    
  end
  
  love.keypressed = function(key)
    if key == "space" and player.power >= 1 then
      player.power = player.power - 1
    end
  end
  
  love.draw = function()
    stackroot:render()
  end
end
