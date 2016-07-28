return function(lc)
  local root = lc:build("root", {direction = "h"})
  
  lc:registerLayout("topbar", require "samples/rts/topbar"(lc) )
  lc:registerLayout("sidepane", require "samples/rts/sidepane"(lc) )
  lc:registerLayout("minimap", require "samples/rts/minimap"(lc) )
  lc:registerLayout("purchase", require "samples/rts/purchase"(lc) )
  lc:registerLayout("buyoption", require "samples/rts/buyoption"(lc) )
  
  local topbar = lc:build("topbar", {})
  root:addChild(topbar)
  
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
