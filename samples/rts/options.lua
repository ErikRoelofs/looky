return function(looky)
  return {
    build = function (options)
        
      values = { 
        { value = "normally there would be options here" }, 
        { value = "but that seems besides the point" }, 
        { value = "so I'll just leave those" }, 
        { value = "as an excercise to the reader" },       
      }
      local border = looky:build( "border", {left = "fill", right = "fill", top = "fill", bottom = "fill"})
      local container = looky:build( "linear", { width = 300, height = 350, direction = "v" })
      
      local wrapRight = looky:build( "border", {left = "fill", right = 0, top = 0, bottom = 0})
      
      local closeButton = looky:build( "text", { width = 100, height = "wrap", padding = looky.padding(5), background = { 120, 120, 120, 255 }, border = { color = { 140, 140, 140, 255 }, thickness = 3 }, data = function() return "Close" end } )
      local content = looky:build( "list", {width = "fill", height = "fill", texts = values, background = { 100, 125, 125, 200 }, gravity = { "center", "center" } })
      
      closeButton.externalSignalHandlers['mouse.down'] = function(self, signal, payload, coords )
        print(coords[1].x .. ", " .. coords[1].y )
        if self:coordsInMe(coords[1].x, coords[1].y) then
          self:messageOut("dialog.options.close")
        end
      end
      
      
      border:addChild(container)
      wrapRight:addChild(closeButton)
      container:addChild(wrapRight)
      container:addChild(content)
      
      return border
    end,
    schema = {}
  }
end