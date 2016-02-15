local  function baseLayout(width, height)
  return {
    children = {},
    parent = nil,
    width = width,
    height = height,
    addChild = function(self, child)
      table.insert(self.children, child)
      child:setParent(self)
    end,
    setParent = function(self, parent)
      self.parent = parent
    end,
    desiredWidth = function(self)
      if self.width == "fill" then
        return self.width
      elseif self.width == "wrap" then
        local content = self:contentWidth()
        if content == "fill" then
          return content
        else
          return content + self.marginLeft + self.marginRight
        end
      else
        return self.width + self.marginLeft + self.marginRight
      end
    end,
    desiredHeight = function(self)
      if self.height == "fill" then
        return self.height
      elseif self.height == "wrap" then
        local content = self:contentHeight()
        if content == "fill" then
          return content
        else
          return content + self.marginTop + self.marginBottom
        end
      else        
        return self.height + self.marginTop + self.marginBottom
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
      return self:grantedWidth() - self.marginLeft - self.marginRight
    end,
    availableHeight = function(self)
      return self:grantedHeight() - self.marginTop - self.marginBottom
    end,
    layoutingPass = function(self)
      
    end,
    render = function(self)
    
    end,
    contentWidth = function(self)
      return 0
    end,
    contentHeight = function(self)
      return 0
    end,
    renderBackground = function(self)
      love.graphics.setColor(self.backgroundColor)
      local width = self:grantedWidth() - (self.marginLeft + self.marginRight)
      local height = self:grantedHeight() - (self.marginTop + self.marginBottom)
      love.graphics.rectangle("fill", self.marginLeft, self.marginTop, width, height)    
    end

  }
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
    makeBaseLayout = function(self, options)
      local start = baseLayout(options.width, options.height)
      start.paddingLeft = options.paddingLeft or 0
      start.paddingTop = options.paddingTop or 0
      start.paddingRight = options.paddingRight or 0
      start.paddingBottom = options.paddingBottom or 0
      start.marginLeft = options.marginLeft or 0
      start.marginTop = options.marginTop or 0
      start.marginRight = options.marginRight or 0
      start.marginBottom = options.marginBottom or 0
      start.backgroundColor = options.backgroundColor or {0,0,0,0}
      start.layoutGravity = options.layoutGravity or "start"
      start.gravity = options.gravity or "start"
      return start
    end,
    mergeOptions = function (baseOptions, options)
      for k, v in pairs(options) do
        baseOptions[k] = v
      end
    return baseOptions
end

  }
