local renderChildren = function(self) 
  self:renderBackground()

  local locX, locY = self:startCoordsBasedOnGravity()

  for k, v in ipairs(self.children) do
    love.graphics.push()      
    love.graphics.translate( self.scaffold[v][1], self.scaffold[v][2])
    v:render()
    if debug then
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("line",0,0,v:availableWidth(),v:availableHeight())
    end    
    love.graphics.pop()
  end
end

local function clickedViews(self,x,y)
  local clicked = {}
  if x > 0 and x < self:grantedWidth()
  and y > 0 and y < self:grantedHeight() then
  
    for k, v in ipairs(self.children) do

      for _, deeperClicked in ipairs( v:clickedViews(x - self.scaffold[v][1], y - self.scaffold[v][2]) ) do
        table.insert( clicked, deeperClicked )
      end
    end    
    
    table.insert(clicked, self)    
  end
  return clicked
end

local function scaffoldViews(self)
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

  local locX, locY = self:startCoordsBasedOnGravity()

  for k, v in ipairs(self.children) do    
    self.scaffold[v] = { locX + tilt(k-1, 1), locY + tilt(k-1, 2) }
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
  self:scaffoldViews()
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

local function getLocationOffset(self, child)
  return self.scaffold[child][1], self.scaffold[child][2]
end

local function myChild(self, child)
  return self.scaffold[child]
end

local function signalTargetedChildren(self, signal, payload)
  local other = self:clickedViews(payload.x, payload.y)
  for i, v in ipairs(other) do
    if v ~= self and myChild(self, v) then
      local offsetX, offsetY = self:getLocationOffset(v)
      local thisPayload = { x = payload.x - offsetX , y = payload.y - offsetY }
      v:receiveSignal(signal, thisPayload)
    end
  end
end

return function(lc)
  return {
    build = function (base, options)
      base.renderCustom = renderChildren  
      base.layoutingPass = function(self) layout(self, self.children) end  
      base.contentWidth = containerWidth
      base.contentHeight = containerHeight
      base.tiltDirection = options.tiltDirection or {"none", "none"}
      base.tiltAmount = options.tiltAmount or {0,0}
      base.scaffoldViews = scaffoldViews
      base.scaffold = {}
      base.clickedViews = clickedViews
      base.getLocationOffset = getLocationOffset
      
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
    schema = lc:extendSchema("base", {
        tiltAmount = { 
          required = false, 
          schemaType = "table", 
          options = { 
            { required = true, schemaType = "number" }, 
            { required = true, schemaType = "number" }, 
          }
        },
        tiltDirection = { 
          required = false, 
          schemaType = "table", 
          options = { 
            { required = true, schemaType = "fromList", list = { "start", "none", "end" } }, 
            { required = true, schemaType = "fromList", list = { "start", "none", "end" } } 
          }
        }
      })
  }
end