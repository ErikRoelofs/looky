local renderText = function(self)
  self:renderBackground()
  
  local locX, locY
  if self.gravity[1] == "start" then
    locX = self.paddingLeft    
  elseif self.gravity[1] == "end" then
    locX = self:grantedWidth() - self.paddingRight - self:contentWidth()
  elseif self.gravity[1] == "center" then
    locX = (self:grantedWidth() - self:contentWidth() - self.paddingRight - self.paddingLeft) / 2
  end
  if self.gravity[2] == "start" then
    locY = self.paddingTop
  elseif self.gravity[2] == "end" then
    locY = self:grantedHeight() - self.paddingBottom - self:contentHeight()
  elseif self.gravity[2] == "center" then
    locY = (self:grantedHeight() - self:contentHeight() - self.paddingTop - self.paddingBottom) / 2
  end
  
  
  love.graphics.setColor(self.textColor or {255,255,255,255})
  love.graphics.print(self.text,locX,locY)

end

local textWidth = function (self)
  return font:getWidth(self.text) + self.paddingLeft + self.paddingRight
end

local textHeight = function (self)
  return font:getHeight() + self.paddingTop + self.paddingBottom
end

return function(base, options)  
  base.render = renderText
  base.text = options.text
  base.textColor = options.textColor or {255,255,255,255}
  base.contentWidth = textWidth
  base.contentHeight = textHeight  
  return base
end