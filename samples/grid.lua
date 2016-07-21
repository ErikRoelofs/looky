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
  grid:setChild(lc:build("text", { width = "wrap", height = "wrap", data = function() return x .. ", " .. y end }),x,y)
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