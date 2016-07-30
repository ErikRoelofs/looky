return function(lc)
  return {
    build = function (options)
      
      local leftColumn = lc:build("linear", {width="fill", height="fill", background = { 70, 70, 70, 255 }, border = { thickness = 3, color = { 80, 80, 80, 255 } }, direction = "v", childSpacing = 5, padding = lc.padding(4) })
      
      for i = 1, 5 do
        leftColumn:addChild(lc:build("buyoption", {}))
      end
      
      return leftColumn
    end,
    schema = {}
  }
end