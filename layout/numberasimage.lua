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
      
      local container = looky:build("linear", {direction = options.direction or "h", width = options.width, height = options.height, background = options.background, padding = options.padding, border = options.border })
      container.value = options.value
      container.maxValue = options.maxValue
      container.getValue = getValue      
      if type(options.image) == "string" then
        container.image = love.graphics.newImage(options.image)
      else
        container.image = options.image
      end
      if type(options.emptyImage) == "string" then
        container.emptyImage = love.graphics.newImage(options.emptyImage)
      else
        container.emptyImage = options.emptyImage
      end
      
      container.contentWidth = function(self) return options.maxValue * self:filledChild():contentWidth() end
      container.contentHeight = function(self) return self:filledChild():contentHeight() end        
      
      container.update = function(self, dt)        
        if self:getValue() ~= self.lastValue then
          self:removeAllookyhildren()          
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
        return looky:build("image", { width = "wrap", height = "wrap", file = self.image } )
      end
      
      container.emptyChild = function(self)
        return looky:build("image", { width = "wrap", height = "wrap", file = self.emptyImage } )
      end
      
      return container
    end,
    schema = looky:extendSchema("base", {
      image = {        
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
      emptyImage = {        
        required = false,
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