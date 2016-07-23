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
      
  local topLeft = lc:build("border", { left = 25, right = 25, leftWeight = 5, top = 10, bottom = "fill", background = { 255, 0, 0, 255} })

  topLeft:addChild(lc:build("text", { width = 125, height = 30, data = function() return "topleft" end, gravity = { "start", "start" }, background = { 0, 255, 0, 255 }, padding = lc.padding(15), border = { color = { 255,255, 0, 255}, thickness = 3 } } ))
  
  topRight = lc:build("aquarium", { width = "fill", height = "fill", background = { 0, 0, 255, 255 } })
  local text = lc:build("text", { width="wrap", height="wrap", data = function() return "some text" end })
  topRight:addChild(text)
  topRight:setOffset(1, 350, 30000)
      
  local text2 = lc:build("text", { width="wrap", height="wrap", data = function() return "some other text" end })
  topRight:addChild(text2)
  topRight:setOffset(text2, 100, 100)

  local options = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight(),
    back = back,
    topleft = topLeft,
    topright = topRight,
    bottomleft = lc:build("text", { width = "fill", height = "fill", data = function() return "bottomleft" end, gravity = { "start", "end" } }),    
  }
  
  root = lc:build("root",{})
  pane = lc:build("4pane", options)
  pane.childSignalHandlers.response = function(self, signal, payload) print( "This is 4pane, receiving: " .. signal ) end
  root:addChild(pane)
  
  root:layoutingPass()

  topLeft:receiveOutsideSignal("signal", {test = "test"})

  return root
end

return function(lc)
  return {
    root = mainview(lc),
    update = function(self, dt) 
      topRight:setOffset(2, math.random(25, 225), math.random(25,225))
      self.root:update(dt)
    end,
    draw = function(self)
      self.root:render()      
    end
  }
end