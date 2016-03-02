local renderText = function(self)
  self:renderBackground()
  
  local locX, locY = self:startCoordsBasedOnGravity()
  love.graphics.setColor(self.textColor or {255,255,255,255})
  love.graphics.print(self.data.value,locX,locY)

end

local textWidth = function (self)
  return font:getWidth(self.data.value)
end

local textHeight = function (self)
  return font:getHeight()
end

return function(base, options)  
  base.render = renderText
  base.data = options.data
  base.textColor = options.textColor or {255,255,255,255}
  base.contentWidth = textWidth
  base.contentHeight = textHeight  
  return base
end