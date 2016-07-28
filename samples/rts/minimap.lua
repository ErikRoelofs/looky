return function(lc)
  return {
    build = function (options)
      
    return lc:build( "text", {width="fill", height=200, data = function() return "" end, background = { 0,0,0,255}, border = { thickness = 3, color = { 35, 35, 35, 255 }}, padding = lc.padding(3) })
    
    end,
    schema = {}
  }
end