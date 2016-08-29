return function(looky)
  return {
    build = function (options)      
      
      local getValue = function(self)
        if type(self.value) == "function" then
          return self.value()
        else
          return self.value.value
        end
      end
      
      local getMaxValue = function(self)
        if type(self.maxValue) == "function" then
          return self.maxValue()
        else
          return self.maxValue
        end
      end
                        
      local render = function(self)        
        love.graphics.setColor(self.filledColor)
        love.graphics.rectangle("fill", self.padding.left, self.padding.top, self:availableWidth() * ( self:getValue() / self:getMaxValue() ), self:availableHeight())
        
        if self.emptyColor then
          love.graphics.setColor(self.emptyColor)
          local left = self:availableWidth() * ( self:getValue() / self:getMaxValue() )
          love.graphics.rectangle("fill", self.padding.left + left, self.padding.top, self:availableWidth() - left, self:availableHeight())          
        end
        
        if self.notches then
          love.graphics.setColor(self.notches.color)
          for i = 1, self.notches.amount - 1 do
            local height = self:availableHeight() * (self.notches.height or 0.15)
            if self.notches.largerEvery and i % self.notches.largerEvery == 0 then
              height = height * 2
            end  
            love.graphics.rectangle("fill", self.padding.left + (self:availableWidth() * (i / self.notches.amount)), self.padding.top, 2, height)
            
          end
        end
      end
      
      local container = looky:build("freeform", {width = options.width, height = options.height, background = options.background, padding = options.padding, render = render, border = options.border})
      container.value = options.value
      container.getValue = getValue
      
      container.maxValue = options.maxValue
      container.getMaxValue = getMaxValue
      container.filledColor = options.filledColor
      container.emptyColor = options.emptyColor
      container.notches = options.notches
      
      container.contentWidth = function(self) return 0 end
      container.contentHeight = function(self) return 0 end
      
      
      return container
    end,
    schema = looky:extendSchema("base", {
      filledColor = { required = true, schemaType = "color" },
      emptyColor = { required = false, schemaType = "color" },
      maxValue = {
        required = true,
        schemaType = "oneOf",
        possibilities = {
          {
            schemaType = "number", 
          },
          {
            schemaType = "function",
          }
        }
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
      notches = {
        required = false,
        schemaType = "table",
        options = {
          color = {
            required = true,
            schemaType = "color"
          },
          amount = {
            required = true,
            schemaType = "number"
          },
          largerEvery = {
            required = false,
            schemaType = "number"
          },
          height = { 
            required = false,
            schemaType = "number"
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