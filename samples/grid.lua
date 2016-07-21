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
  local text = lc:build("text", { width = "fill", height = "fill", data = function() return x .. ", " .. y end, backgroundColor = { x * 20, y * 20, x+y * 10, 255 }, gravity = {"center", "center"} })
  if x == 1 and y == 1 then
    text.externalSignalHandlers['mouse.hover'] = function(self, signal, payload)
      self.backgroundColor={100,100,100,255}
    end
    text.externalSignalHandlers['mouse.down'] = function(self, signal, payload)
      self.backgroundColor={255,255,255,255}
    end
    text.externalSignalHandlers['mouse.up'] = function(self, signal, payload)
      self.backgroundColor={0,0,0,255}
    end
    
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