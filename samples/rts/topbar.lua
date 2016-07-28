return function(lc)
  return {
    build = function (options)
      local container = lc:build("linear", {direction = "h", width = "fill", height = 30, background = {0,75,0,255}, padding = lc.padding(3)} )
      
      -- options button
      container:addChild( lc:build( "text", {width=200, height="fill", data = function() return "Options" end, background = { 120, 120, 120, 255 }, border = { thickness = 2, color = { 90, 90, 90, 255 }}, gravity = { "center", "center" }}))
      
      -- game title      
      container:addChild( lc:build( "text", {data = function() return "Affirmative & Acknowledged v0.0.1" end, width="fill", height="fill", gravity = { "center", "center" } }) )
      
      
      return container
    end,
    schema = {}
  }
end