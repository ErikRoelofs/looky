return function(lc)
  return {
    build = function (options)
        
      local stack = lc:build( "stack", {width="fill", height=78, background = { file = "images/rts/unit.jpg", fill = "stretch" }, border = { thickness = 3, color = { 35, 35, 35, 255 }} })
      stack.building = false
      stack.externalSignalHandlers['mouse.down'] = function(self, signal, payload, coords)
        if coords[1].x > 0 and coords[1].x < self:grantedWidth() and coords[1].y > 0 and coords[1].y < self:grantedHeight() then
          if stack.building == false then
            stack.building = true
            stack:setBackground({255,255,255,255})
          end
        end
      end
      
      return stack
    end,
    schema = {}
  }
end