return function(lc)
  return {
    build = function (options)
      local container = lc:build("linear", {direction = "v", width = "fill", height = "fill", background = {75,75,75,255}, padding = lc.padding(20)})
            
      local upButton = lc:build("text", {width="fill", height="wrap", padding = lc.padding(20, 10), background = { 40, 40, 40, 255 }, border = { thickness = 3, color = { 30, 30, 30, 255 } }, data = function() return "UP" end })
      container:addChild(upButton)
            
      local buyOptions = lc:build("linear", {width="fill", height="fill", background = { 60, 60, 60, 255 }, border = { thickness = 3, color = { 30, 30, 30, 255 } }, direction = "h", childSpacing = 5, padding = lc.padding(4) })
      
      local leftColumn = lc:build("purchaselist", {})
      local rightColumn = lc:build("purchaselist", {})
      
      buyOptions:addChild(leftColumn)
      buyOptions:addChild(rightColumn)
      
      container:addChild(buyOptions)
            
      local downButton = lc:build("text", {width="fill", height="wrap", padding = lc.padding(20, 10), background = { 40, 40, 40, 255 }, border = { thickness = 3, color = { 30, 30, 30, 255 } }, data = function() return "DOWN" end})
      container:addChild(downButton)

      return container
    end,
    schema = {}
  }
end