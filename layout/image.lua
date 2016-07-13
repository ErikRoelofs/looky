local renderImage = function(self)
  local locX, locY = self:startCoordsBasedOnGravity()
  love.graphics.setColor(255,255,255,255)
  
  local function fit(self)
    local scaledX = self:availableWidth() / self.image:getWidth()
    local scaledY = self:availableHeight() / self.image:getHeight()
    local scale = math.min(scaledX, scaledY)
    self.scaledX = scale
    self.scaledY = scale    
  end
  
  local function stretch(self)
    local scaleX = self:availableWidth() / self.image:getWidth()
    local scaleY = self:availableHeight() / self.image:getHeight()        
  end
  
  local function crop(self)
    stretch(self)
    local canvas = love.graphics.newCanvas(self:availableWidth(), self:availableHeight())
    love.graphics.setCanvas(canvas)
    love.graphics.push()
    love.graphics.origin()
    love.graphics.draw(self.image, 0, 0)
    love.graphics.setCanvas()
    love.graphics.pop()
    love.graphics.draw(canvas, locX, locY)
  end
    
  if self.scale == "fit" then
    fit(self)
    love.graphics.draw(self.image, locX, locY, 0, self.scaledX, self.scaledY)
  elseif self.scale == "stretch" then
    stretch(self)
    love.graphics.draw(self.image, locX, locY, 0, self.scaledX, self.scaledY)
  elseif self.scale == "crop" then
    crop(self)
  end
  
end


local function imageWidth(self)
  return self.image:getWidth() * self.scaledX
end

local function imageHeight(self)
  return self.image:getHeight() * self.scaledY
end


return function(lc)
  return {
    build = function (base, options)
      base.renderCustom = renderImage
      if type(options.file) == "string" then
        base.image = love.graphics.newImage(options.file)
      else
        base.image = options.file
      end
      base.contentWidth = imageWidth
      base.contentHeight = imageHeight  
      base.scale = options.scale or "fit"
      base.scaledX = 1
      base.scaledY = 1
      return base
    end,
    schema = lc:extendSchema("base", 
      {
        file = {        
          required = true,           
          schemaType = "oneOf",
          possibilities = {
              {
                schemaType = "string"
              },
              {
                schemaType = "image"
              }
          }
        }, 
        scale = {
          required = false, 
          schemaType="fromList", 
          list = {
            "fit", 
            "stretch",
            "crop"
          }
        }
      })
  }
end