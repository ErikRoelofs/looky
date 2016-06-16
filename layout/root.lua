return function(lc)
  return {
    build = function(base, options)  
      
      local baseOptions = {direction="h", width="fill", height="fill", backgroundColor = options.backgroundColor or {0,0,0,0}}
      local child = lc:build("linear", lc.mergeOptions(baseOptions, options))
      local root = {
        base = base,
        addChild = function(self, child, position)
          self.linear:addChild(child, position)
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
          love.graphics.push()
          love.graphics.translate(self.linear.margin.left, self.linear.margin.right)            
          self.linear:render()
          love.graphics.pop()
        end,
        update = function(self, dt)
          self.linear:update(dt)
        end,
        getChild = function(self, number)
          return self.linear:getChild(number)
        end,
        getChildren = function(self)
          return self.linear:getChildren()
        end,
        removeChild = function(self,target)
          self.linear:removeChild(target)
        end,
        removeAllChildren = function(self)
          self.linear:removeAllChildren()
        end,
        clickedViews = function(self, x, y)
          return self.linear:clickedViews(x, y)
        end
      }
      root:setLinear(child)
      return root
    end,
    schema = lc:extendSchema("base", {width = false, height = false, direction = { required = false, schemaType="fromList", list = { "h", "v" }}})
  }
end