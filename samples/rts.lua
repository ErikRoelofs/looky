return function(lc)
  local root = lc:build("root", {direction = "h"})
  
  lc:registerLayout("topbar", require "samples/rts/topbar"(lc) )
  lc:registerLayout("sidepane", require "samples/rts/sidepane"(lc) )
  lc:registerLayout("minimap", require "samples/rts/minimap"(lc) )
  lc:registerLayout("purchase", require "samples/rts/purchase"(lc) )
  lc:registerLayout("buyoption", require "samples/rts/buyoption"(lc) )
  lc:registerLayout("mainscreen", require "samples/rts/mainscreen"(lc) )
  lc:registerLayout("unit", require "samples/rts/unit"(lc) )
  
  -- main column holds the top bar and main screen
  local column = lc:build("linear", { width = "fill", height = "fill", direction = "v" })
  local topbar = lc:build("topbar", {})
  column:addChild(topbar)
  local main = lc:build("mainscreen", {})
  column:addChild(main)
  root:addChild(column)

  local sidepane = lc:build("sidepane", {})
  root:addChild(sidepane)


  root:layoutingPass()
  
  require "signals"(root)
  
  love.update = function(dt)
    root:update(dt)
  end

  love.draw = function()
    root:render()
  end
end
