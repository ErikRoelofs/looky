function mainview(lc)
  
  root = lc:build("root",{})
  local grid = lc:build("grid", { width = "fill", height="fill", rows = 5, columns = 5 } )
  root:addChild(grid)
  
  local i = 1
  while i <= 5 do
    local j = 1
    while j <= 5 do
      addText(lc, grid, i, j)
      j = j +1
    end
    i = i + 1
  end
  
  root:layoutingPass()

  return root
end

function addText(lc, grid, x, y)
  local text
  if x == 1 and y == 1 then
    text = lc:build("text", { width = "fill", height = "fill", data = { cookies = "nomnomnom" }, dataKey = "cookies", background = { file = "images/heart.png", fill = "fill" }, gravity = {"center", "center"} })

    text.origBackground = text.background
    text.externalSignalHandlers['mouse.hover'] = function(self, signal, payload)
      if payload.x > 0 and payload.x < self:availableWidth()
        and payload.y > 0 and payload.y < self:availableHeight() then        
        self.background ={100,100,100,255}
      else
        self.background = self.origBackground
      end
    end
    text.externalSignalHandlers['mouse.down'] = function(self, signal, payload)
      if payload.x > 0 and payload.x < self:availableWidth()
        and payload.y > 0 and payload.y < self:availableHeight() then
        self.background ={255,255,255,255}
      else
        self.background = self.origBackground
      end
      
    end
    text.externalSignalHandlers['mouse.up'] = function(self, signal, payload)      
      self.background = self.origBackground
    end
  else
    text = lc:build("text", { width = "fill", height = "fill", data = function() return x .. ", " .. y end, background = { x * 20, y * 20, x+y * 10, 255 }, gravity = {"center", "center"} })
  end
  grid:setChild(text,x,y)
end

return function(lc)
  return {
    root = mainview(lc),
    update = function(self, dt)       
      self.root:update(dt)
    end,
    draw = function(self)
      self.root:render()      
    end
  }
end