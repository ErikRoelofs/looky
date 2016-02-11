-- root needs to inherit from linearlayout
local horizontalLayout = function(parent, children)
  local availableSize = parent:availableWidth()
  local fills = {}
  for k, v in ipairs(children) do
    if v:desiredWidth() == "fill" then
      table.insert(fills, v)
    else
      local height = v:desiredHeight()
      if height == "fill" then
        height = parent:availableHeight()
      end
      if v:desiredWidth() < availableSize then
        availableSize = availableSize - v:desiredWidth()            
        v:setDimensions(v:desiredWidth(), height)
      else
        v:setDimensions(availableSize, height)
        availableSize = 0
      end
    end
  end
  if availableSize > 0 then
    for k, v in ipairs(fills) do
      local height = v:desiredHeight()
      if height == "fill" then
        height = parent:grantedHeight()
      end
      v:setDimensions(availableSize / #fills, height)
    end
  end
  
  for k, v in ipairs(children) do    
    v:layoutingPass()
  end
end

return {
  children = {},
  addChild = function(self, child)
    table.insert(self.children, child)
    child:setParent(self)
  end,
  desiredWidth = function(self)
    return love.graphics.getWidth()
  end,
  desiredHeight = function(self)
    return love.graphics.getHeight()
  end,
  grantedWidth = function(self)
    return love.graphics.getWidth()
  end,
  grantedHeight = function(self)
    return love.graphics.getHeight()
  end,
  availableWidth = function(self)
    return love.graphics.getWidth()
  end,
  availableHeight = function(self)
    return love.graphics.getHeight()
  end,
  layoutingPass = function(self)
    horizontalLayout(self, self.children)      
  end,
  render = function(self)
    local offset = 0
    
    for k, v in ipairs(self.children) do
      love.graphics.push()
      love.graphics.translate(offset, 0)
      offset = offset + v:grantedWidth()
        
      v:render()
      
      love.graphics.pop()
    end      
  end  
}
