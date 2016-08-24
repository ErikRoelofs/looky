return function(looky)
  return {
    build = function (options)
        
      local container = looky:build( "aquarium", {width="fill", height="fill", background = { 15,35,15,255}, useCanvas = true })
      container.locX = options.locX
      container.locY = options.locY

      for _, unit in ipairs(options.units) do
        local child = looky:build("unit", {})
        child.unit = unit
        container:addChild( child, child.unit.x - container.locX , child.unit.y - container.locY)
      end
      
      local move = function(self, x, y)        
        self.locX = self.locX + x
        self.locY = self.locY + y
        if self.locX < 0 then
          self.locX = 0
        elseif self.locX > options.map.width then
          self.locX = options.map.width
        end
        
        if self.locY < 0 then
          self.locY = 0
        elseif self.locY > options.map.height then
          self.locY = options.map.height
        end
        
      end
      
      container.externalSignalHandlers['key.held'] = function(self, signal, payload)
        if payload.key == "up" then
          move(self, 0, -500 * payload.dt)
        elseif payload.key == "down" then
          move(self, 0, 500 * payload.dt)
        elseif payload.key == "left" then
          move(self, -500 * payload.dt, 0)
        elseif payload.key == "right" then
          move(self, 500 * payload.dt, 0)
        end
      end
      
      container.update = function(self, dt)
        for _, child in ipairs( self:getChildren() ) do
          self:setOffset( child, child.unit.x - self.locX, child.unit.y - self.locY )
        end        
      end
      
      return container
    end,
    schema = {
      units = {
        required = true,
        schemaType = "units",
      },
      map = {
        required = true,
        schemaType = "map"
      },
      locX = {
        required = true,
        schemaType = "number"
      },
      locY = {
        required = true,
        schemaType = "number"
      },
    }
  }
end