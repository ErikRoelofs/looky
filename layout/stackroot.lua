return function(looky)
  return {
    build = function(options)  
      local base = looky:makeBaseLayout(options)
      local baseOptions = {width="fill", height="fill", background = options.background or {0,0,0,0}}
      local child = looky:build("stack", looky.mergeOptions(baseOptions, options))
      local root = {
        base = base,
        addChild = function(self, child, position)
          self.stack:addChild(child, position)
        end,
        setLinear = function(self,child)
          self.stack = child
        end,
        addListener = function(self, listener, method)
          self.stack:addListener(listener, method)
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
          return love.graphics.getWidth() - self.padding.left - self.padding.right
        end,
        availableHeight = function(self)
          return love.graphics.getHeight() - self.padding.top - self.padding.bottom
        end,
        layoutingPass = function(self)
          self.stack:setDimensions( self:grantedWidth(), self:grantedHeight() )
          self.stack:layoutingPass()
        end,
        render = function(self)
          self.stack:render()
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
        removeAllchildren = function(self)
          self.stack:removeAllchildren()
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
        receiveOutsideSignal = function(self, signal, payload, coords)
          self.stack:receiveOutsideSignal(signal, payload, coords)
        end,
        receiveChildSignal = function(self, signal, payload, coords)
          self.stack:receiveChildSignal(signal, payload, coords)
        end,        
      }
      root:setLinear(child)
      root.signalHandlers = root.stack.signalHandlers
      return root
    end,
    schema = looky:extendSchema("base", {width = false, height = false})
  }
end