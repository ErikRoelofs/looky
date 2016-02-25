local  function baseLayout(width, height)
  return {
    children = {},
    parent = nil,
    width = width,
    height = height,
    addChild = function(self, child, position)
      local position = position or #self.children+1
      table.insert(self.children, position, child)
      child:setParent(self)
    end,
    setParent = function(self, parent)
      self.parent = parent
    end,
    desiredWidth = function(self)
      if self.width == "fill" then
        return self.width
      elseif self.width == "wrap" then
        local content = self:contentWidthWithPadding()
        if content == "fill" then
          return content
        else
          return content + self.margin.left + self.margin.right
        end
      else
        return self.width + self.margin.left + self.margin.right
      end
    end,
    desiredHeight = function(self)
      if self.height == "fill" then
        return self.height
      elseif self.height == "wrap" then
        local content = self:contentHeightWithPadding()
        if content == "fill" then
          return content
        else
          return content + self.margin.top + self.margin.bottom
        end
      else        
        return self.height + self.margin.top + self.margin.bottom
      end
    end,
    grantedWidth = function(self)
      return self.givenWidth
    end,
    grantedHeight = function(self)
      return self.givenHeight
    end,
    setDimensions = function(self, x, y)
      self.givenWidth = x
      self.givenHeight = y
    end,
    availableWidth = function(self)
      return self:grantedWidth() - self.margin.left - self.margin.right
    end,
    availableHeight = function(self)
      return self:grantedHeight() - self.margin.top - self.margin.bottom
    end,
    layoutingPass = function(self)
      
    end,
    render = function(self)
    
    end,
    update = function(self, dt)
      
    end,
    contentWidth = function(self)
      return 0
    end,
    contentHeight = function(self)
      return 0
    end,
    contentWidthWithPadding = function(self)
      return self:contentWidth() + self.padding.left + self.padding.right
    end,
    contentHeightWithPadding = function(self)
      return self:contentHeight() + self.padding.top + self.padding.bottom
    end,
    renderBackground = function(self)
      love.graphics.setColor(self.backgroundColor)
      local width = self:availableWidth()
      local height = self:availableHeight()
      love.graphics.rectangle("fill", 0, 0, width, height)
      self:renderBorder()
    end,
    renderBorder = function(self)
      love.graphics.setColor(self.border.color)
      love.graphics.setLineWidth(self.border.thickness)
      local width = self:availableWidth()
      local height = self:availableHeight()
      love.graphics.rectangle("line", self.border.thickness/2, self.border.thickness/2, width - self.border.thickness, height - self.border.thickness)
      love.graphics.setLineWidth(1)
    end,
    startCoordsBasedOnGravity = function(self)
      local locX, locY
      if self.gravity[1] == "start" then
        locX = self.padding.left
      elseif self.gravity[1] == "end" then
        locX = self:availableWidth() - self:contentWidth() - self.padding.left
      elseif self.gravity[1] == "center" then
        locX = (self:availableWidth() - self:contentWidth() - self.padding.left - self.padding.right) / 2
      end
      if self.gravity[2] == "start" then
        locY = self.padding.top
      elseif self.gravity[2] == "end" then
        locY = self:availableHeight() - self:contentHeight() - self.padding.bottom
      elseif self.gravity[2] == "center" then
        locY = (self:availableHeight() - self:contentHeight() - self.padding.bottom - self.padding.top) / 2 
      end
      return locX, locY
    end,
    getChild = function(self, number)
      return self.children[number]
    end,
    removeChild = function(self,target)
      if type(target) == "number" then
        table.remove(self.children, target)
        return target
      else
        for k, v in ipairs(self.children) do
          if v == target then
            table.remove(self.children, k)
            return k
          end
        end
      end
    end
  }
end

paddingMarginHelper = function(left, top, right, bottom)
  if left == nil and top == nil and right == nil and bottom == nil then
    return paddingMarginHelper(0,0,0,0)
  elseif top == nil and right == nil and bottom == nil then
    if type(left) == "table" then
      return paddingMarginHelper(left.left or 0, left.top or 0, left.right or 0, left.bottom or 0)
    else
      return paddingMarginHelper(left,left,left,left)
    end
  elseif right == nil and bottom == nil then
    return paddingMarginHelper(left,top,left,top)  
  else
    return {
      left = left,
      top = top,
      right = right,
      bottom = bottom
    }
  end
end
  
  return {
    kinds = {},
    build = function( self, kind, options )      
      assert(self.kinds[kind], "Requesting layout " .. kind .. ", but I do not have it")
      local base = self:makeBaseLayout(options)
      return self.kinds[kind](base, options)
    end,
    register = function( self, name, fn )
      assert(not self.kinds[name], "A layout named " .. name .. " was previously registered")
      self.kinds[name] = fn
    end,
    padding = function(left, top, right, bottom)
      return paddingMarginHelper(left, top, right, bottom)
    end,
    margin =  function(left, top, right, bottom)
      return paddingMarginHelper(left, top, right, bottom)
    end,
    makeBaseLayout = function(self, options)
      local start = baseLayout(options.width, options.height)      
      start.padding = self.padding(options.padding)
      start.margin = self.margin(options.margin)      
      start.backgroundColor = options.backgroundColor or {0,0,0,0}
      start.border = options.border or { color = { 0, 0, 0, 0 }, thickness = 0 }
      start.layoutGravity = options.layoutGravity or "start"
      start.gravity = options.gravity or {"start","start"}
      start.weight = options.weight or 1
      return start
    end,
    mergeOptions = function (baseOptions, options)
      for k, v in pairs(options) do
        baseOptions[k] = v
      end
    return baseOptions
end

  }
