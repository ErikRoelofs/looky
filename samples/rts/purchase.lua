return function(lc)
  return {
    build = function (options)
      local container = lc:build("linear", {direction = "v", width = "fill", height = "fill", background = {75,75,75,255}, padding = lc.padding(20)})
            
      local upButton = lc:build("text", {width="fill", height="wrap", padding = lc.padding(20, 10), background = { 40, 40, 40, 255 }, border = { thickness = 3, color = { 30, 30, 30, 255 } }, data = function() return "UP" end })
      container:addChild(upButton)
            
      local buyOptions = lc:build("linear", {width="fill", height="fill", background = { 60, 60, 60, 255 }, border = { thickness = 3, color = { 30, 30, 255, 255 } }, direction = "h", childSpacing = 5, padding = lc.padding(4) })
      
      local leftColumn = lc:build("linear", {width="fill", height="fill", background = { 255, 70, 70, 255 }, border = { thickness = 3, color = { 80, 255, 80, 255 } }, direction = "v", childSpacing = 5, padding = lc.padding(4) })
      local rightColumn = lc:build("linear", {width="fill", height="fill", background = { 255, 70, 70, 255 }, border = { thickness = 3, color = { 80, 80, 80, 255 } }, direction = "v", childSpacing = 5, padding = lc.padding(4) })
      
      
      for i = 1, 5 do
        leftColumn:addChild(lc:build("buyoption", {}))
        rightColumn:addChild(lc:build("buyoption", {}))
      end
      
      buyOptions:addChild(leftColumn)
      buyOptions:addChild(rightColumn)
      container:addChild(buyOptions)
            
            
      local downButton = lc:build("text", {width="fill", height="wrap", padding = lc.padding(20, 10), background = { 40, 40, 40, 255 }, border = { thickness = 3, color = { 30, 30, 30, 255 } }, data = function() return "DOWN" end, visibility="cloaked" })
      container:addChild(downButton)

      return container
    end,
    schema = {}
  }
end