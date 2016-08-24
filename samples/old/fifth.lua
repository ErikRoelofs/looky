function mainview(looky)
  
  local rf = function(self)
    self:renderBackground()
    
    love.graphics.setColor(self.color or {255,255,255,255})
    love.graphics.rectangle("fill", 100, 100, 200, 200)
  end
  
  local uf = function(self, dt)
    
    self.counter = self.counter or 0
    self.counter = self.counter + dt
    if self.counter > 1 then
      self.counter = 0
    end
    self.color = {255, 255, self.counter * 255, 255}
  end
  
  local root = looky:build("root", {direction = "v" })
  
  root:addChild( looky:build("text", { width = "fill", height = "wrap", data = {value="Above!"}, font = "default" } ) )
  root:addChild( looky:build("freeform", { width = 500, height = 500, render = rf, update = uf, background = { 255, 0, 0, 255 }, border = { color = { 0, 0, 255, 255 }, thickness = 10 } } ) )
  root:addChild( looky:build("text", { width = "fill", height = "wrap", data = {value= "Below!"}, border = { color = { 0, 255, 0, 255 }, thickness = 5 }, padding = looky.padding(5)} ) )
  
  root:layoutingPass()
  return root
end

return function(looky)
  return {
    root = mainview(looky),
    update = function(self, dt) 
      self.root:update(dt)
    end,
    draw = function(self)
      self.root:render()
    end
  }
end