return function(lc)
  return {
    build = function (base, options)      
      
      local getValue = function(self)
        if type(self.value) == "function" then
          return self.value()
        else
          return self.value.value
        end
      end
            
      local container = lc:build("linear", {direction = options.direction or "h", width = options.width, height = options.height, backgroundColor = {0,0,255,255}, margin = options.margin, padding = options.padding})
      container.value = options.value
      container.maxValue = options.maxValue
      container.getValue = getValue      
      
      container.contentWidth = function(self) return options.maxValue * self:filledChild():contentWidth() end
      container.contentHeight = function(self) return self:filledChild():contentHeight() end
      
      container.update = function(self, dt)
        if self:getValue() ~= self.lastValue then
          self:removeAllChildren()
          self.lastValue = self:getValue()
          local toRender = math.max( math.min(self:getValue(), self.maxValue), 0 )
          local emptyToRender = 0
          if options.emptyImage then
            emptyToRender = self.maxValue - toRender
          end
          
          local i = 0
          while i < toRender do
            i = i + 1
            self:addChild(self:filledChild())
          end
          local i = 0
          while i < emptyToRender do
            i = i + 1
            self:addChild(self:emptyChild())
          end
          self:layoutingPass()
        end
      end
      
      container.filledChild = function(self)
        return lc:build("image", { width = "wrap", height = "wrap", file = options.image } )
      end
      
      container.emptyChild = function(self)
        return lc:build("image", { width = "wrap", height = "wrap", file = options.emptyImage } )
      end
      
      return container
    end,
    schema = lc:extendSchema("base", {
        image = {
          required = true,
          schemaType = "string"
        },
        emptyImage = {
          required = false,
          schemaType = "string"
        },
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
                  schemaType ="string" 
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