function mainview(lc)
  
  local back = lc:build("freeform", { 
    width = "fill", height = "fill",
    update = function(self, dt) 
      self.p = self.p or 0
      self.p = self.p + dt 
    end,
    render = function(self)
      love.graphics.setColor(255,0,0,255)
      local x0 = math.sin(self.p) * self:grantedWidth() * 0.1 + self:grantedWidth() * 0.5
      local y0 = math.sin(self.p) * self:grantedHeight() * 0.1 + self:grantedHeight() * 0.5
      local x1 = math.sin(self.p) * self:grantedWidth() * 0.4
      local y1 = math.sin(self.p) * self:grantedHeight() * 0.4
      love.graphics.rectangle("fill", x0, y0, x1, y1)      
    end
    })
      
  local topLeft = lc:build("border", { left = "fill", right = 25, leftWeight = 5, top = 20, bottom = 10, backgroundColor = { 255, 0, 0, 255} })
  topLeft:addChild( lc:build("text", { width = 125, height = 30, data = function() return "topleft" end, gravity = { "start", "start" }, backgroundColor = { 0, 255, 0, 255 }, padding = lc.padding(15), border = { color = { 0,0, 255, 255}, thickness = 3 } } ) )
      
  local options = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight(),
    back = back,
    topleft = topLeft,
    topright = lc:build("text", { width = "fill", height = "fill", data = function() return "topright" end, gravity = { "end", "start" } }),
    bottomleft = lc:build("text", { width = "fill", height = "fill", data = function() return "bottomleft" end, gravity = { "start", "end" } }),
    bottomright = lc:build("text", { width = "fill", height = "fill", data = function() return "bottomright" end, gravity = { "end", "end" } }),    
  }
  
  root = lc:build("root",{})
  root:addChild(lc:build("4pane", options))
  
  root:layoutingPass()

  return root
end

return function(lc)
  return {
    root = mainview(lc),
    update = function(self, dt) 
      self.root:update(dt)
    end,
    draw = function(self)
      self.root:render()      
    end
  }
end