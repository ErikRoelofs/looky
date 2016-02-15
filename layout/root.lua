return function(base, options)  
  local child = lc:build("linear", {direction="h", width="fill", height="fill", backgroundColor = options.backgroundColor or {0,0,0,0}})
  local root = {
    addChild = function(self, child)
      self.linear:addChild(child)
    end,
    setLinear = function(self,child)
      self.linear = child
      self.linear:setParent(self)
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
      self.linear:setDimensions( self:availableWidth(), self:availableHeight() )
      self.linear:layoutingPass()
    end,
    render = function(self)
      self.linear:render()
    end  
  }
  root:setLinear(child)
  return root
end