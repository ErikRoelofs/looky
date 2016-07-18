local renderChildren = function(self) 

  local offset = 0
  
  for k, v in ipairs(self.visibleChildren) do
    love.graphics.push()    
    love.graphics.translate(self.scaffold[v][1], self.scaffold[v][2])
    
    v:render()
    if debug then
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("line",0,0,v:grantedWidth(),v:grantedHeight())
    end
    
    love.graphics.pop()
  end
end

local horizontalLayout = function(parent, children)  
  local availableSize = parent:availableWidth()
  local fills = {}
  local oneExists = false
  local toShow = {}
  for k, v in ipairs(children) do    
    if v:desiredWidth() == "fill" then
      table.insert(fills, v)      
    else
      oneExists = true
      local height = v:desiredHeight()
      if height == "fill" then
        height = parent:availableHeight()
      end
      if v:desiredWidth() + parent.childSpacing < availableSize then
        availableSize = availableSize - v:desiredWidth() - parent.childSpacing
        v:setDimensions(v:desiredWidth(), height)
        toShow[v] = true
      else
        if availableSize > 0 then
          toShow[v] = true
        end
        v:setDimensions(math.max(availableSize, 0), height)
        availableSize = 0
      end
    end
  end
  local inc = #fills
  if not oneExists then
    inc = inc - 1 -- we don't need extra spacing for the first element, since there is nothing yet
  end      
  local sizeForSpacing = inc * parent.childSpacing    
  if availableSize > sizeForSpacing and #fills > 0 then
    local sumWeight = 0
    for k, v in ipairs(fills) do
      sumWeight = sumWeight + v.weight
    end    
    for k, v in ipairs(fills) do
      local height = v:desiredHeight()
      if height == "fill" then
        height = parent:grantedHeight()
      end
      v:setDimensions((availableSize - sizeForSpacing)/ sumWeight * v.weight, height)
      toShow[v] = true
    end
  else
    for k, v in ipairs(fills) do
      v:setDimensions(0,0)
    end
  end
  
  parent.visibleChildren = {}
  for k, v in ipairs(children) do
    if toShow[v] then
      table.insert(parent.visibleChildren, v)
    end
    v:layoutingPass()
  end
end

local verticalLayout = function(parent, children)  
  local availableSize = parent:availableHeight()
  local fills = {}
  local oneExists = false
  local toShow = {}
  for k, v in ipairs(children) do
    if v:desiredHeight() == "fill" then
      table.insert(fills, v)
    else
      local width = v:desiredWidth()
      local oneExists = true
      if width == "fill" then
        width = parent:availableWidth()
      end
      if v:desiredHeight() + parent.childSpacing < availableSize then
        availableSize = availableSize - v:desiredHeight() - parent.childSpacing
        v:setDimensions(width, v:desiredHeight())
        toShow[v] = true
      else
        if availableSize > 0 then
          toShow[v] = true
        end
        v:setDimensions(width, math.max(availableSize, 0))
        availableSize = 0        
      end
    end
  end
  local inc = #fills
  if not oneExists then
    inc = inc - 1 -- we don't need extra spacing for the first element, since there is nothing yet
  end      
  local sizeForSpacing = inc * parent.childSpacing    
  if availableSize > sizeForSpacing and #fills > 0 then
    local sumWeight = 0
    for k, v in ipairs(fills) do
      sumWeight = sumWeight + v.weight    
    end
    for k, v in ipairs(fills) do
      local width = v:desiredWidth()
      if width == "fill" then
        width = parent:availableWidth()
      end
      toShow[v] = true
      v:setDimensions(width, (availableSize - sizeForSpacing ) / sumWeight * v.weight)
    end
  else
    for k, v in ipairs(fills) do
      v:setDimensions(0,0)      
    end
  end 
  parent.visibleChildren = {}
  for k, v in ipairs(children) do
    if toShow[v] then
      table.insert(parent.visibleChildren, v)
    end
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

