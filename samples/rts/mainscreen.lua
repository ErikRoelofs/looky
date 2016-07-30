return function(lc)
  return {
    build = function (options)
        
      local container = lc:build( "aquarium", {width="fill", height="fill", background = { 15,35,15,255} })
      for i = 1, 20 do
        container:addChild( lc:build("unit", {}), math.random(0, 1000), math.random(0,800))
      end
      
      return container
    end,
    schema = {}
  }
end