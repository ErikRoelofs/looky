return function(lc)
  return {
    build = function (options)
        
      local container = lc:build( "aquarium", {width="fill", height="fill", background = { 15,35,15,255}, useCanvas = true })
      container.locX = options.locX
      container.locY = options.locY

      for _, unit in ipairs(options.units) do
        local child = lc:build("unit", {})
        child.unit = unit
        container:addChild( child, child.unit.x - container.locX , child.unit.y - container.locY)
      end
      
      
      container.externalSignalHandlers.move = function(self, signal, payload)
        self.locX = payload.x
        self.locY = payload.y
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