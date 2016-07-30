return function(lc)
  return {
    build = function (options)
      
      return lc:build( "text", {width="wrap", height="wrap", background = { file = "images/rts/unit.jpg", fill = "stretch" }, border = { thickness = 3, color = { 35, 35, 35, 255 }}, data = function() return "unit" end, padding = lc.padding(30) })
    
    end,
    schema = {}
  }
end