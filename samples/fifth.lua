function mainview()
  
  local rf = function(self)
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
  
  
  local root = lc:build("root", {direction = "v" })
  
  root:addChild( lc:build("text", { width = "fill", height = "wrap", text = "Above!" } ) )
  root:addChild( lc:build("freeform", { width = 500, height = 500, render = rf, update = uf } ) )
  root:addChild( lc:build("text", { width = "fill", height = "wrap", text = "Below!" } ) )
  
  root:layoutingPass()
  return root
end

return {
  root = mainview(),
  update = function(self, dt) 
    self.root:update(dt)
  end,
  draw = function(self)
    self.root:render()
  end
}