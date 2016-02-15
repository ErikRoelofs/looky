local renderText = function(self)
  self:renderBackground()
  
  local locX, locY
  if self.gravity == "start" then
    locX = self.paddingLeft
    locY = self.paddingTop
  elseif self.gravity == "end" then
    locX = self:grantedWidth() - self.paddingRight - self:contentWidth()
    locY = self.paddingTop
  elseif self.gravity == "center" then
    locX = (self:grantedWidth() - self:contentWidth() - self.paddingRight - self.paddingLeft) / 2
    locY = self.paddingTop
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