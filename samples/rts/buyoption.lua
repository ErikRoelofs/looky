return function(lc)
  return {
    build = function (options)
      
    return lc:build( "stack", {width=78, height=78, background = { 15,15,15,255}, border = { thickness = 3, color = { 35, 35, 35, 255 }} })
    
    end,
    schema = {}
  }
end