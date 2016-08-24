return function(looky)
  
  -- setup game consts
  
  player = {
    health = 85,
    keys = {
      blue = false,
      red = true,
      yellow = true,      
    },
    weapons = {
      true, true, false, false, true
    },
    ammo = {
      98, 30, 0, 0, 10
    }
  }
  -- setup styles

  local root = looky:build("root", {})  
  local main = looky:build("slotted", { width = 800, height = 200, background = { file = "images/shooter/hud.png", fill = "fit" }, slots = {
    health = { x = 10, y = 20, width = 100, height = 100 },
    key1 = { x = 100, y = 20, width = 20, height = 20 }
        
  } } )    

  local health = looky:build("text", { width = "fill", height = "fill", data = function() return tostring(player.health) end })
  main:addChildToSlot(health, "health")
  
  root:addChild(main)
  root:layoutingPass()
  
  -- update function; allow movement and increase score
  love.update = function(dt)
    root:update(dt)  
  end  
  
  -- draw the gui to the screen
  love.draw = function()
    root:render()
  end
  
end
