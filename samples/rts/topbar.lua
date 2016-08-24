return function(looky)
  return {
    build = function (options)
      local container = looky:build("linear", {direction = "h", width = "fill", height = 30, background = {0,75,0,255}, padding = looky.padding(3)} )
      
      -- options button
      local options = looky:build( "text", {width=200, height="fill", data = function() return "Options" end, background = { 120, 120, 120, 255 }, border = { thickness = 2, color = { 90, 90, 90, 255 }}, gravity = { "center", "center" }})
      options.externalSignalHandlers['mouse.down'] = function(self, signal, payload, coords)
        if self:coordsInMe(coords[1].x, coords[1].y) then
          self:messageOut("dialog.options")
        end
      end
      container:addChild( options )
      
      
      -- game title      
      container:addChild( looky:build( "text", {data = function() return "Affirmative & Acknowledged v0.0.1" end, width="fill", height="fill", gravity = { "center", "center" } }) )
      
      
      return container
    end,
    schema = {}
  }
end