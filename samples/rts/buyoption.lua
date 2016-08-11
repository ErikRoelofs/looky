return function(lc)
  return {
    build = function (options)
        
      local stack = lc:build( "text", {width="fill", height=78, background = { file = "images/rts/unit.jpg", fill = "stretch", colorFilter = options.filter }, border = { thickness = 3, color = { 35, 35, 35, 255 }}, data = function() return "#" .. options.num end, padding = lc.padding(5) })
      stack.building = false
      stack.externalSignalHandlers['mouse.down'] = function(self, signal, payload, coords)
        if self:coordsInMe(coords[1].x, coords[1].y) then
          if stack.building == false then
            stack.building = true
            stack:setBackground({255,255,255,255})
          end
        end
      end
      
      return stack
    end,
    schema = {
      num = {
        required = true,
        schemaType = "number"
      },
      filter = {
        required = true,
        schemaType = "color"
      }
    }
  }
end