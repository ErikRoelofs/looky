return function(lc)
  return {
    build = function (options)      
      
      local getValue = function(self)
        if type(self.value) == "function" then
          return self.value()
        else
          return self.value.value
        end
      end
            
      local render = function(self)
        love.graphics.setColor(self.filledColor)
        love.graphics.rectangle("fill", 0, 0, self:availableWidth() * ( self:getValue() / self.maxValue ), self:availableHeight())
        
      end
            
      local container = lc:build("freeform", {width = options.width, height = options.height, background = options.background, padding = options.padding, render = render})
      container.value = options.value
      container.maxValue = options.maxValue
      container.getValue = getValue
      container.filledColor = options.filledColor
      container.emptyColor = options.emptyColor
        
      container.contentWidth = function(self) return 0 end
      container.contentHeight = function(self) return 0 end
      
      
      return container
    end,
    schema = lc:extendSchema("base", {
      filledColor = { required = true, schemaType = "color" },
      emptyColor = { required = false, schemaType = "color" },
      maxValue = {
        required = true,
        schemaType = "number"
      },
      value = {
        required = true, 
        schemaType = "oneOf",
        possibilities = {
          {
            schemaType = "table", 
            options = { 
              value = { 
                required = true, 
                schemaType ="number" 
              } 
            } 
          },
          {
            schemaType = "function",
          }
        }
      },
      direction = { 
        required = false, 
        schemaType = "fromList", list = { "v", "h" } 
      }
    })  
  }
end