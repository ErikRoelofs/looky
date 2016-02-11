local renderImage = function(self)
  self:renderBackground()
  
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.image, self.marginLeft + self.paddingLeft, self.marginTop + self.paddingTop)
end

local function imageWidth(self)
  return self.image:getWidth() + self.paddingLeft + self.paddingRight
end

local function imageHeight(self)
  return self.image:getHeight() + self.paddingTop + self.paddingBottom
end


return function (base, options)
  base.render = renderImage
  base.image = love.graphics.newImage(options.file)
  base.contentWidth = imageWidth
  base.contentHeight = imageHeight  
  return base
end
