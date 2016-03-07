local renderImage = function(self)
  self:renderBackground()
  
  local locX, locY = self:startCoordsBasedOnGravity()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.image, locX, locY)
end

local function imageWidth(self)
  return self.image:getWidth()
end

local function imageHeight(self)
  return self.image:getHeight()
end


return function(lc)
  return {
    build = function (base, options)
      base.render = renderImage
      base.image = love.graphics.newImage(options.file)
      base.contentWidth = imageWidth
      base.contentHeight = imageHeight  
      return base
    end,
    schema = lc:extendSchema("base", {file = {required = true, schemaType = "string"}})
  }
end