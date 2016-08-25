return function(looky)
  
  rootView = looky:build("root", { direction = "v" })
  renderGameScreen = function() 
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(shipImage, player.x, player.y, player.rotation, 1, 1, shipImage:getWidth() / 2, shipImage:getHeight() / 2)
  end
  gameScreenView = looky:build("freeform", { width = "fill", height = "fill", render = renderGameScreen, background = { file = "docs/assets/background.png", fill = "fill" }, padding = looky.padding(5), border = { thickness = 5, color = { 60, 60, 60, 250 }  } })

  HUDView = looky:build("linear", { width = "fill", height = 100, direction = "h" })

  seconds = 0
  clockView = looky:build("text", { width = "fill", height = "fill", data = function() return math.floor(seconds) .. "s" end, gravity = {"center", "center"} })
  
  player = {
    x = 200,
    y = 200,
    rotation = 0,
    speed = 0,
    maxSpeed = 300
  }

  shipImage = love.graphics.newImage("docs/assets/ship.png")

  
  speedView = looky:build("numberAsBar", { width = "fill", height = 20, gravity = { "center", "center" }, value = function() return player.speed end, maxValue = player.maxSpeed, filledColor = { 100, 150, 30, 255 } })    
  
  HUDView:addChild(clockView)
  HUDView:addChild(speedView)
    
  rootView:addChild(gameScreenView)
  rootView:addChild(HUDView)

  rootView:layoutingPass()
  
  love.update = function(dt)
    seconds = seconds + dt
    rootView:update(dt)
    
    if love.keyboard.isDown("w") then
      player.speed = player.speed + 150 * dt
    end
    if love.keyboard.isDown("s") then
      player.speed = player.speed - 150 * dt
    end
    if love.keyboard.isDown("d") then
      player.rotation = player.rotation + 2 * dt
    end
    if love.keyboard.isDown("a") then
      player.rotation = player.rotation - 2 * dt      
    end
    
    player.speed = player.speed - ( player.speed * 0.4 * dt )
    
    if player.speed > player.maxSpeed then
      player.speed = player.maxSpeed
    end
    if player.speed < 0 then
      player.speed = 0
    end

    player.x = player.x + (player.speed * dt) * math.sin(player.rotation)
    player.y = player.y + (player.speed * dt) * (math.cos(player.rotation)*-1)


  end
 
  function love.draw()
    rootView:render()
  end

end