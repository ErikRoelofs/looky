return function(lc)
  return {
    build = function (options)
      
      return lc:build( "text", {width="wrap", height="wrap", background = { 160,160,160,255}, border = { thickness = 3, color = { 35, 35, 35, 255 }}, data = function() return "unit" end, padding = lc.padding(4) })
    
    end,
    schema = {}
  }
end