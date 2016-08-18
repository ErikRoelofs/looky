return function(lc)
  
  -- setup game consts
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
    image = love.graphics.newImage("images/asteroids/ship.png"),
    bullet = love.graphics.newImage("images/asteroids/bullet.png"),
    bulletSpd = 20,
  }
  
  shots = {}
  
  -- setup styles
  lc:registerLayout("stats", require ( "samples/asteroids/stats" )(lc) )
  lc:registerLayout("bar", require ( "samples/asteroids/bar" )(lc) )

  lc:registerFont("big", love.graphics.newFont( 32 ))
  
  lc:registerStyledLayout("ast.numberAsImage", "numberAsImage", { width = "wrap", height = "wrap", padding = lc.padding( 15 ) })
  lc:registerStyledLayout("ast.text", "text", { width = "wrap", height = "wrap", padding = lc.padding( 15 ), font = "big" } )
  lc:registerStyledLayout("ast.numberAsBar", "numberAsBar", {width = "fill", height = 25, background = { 255, 255, 255, 255 }, filledColor = { 255, 255, 0, 255 }, emptyColor = { 0, 255, 255, 255 }, padding = lc.padding(2), border = { color = { 0, 255, 0, 100 }, thickness = 2 }, notches = { color = { 0, 0, 255, 255 }, amount = 5 }} )  
  
  -- render function for game window itself
  render = function()
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(player.image, player.x, player.y, player.r, 1, 1, player.image:getWidth() / 2, player.image:getHeight() / 2)
    for _, shot in ipairs(shots) do
      love.graphics.draw(player.bullet, shot.x, shot.y, shot.r )
    end
  end
  
  -- the components of the main gui
  local game = lc:build("freeform", { width = "fill", height = "fill", render = render })  
  local livesView = lc:build("ast.numberAsImage", { image = "images/asteroids/ship.png", maxValue = 6, value = function() return lives end }) 
  local shipView = lc:build("stats")  
  local levelView = lc:build("ast.text", { data = function() return "Level: " .. level end })
  local scoreView = lc:build("ast.text", { width = 250, data = function() return "Score: " .. score end })

  local root = lc:build("root", {})  
  local main = lc:build("4pane", { width = "fill", height = "fill", back = game, bottomleft = livesView, topright = scoreView, topleft = levelView, bottomright = shipView } )  
  root:addChild(main)
  root:layoutingPass()
  
  -- update function; allow movement and increase score
  love.update = function(dt)
    score = score + 1
    root:update(dt)
    
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
    
    for _, shot in ipairs(shots) do
      shot.x = shot.x + player.bulletSpd * math.sin(shot.r)
      shot.y = shot.y + player.bulletSpd * (math.cos(shot.r)*-1)      
    end
    
  end
  
  love.keypressed = function(key)
    if key == "space" and player.power >= 1 then
      player.power = player.power - 1
      shoot()
    end
    if key == "r" and lives > 1 then
      lives = lives - 1
    end
    if key == "e" then
      lives = lives + 1
    end

  end
  
  -- draw the gui to the screen
  love.draw = function()
    root:render()
  end
  
  shoot = function()
    table.insert(shots, {
      x = player.x + 50 * math.sin(player.r),
      y = player.y + 50 * (math.cos(player.r)*-1),
      r = player.r
    })
  end
end
