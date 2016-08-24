return function(looky)
  return {
    build = function (options)
      local container = looky:build("linear", {direction = "v", width = "fill", height = "fill", background = {75,75,75,255}, padding = looky.padding(20)})
            
      local upButton = looky:build("text", {width="fill", height="wrap", padding = looky.padding(20, 10), background = { 40, 40, 40, 255 }, border = { thickness = 3, color = { 30, 30, 30, 255 } }, data = function() return "UP" end })
      upButton.externalSignalHandlers['mouse.down'] = function(self, signal, payload, coords)
        if self:coordsInMe(coords[1].x, coords[1].y) then
          self:messageOut("up", {}, {})
        end
      end
      container:addChild(upButton)
            
      local buyOptions = looky:build("linear", {width="fill", height="fill", background = { 60, 60, 60, 255 }, border = { thickness = 3, color = { 30, 30, 30, 255 } }, direction = "h", childSpacing = 5, padding = looky.padding(4) })
      
      local leftColumn = looky:build("purchaselist", {amount = 10})
      local rightColumn = looky:build("purchaselist", {amount = 15})
      
      buyOptions:addChild(leftColumn)
      buyOptions:addChild(rightColumn)
      
      container:addChild(buyOptions)
            
      local downButton = looky:build("text", {width="fill", height="wrap", padding = looky.padding(20, 10), background = { 40, 40, 40, 255 }, border = { thickness = 3, color = { 30, 30, 30, 255 } }, data = function() return "DOWN" end})
      downButton.externalSignalHandlers['mouse.down'] = function(self, signal, payload, coords)
        if self:coordsInMe(coords[1].x, coords[1].y) then
          self:messageOut("down", {}, {})
        end
      end
      container:addChild(downButton)

      local pass = function(self, signal, payload, coords)
        leftColumn:receiveOutsideSignal(signal, payload, coords)
        rightColumn:receiveOutsideSignal(signal, payload, coords)
      end
      container.childSignalHandlers.up = pass 
      container.childSignalHandlers.down = pass

      return container
    end,
    schema = {}
  }
end