local function scaffoldViews(self)
    
  local offset = 0
  local transX, transY = self.padding.left,self.padding.top
  self.scaffold = {}
  
  for k, v in ipairs(self.visibleChildren) do    
    if self.direction == "v" then 
      transY = transY + offset
      offset = offset + v:grantedHeight() + self.childSpacing
      if v.layoutGravity == "start" then
        transX = transX
        transY = transY
      elseif v.layoutGravity == "end" then
        transX = transX + self:availableWidth() - v:grantedWidth()
        transY = transY
      elseif v.layoutGravity == "center" then
        transX = transX + (self:availableWidth() - v:grantedWidth()) /2
        transY = transY
      end
    else
      transX = transX + offset
      offset = offset + v:grantedWidth() + self.childSpacing
      if v.layoutGravity == "start" then
        transX = transX
        transY = transY
      elseif v.layoutGravity == "end" then
        transX = transX
        transY = transY + self:availableHeight() - v:grantedHeight()
      elseif v.layoutGravity == "center" then
        transX = transX
        transY = transY + (self:availableHeight() - v:grantedHeight()) /2
      end
    end
    
    self.scaffold[v] = {transX, transY}    
    transX = self.padding.left
    transY = self.padding.top  
  end
end


local function clickedViews(self,x,y)
  local clicked = {}
  if x > 0 and x < self:grantedWidth()
  and y > 0 and y < self:grantedHeight() then
  
    for k, v in ipairs(self.visibleChildren) do

      for _, deeperClicked in ipairs( v:clickedViews(x - self.scaffold[v][1], y - self.scaffold[v][2]) ) do
        table.insert( clicked, deeperClicked )
      end
    end    
    
    table.insert(clicked, self)    
  end
  return clicked
end

local function clickShouldTargetChild(self, x, y, child)
  local relativeX = x - self.scaffold[v][1]
  local relativeY = y - self.scaffold[v][2]
  return relativeX > 0 and relativeY > 0 and 
    relativeX < child:getGrantedWidth() and relativeY < child:getGrantedHeight()
end

local function signalTargetedChildren(self, signal, payload)  
  for i, v in ipairs(self:getChildren()) do
    if clickShouldTargetChild(self, payload.x, payload.y, child) then
      local thisPayload = { x = payload.x - self.scaffold[child][1] , y = payload.y - self.scaffold[child][2] }
      v:receiveSignal(signal, thisPayload)
    end
  end
end

return function(lc)
  return {
    build = function (options)
      local base = lc:makeBaseLayout(options)
      base.renderCustom = renderChildren
      base.direction = options.direction or "v"
      if base.direction == "v" then
        base.layoutingPass = function(self)           
          verticalLayout(self, self.children) 
          self:scaffoldViews()
        end  
      else
        base.layoutingPass = function(self)           
          horizontalLayout(self, self.children) 
          self:scaffoldViews()
        end  
      end
      base.contentWidth = containerWidth
      base.contentHeight = containerHeight
      base.scaffoldViews = scaffoldViews
      base.childSpacing = options.childSpacing or 0      
      base.visibleChildren = {}
      base._removeChild = base.removeChild
      base.removeChild = function(self, child)      
        local search = self:_removeChild(child)        
        -- clean up the view from the visible views, or it will remain on the screen
        for k, v in ipairs(self.visibleChildren) do
          if v == search then
            table.remove(self.visibleChildren, k)
          end
        end
      end
      if not options.signalHandlers then
        options.signalHandlers = {}
        if not options.signalHandlers.leftclick then
          options.signalHandlers.leftclick = signalTargetedChildren
        end
      end
      base.signalHandlers = options.signalHandlers      
      base.update = function(self, dt)
        for k, v in ipairs(self.children) do
          v:update(dt)
        end
      end
      return base
    end,
    schema = lc:extendSchema("base", 
      {
        direction = { required = false, schemaType = "fromList", list = { "v", "h" } },
        childSpacing = { required = false, schemaType = "number" }
      }
    )
  }
end