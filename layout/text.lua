local renderText = function(self)
  self:renderBackground()
  
  local locX, locY
  if self.gravity[1] == "start" then
    locX = self.paddingLeft  
  elseif self.gravity[1] == "end" then
    locX = self:availableWidth() - self:contentWidth() - self.paddingLeft
  elseif self.gravity[1] == "center" then
    locX = (self:availableWidth() - self:contentWidth() - self.paddingLeft - self.paddingRight) / 2
  end
  if self.gravity[2] == "start" then
    locY = self.paddingTop
  elseif self.gravity[2] == "end" then
    locY = self:availableHeight() - self:contentHeight() - self.paddingBottom
  elseif self.gravity[2] == "center" then
    locY = (self:availableHeight() - self:contentHeight() - self.paddingBottom - self.paddingTop) / 2 
  end
  
  love.graphics.setColor(self.textColor or {255,255,255,255})
  love.graphics.print(self.text,locX,locY)

end

local textWidth = function (self)
  return font:getWidth(self.text)
end

local textHeight = function (self)
  return font:getHeight()
end

return function(base, options)  
  base.render = renderText
  base.text = options.text
  base.textColor = options.textColor or {255,255,255,255}
  base.contentWidth = textWidth
  base.contentHeight = textHeight  
  return base
end