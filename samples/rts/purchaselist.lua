return function(looky)
  return {
    build = function (options)
      
      local column = looky:build("linear", {width="fill", height="fill", background = { 70, 70, 70, 255 }, border = { thickness = 3, color = { 80, 80, 80, 255 } }, direction = "v", childSpacing = 5, padding = looky.padding(4) })
      
      local index = 1
      local toShow = 5
      
      local function prevIndex(self)
        if index > 1 then          
          self:getChild(index + toShow - 1).visibility = "gone"          
          index = index - 1
          self:getChild(index).visibility = "visible"
          self:layoutingPass()
        end
      end
      
      local function nextIndex(self)        
        if index + toShow - 1 < #self:getChildren() then          
          self:getChild(index).visibility = "gone"          
          index = index + 1
          self:getChild(index + toShow - 1).visibility = "visible"
          self:layoutingPass()
        end
      end
      
      column.externalSignalHandlers.down = function(self, signal, payload)        
        nextIndex(self)
      end
      column.externalSignalHandlers.up = function(self, signal, payload)
        prevIndex(self)
      end
      
      for i = 1, options.amount do
        local c = looky:build("buyoption", { num = i, filter = { love.math.random(1, 255), love.math.random(1, 255), love.math.random(1, 255), 255 }})
        if i > 5 then
          c.visibility = "gone"
        end
        column:addChild(c)
      end
      
      return column
    end,
    schema = {
      amount = {
        required = true,
        schemaType = "number"
      }
    }
  }
end