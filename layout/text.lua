local renderText = function(self)
  self:renderBackground()
  
  love.graphics.setColor(self.textColor or {255,255,255,255})
  love.graphics.print(self.text,self.paddingLeft,self.paddingTop)

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