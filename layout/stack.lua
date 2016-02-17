local renderChildren = function(self) 
  self:renderBackground()

  local hTilt, vTilt
  local tilt = function (number, direction)
    if self.tiltDirection[direction] == "start" then
      return (self.tiltAmount[direction] * (#self.children-1)) - (self.tiltAmount[direction] * number)
    elseif self.tiltDirection[direction] == "none" then
      return 0
    elseif self.tiltDirection[direction] == "end" then
      return self.tiltAmount[direction] * number
    end     
  end

  for k, v in ipairs(self.children) do
    love.graphics.push()      
    love.graphics.translate( v.marginLeft + tilt(k-1, 1), v.marginTop + tilt(k-1, 2))
    v:render()
    if debug then
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("line",0,0,v:availableWidth(),v:availableHeight())
    end    
    love.graphics.pop()
  end
end

local function layout(self, children)
  local maxWidth = self:availableWidth()
  local maxHeight = self:availableHeight()
  for k, v in ipairs(children) do
    local childWidth, childHeight
    if v:desiredWidth() == "fill" then
      childWidth = maxWidth
    else
      childWidth = math.min(maxWidth, v:desiredWidth())
    end
    
    if v:desiredHeight() == "fill" then
      childHeight = maxHeight
    else
      childHeight = math.min(maxHeight, v:desiredHeight())
    end
    
    v:setDimensions(childWidth, childHeight)
    
  end
  
  for k, v in ipairs(children) do    
    v:layoutingPass()
  end
end

local function containerWidth(self)  
  local width = 0
  for k, v in ipairs(self.children) do
    if v:desiredWidth() == "fill" then
      return "fill"
    else
      if v:desiredWidth() > width then
        width = v:desiredWidth()
      end
    end
  end
  return width + (self.tiltAmount[1] * #self.children)
end

local function containerHeight(self)
  local height = 0
  for k, v in ipairs(self.children) do
    if v:desiredHeight() == "fill" then
      return "fill"
    else
      if v:desiredHeight() > height then
        height = v:desiredHeight()
      end
    end
  end
  height = height + (self.tiltAmount[2] * #self.children)
  return height
end

return function (base, options)
  base.render = renderChildren  
  base.layoutingPass = function(self) layout(self, self.children) end  
  base.contentWidth = containerWidth
  base.contentHeight = containerHeight
  base.tiltDirection = options.tiltDirection or {"none", "none"}
  base.tiltAmount = options.tiltAmount or {0,0}
  return base
end
