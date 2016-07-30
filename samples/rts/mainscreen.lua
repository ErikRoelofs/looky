return function(lc)
  return {
    build = function (options)
        
      local container = lc:build( "aquarium", {width="fill", height="fill", background = { 15,35,15,255}, useCanvas = true })
      for _, unit in ipairs(options.units) do
        container:addChild( lc:build("unit", {}), unit.x, unit.y)
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
      }
    }
  }
end