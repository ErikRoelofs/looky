local renderText = function(self)  
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
  assert( type(str) == "string", "A text view is trying to determine the width of a non-string (type: " .. type(str) )
  return self.font:getWidth(str)
end

local textHeight = function (self)
  return self.font:getHeight()
end

return function(lc)
  return {
    build = function(options)
      local base = lc:makeBaseLayout(options)
      base.renderCustom = renderText
      base.data = options.data
      base.textColor = options.textColor or {255,255,255,255}
      base.contentWidth = textWidth
      base.contentHeight = textHeight
      base.font = lc:getFont(options.font or "base")
      base.dataKey = options.dataKey or "value"
      base.multiline = options.multiline or false
      if options.externalSignalHandlers then
        base.externalSignalHandlers = options.externalSignalHandlers
      end
      base.getData = function(self) 
        if type(self.data) == "function" then
          return self.data()
        else
          return self.data[self.dataKey]
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
            options = {},
            allowOther = true
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
      },
      dataKey = {
          required = false,
          schemaType = "string"
      },
      multiline = {
        required = false,
        schemaType = "boolean"
      }
    })
  }
end