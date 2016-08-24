return function(looky)
  return {
    build = function (options)
      local container = looky:build("linear", {direction = "v", width = 300, height = "fill", background = {0,75,0,255}})
            
    -- cash amount
      container:addChild( looky:build( "text", {width="fill", height=40, data = function() return "$ " .. getCash() end, gravity = { "center", "center" }, padding = looky.padding(3), background = { 0, 90, 0, 255 } }))
      
    -- minimap
    container:addChild( looky:build( "minimap", {units = units, map = map}))
    
    -- purchase bar
    container:addChild( looky:build( "purchase", {}))
      
      return container
    end,
    schema = {}
  }
end