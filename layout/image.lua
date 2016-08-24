local renderImage = function(self)
  local locX, locY = self:startCoordsBasedOnGravity()
  love.graphics.setColor(255,255,255,255)    
  love.graphics.draw(self.realImage, locX, locY, 0, self.scaleX, self.scaleY)
  
end

local function imageWidth(self)
  return self.image:getWidth() * self.scaledX
end

local function imageHeight(self)
  return self.image:getHeight() * self.scaledY
end

return function(looky)
  return {
    build = function (options)
      local base = looky:makeBaseLayout(options)
      base.renderCustom = renderImage
      if type(options.file) == "string" then
        base.image = love.graphics.newImage(options.file)
      else
        base.image = options.file
      end
      base.contentWidth = imageWidth
      base.contentHeight = imageHeight  
      base._setDimensions = base.setDimensions
      base.setDimensions = function(self, x, y)
        base._setDimensions(self,x,y)
        self.realImage, self.scaleX, self.scaleY = looky.imageHelper[self.scale](self, self.image)
      end
      base.scale = options.scale or "fit"
      base.scaledX = 1
      base.scaledY = 1
      return base
    end,
    schema = looky:extendSchema("base", 
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