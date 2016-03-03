local renderChildren = function(self) 
  self:renderBackground()

  local offset = 0
  
  for k, v in ipairs(self.children) do
    love.graphics.push()
    if self.direction == "v" then 
      love.graphics.translate(0, offset)
      offset = offset + v:grantedHeight()
      if v.layoutGravity == "start" then
        love.graphics.translate( v.margin.left, v.margin.top )
      elseif v.layoutGravity == "end" then
        love.graphics.translate( self:availableWidth() - v:grantedWidth() - v.margin.right, v.margin.top )
      elseif v.layoutGravity == "center" then
        love.graphics.translate( (self:availableWidth() - v:grantedWidth()) /2 - (v.margin.left - v.margin.right) / 2, v.margin.top )
      end
    else
      love.graphics.translate(offset, 0)
      offset = offset + v:grantedWidth()
      if v.layoutGravity == "start" then
        love.graphics.translate( v.margin.left, v.margin.top )
      elseif v.layoutGravity == "end" then
        love.graphics.translate( v.margin.left, self:availableHeight() - v:grantedHeight() - v.margin.bottom )
      elseif v.layoutGravity == "center" then
        love.graphics.translate( v.margin.left, (self:availableHeight() - v:grantedHeight()) /2 - (v.margin.top - v.margin.bottom) / 2)
      end
    end
    
    
    v:render()
    if debug then
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("line",0,0,v:availableWidth(),v:availableHeight())
    end
    
    love.graphics.pop()
  end
end

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
    local sumWeight = 0
    for k, v in ipairs(fills) do
      sumWeight = sumWeight + v.weight
    end    
    for k, v in ipairs(fills) do
      local height = v:desiredHeight()
      if height == "fill" then
        height = parent:grantedHeight()
      end
      v:setDimensions(availableSize / sumWeight * v.weight, height)
    end
  end
  
  for k, v in ipairs(children) do    
    v:layoutingPass()
  end
end

local verticalLayout = function(parent, children)
  local availableSize = parent:availableHeight()
  local fills = {}
  for k, v in ipairs(children) do
    if v:desiredHeight() == "fill" then
      table.insert(fills, v)
    else
      local width = v:desiredWidth()
      if width == "fill" then
        width = parent:availableWidth()
      end
      if v:desiredHeight() < availableSize then
        availableSize = availableSize - v:desiredHeight()            
        v:setDimensions(width, v:desiredHeight())
      else
        v:setDimensions(width, availableSize)
        availableSize = 0
      end
    end
  end
  if availableSize > 0 then
    local sumWeight = 0
    for k, v in ipairs(fills) do
      sumWeight = sumWeight + v.weight    
    end
    for k, v in ipairs(fills) do
      local width = v:desiredWidth()
      if width == "fill" then
        width = parent:availableWidth()
      end
      v:setDimensions(width, availableSize / sumWeight * v.weight)
    end
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
      if self.direction == "v" then
        if v:desiredWidth() > width then
          width = v:desiredWidth()
        end
      else
        width = width + v:desiredWidth()
      end
    end
  end
  return width
end

local function containerHeight(self)
  local height = 0
  for k, v in ipairs(self.children) do
    if v:desiredHeight() == "fill" then
      return "fill"
    else
      if self.direction == "v" then
        height = height + v:desiredHeight()
      else
        if v:desiredHeight() > height then
          height = v:desiredHeight()
        end
      end
    end
  end
  return height
end

return {
  build = function (base, options)
    base.render = renderChildren
    base.direction = options.direction or "v"
    if base.direction == "v" then
      base.layoutingPass = function(self) verticalLayout(self, self.children) end  
    else
      base.layoutingPass = function(self) horizontalLayout(self, self.children) end  
    end
    base.contentWidth = containerWidth
    base.contentHeight = containerHeight
    base.update = function(self, dt)
      for k, v in ipairs(self.children) do
        v:update(dt)
      end
    end
    return base
  end,
  schema = lc:extendSchema("base", {direction = { required = false, schemaType = "fromList", list = { "v", "h" } },})
}
