return function(lc)
  return {
    build = function (options)
      local container = lc:build("linear", {direction = "v", width = 300, height = "fill", background = {0,75,0,255}})
            
    -- cash amount
      container:addChild( lc:build( "text", {width="fill", height=40, data = function() return "$ " .. getCash() end, gravity = { "center", "center" }, padding = lc.padding(3), background = { 0, 90, 0, 255 } }))
      
    -- minimap
    container:addChild( lc:build( "minimap", {units = units, map = map}))
    
    -- purchase bar
    container:addChild( lc:build( "purchase", {}))
      
      return container
    end,
    schema = {}
  }
end