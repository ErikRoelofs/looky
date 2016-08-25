return function(looky) 
  return { 
    build = function(options)  
      local base = looky:makeBaseLayout(options)
      base.contentWidth = options.contentWidth or function(self) return 0 end
      base.contentHeight = options.contentHeight or function(self) return 0 end
      
      base.update = options.update or function(self, dt) end
      base.freeformRender = options.render or function(self, dt) end      
      base.renderCustom = function(self)
        love.graphics.setCanvas(self.canvas)
        love.graphics.clear()
        self:freeformRender()
        love.graphics.setCanvas()
        love.graphics.draw(self.canvas, self.padding.left, self.padding.top)
      end
      base._setDimensions = base.setDimensions
      base.setDimensions = function(self, x,y)
        self:_setDimensions(x,y)
        self.canvas = love.graphics.newCanvas(self:availableWidth(),self:availableHeight())
      end
      
      return base
    end,
    schema = looky:extendSchema("base", { render = { required = false, schemaType = "function" }, update = { required = false, schemaType = "function" }})
  }
end