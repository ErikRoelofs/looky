return function(lc)
  return {
    build = function (options)      
    local rf = function(self)
      love.graphics.setColor(0,255,0,255)
      local sX = self:availableWidth() / options.map.width 
      local sY = self:availableHeight() / options.map.height
      for _, unit in ipairs(options.units) do        
        love.graphics.rectangle("fill", unit.x *sX , unit.y * sY, 5, 5 )
      end    
    end
      
    return 
        lc:build( "freeform", {width="fill", height=200, background = { 0,0,0,255}, border = { thickness = 3, color = { 35, 35, 35, 255 }}, padding = lc.padding(3), render = rf })
    end,
    schema = {
      units = {
        required = true,
        schemaType = "units"
      },
      map = {
        required = true,
        schemaType = "map"
      }
    }
  }
end