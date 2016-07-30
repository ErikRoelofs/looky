return function(lc)
  local root = lc:build("root", {direction = "h"})
  
  lc:registerLayout("topbar", require "samples/rts/topbar"(lc) )
  lc:registerLayout("sidepane", require "samples/rts/sidepane"(lc) )
  lc:registerLayout("minimap", require "samples/rts/minimap"(lc) )
  lc:registerLayout("purchase", require "samples/rts/purchase"(lc) )
  lc:registerLayout("purchaselist", require "samples/rts/purchaselist"(lc) )
  lc:registerLayout("buyoption", require "samples/rts/buyoption"(lc) )
  lc:registerLayout("mainscreen", require "samples/rts/mainscreen"(lc) )
  lc:registerLayout("unit", require "samples/rts/unit"(lc) )
  
  lc:registerValidator( "units", { schemaType = "array",
        item = { schemaType = "table", 
                options = {
                  x = {
                    required = true,
                    schemaType = "number"
                  },
                  y = {
                    required = true,
                    schemaType = "number"
                  },
                }
        }
  })
  lc:registerValidator( "map", { schemaType = "table",
        options = { 
          width = {
            required = true,
            schemaType = "number"
          },
          height = {
            required = true,
            schemaType = "number"
          }
        }
  })

  units = {
    { x = 100, y = 100 }, 
    { x = 200, y = 200 },
    { x = 300, y = 300 },
    { x = 400, y = 400 },
    { x = 500, y = 500 },
    { x = 600, y = 600 },
    { x = 700, y = 700 },
    { x = 800, y = 800 },
    { x = 900, y = 900 },
    { x = 1000, y = 1000 },
  }
  
  map = {
    width = 2000,
    height = 2000    
  }
  
  -- main column holds the top bar and main screen
  local column = lc:build("linear", { width = "fill", height = "fill", direction = "v" })
  local topbar = lc:build("topbar", {})
  column:addChild(topbar)
  local main = lc:build("mainscreen", {units = units, map = map, locX = 115, locY = 115})
  column:addChild(main)
  root:addChild(column)

  local sidepane = lc:build("sidepane", {})
  root:addChild(sidepane)

  root:layoutingPass()
  
  require "signals"(root)
  
  local signalUpdate = love.update
  love.update = function(dt)
    
    units[3].x = units[3].x + 25 * dt
    units[4].y = units[4].y + 25 * dt
    
    signalUpdate(dt)
    fps = 1 / dt
  end

  love.draw = function()
    root:render()
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("fps: " .. fps, 5, 5 )
  end
end
