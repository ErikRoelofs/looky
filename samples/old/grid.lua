function mainview(looky)
  
  root = looky:build("root",{})
  local grid = looky:build("grid", { width = "fill", height="fill", rows = 5, columns = 5 } )
  root:addChild(grid)
  
  local i = 1
  while i <= 5 do
    local j = 1
    while j <= 5 do
      addText(looky, grid, i, j)
      j = j +1
    end
    i = i + 1
  end
  
  root:layoutingPass()

  return root
end

function addText(looky, grid, x, y)
  local text
  if x == 3 and y == 3 then
    text = looky:build("text", { width = "fill", height = "fill", data = { cookies = "nomnomnom" }, dataKey = "cookies", background = { file = "images/heart.png", fill = "fill" }, gravity = {"center", "center"} })


    text.origBackground = text.background

    text.externalSignalHandlers['mouse.hover'] = function(self, signal, payload, coords)
      if coords[1].x > 0 and coords[1].x < self:availableWidth()
        and coords[1].y > 0 and coords[1].y < self:availableHeight() then        
        self:setBackground({100,100,100,255})
      end
    end
    text.externalSignalHandlers['mouse.down'] = function(self, signal, payload, coords)
      if coords[1].x > 0 and coords[1].x < self:availableWidth()
        and coords[1].y > 0 and coords[1].y < self:availableHeight() then
        self:setBackground({255,255,255,255})
      else
        self:setBackground(self.origBackground)
      end
      
    end
    text.externalSignalHandlers['mouse.up'] = function(self, signal, payload, coords)      
      self:setBackground(self.origBackground)
    end
    text.externalSignalHandlers['key.down'] = function(self, signal, payload, coords)
      if payload.key == "q" then
        self:setBackground({255,0,0,255})
      elseif payload.key == "w" then
        self:setBackground({0,255,0,255})
      elseif payload.key == "e" then
        self:setBackground({0,0,255,255})
      else
        self:setBackground(self.origBackground)
      end
      
    end
  else
    text = looky:build("text", { width = "fill", height = "fill", data = function() return x .. ", " .. y end, background = { x * 20, y * 20, x+y * 10, 255 }, gravity = {"center", "center"} })
  end
  grid:setChild(text,x,y)
end

return function(looky)
  return {
    root = mainview(looky),
    update = function(self, dt)       
      self.root:update(dt)
    end,
    draw = function(self)
      self.root:render()      
    end
  }
end