return function(lc)
  return {
    build = function(base, options)  
      
      local baseOptions = {width="fill", height="fill", backgroundColor = options.backgroundColor or {0,0,0,0}}
      local child = lc:build("stack", lc.mergeOptions(baseOptions, options))
      local root = {
        base = base,
        addChild = function(self, child, position)
          self.stack:addChild(child, position)
        end,
        setLinear = function(self,child)
          self.stack = child
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
          self.stack:setDimensions( self:availableWidth(), self:availableHeight() )
          self.stack:layoutingPass()
        end,
        render = function(self)
          love.graphics.push()
          love.graphics.translate(self.stack.margin.left, self.stack.margin.right)            
          self.stack:render()
          love.graphics.pop()
        end,
        update = function(self, dt)
          self.stack:update(dt)
        end,
        getChild = function(self, number)
          return self.stack:getChild(number)
        end,
        removeChild = function(self,target)
          self.stack:removeChild(target)
        end,
        removeAllChildren = function(self)
          self.stack:removeAllChildren()
        end,
        clickedViews = function(self, x, y)
          return self.stack:clickedViews(x, y)
        end,
        receiveSignal = function(self, signal, payload)
          return self.stack:receiveSignal(signal, payload)
        end,
        signalChildren = function(self, signal, payload)
          return self.stack:signalChildren(signal, payload)
        end,
        messageOut = function(self, signal, payload)
          return self.stack:messageOut(signal, payload)
        end,        
      }
      root:setLinear(child)
      root.signalHandlers = root.stack.signalHandlers
      return root
    end,
    schema = lc:extendSchema("base", {width = false, height = false})
  }
end