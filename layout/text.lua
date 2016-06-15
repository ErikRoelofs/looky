local renderText = function(self)
  self:renderBackground()
  love.graphics.setFont(self.font)
  local locX, locY = self:startCoordsBasedOnGravity()
  love.graphics.setColor(self.textColor or {255,255,255,255})
  local toPrint = self:getData()
  
  if self:contentWidth() > self:grantedWidth() then    
    while self:contentWidth(toPrint) > self:grantedWidth() do
      toPrint = toPrint:sub(0,-2)
    end
    love.graphics.print(toPrint,locX,locY)
  else
    love.graphics.print(toPrint,locX,locY)
  end

end

local textWidth = function (self, str)
  str = str or self:getData()
  return self.font:getWidth(str)
end

local textHeight = function (self)
  return self.font:getHeight()
end

return function(lc)
  return {
    build = function(base, options)
      base.renderCustom = renderText
      base.data = options.data
      base.textColor = options.textColor or {255,255,255,255}
      base.contentWidth = textWidth
      base.contentHeight = textHeight
      base.font = lc:getFont(options.font or "base")
      base.getData = function(self) 
        if type(self.data) == "function" then
          return self.data()
        else
          return self.data.value
        end
      end
      return base
    end,
    schema = lc:extendSchema("base",  {
      data = { 
        required = true, 
        schemaType = "oneOf",
        possibilities = {
          {
            schemaType = "table", 
            options = { 
              value = { 
                required = true, 
                schemaType ="string" 
              } 
            } 
          },
          {
            schemaType = "function",
          }
        }
      }, 
      textColor = { 
        required = false, 
        schemaType = "color" 
      }, 
      font = { 
        required = false, 
        schemaType = "string" 
      } 
    })
  }
end