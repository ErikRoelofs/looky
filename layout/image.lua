local renderImage = function(self)
  self:renderBackground()
  
  local locX, locY = self:startCoordsBasedOnGravity()
  love.graphics.setColor(255,255,255,255)
  
  local function fit()
    local scaleX = self:availableWidth() / self.image:getWidth()
    local scaleY = self:availableHeight() / self.image:getHeight()
    local scale = math.min(scaleX, scaleY)
    love.graphics.draw(self.image, locX, locY, 0, scale, scale )    
  end
  
  local function stretch()
    local scaleX = self:availableWidth() / self.image:getWidth()
    local scaleY = self:availableHeight() / self.image:getHeight()    
    love.graphics.draw(self.image, locX, locY, 0, scaleX, scaleY )    
  end
  
  local function crop()    
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
    fit()
  elseif self.scale == "stretch" then
    stretch()
  elseif self.scale == "crop" then
    crop()
  end
  
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
      base.renderCustom = renderImage
      base.image = love.graphics.newImage(options.file)
      base.contentWidth = imageWidth
      base.contentHeight = imageHeight  
      base.scale = options.scale or "fit"
      return base
    end,
    schema = lc:extendSchema("base", 
      {
        file = {
          required = true, 
          schemaType = "string"
        }, 
        scale = {
          required = false, 
          schemaType="fromList", 
          list = {
            "fit", 
            "stretch",
            "keep",
            "crop"
          }
        }
      })
  }
end