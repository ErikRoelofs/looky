{  
  listeners = {},
  addListener = function(self, listener) end
  signalAll = function(self, signal, payload) end
  signalSpecific = function(self, target, signal, payload) end
  getListeners = function(self) end
}

view = {
  listeners = {},
  addChild = function(self, child)
    -- add to table        
    child:addListener(self, "receiveChildMessage")
  end,
  -- PUBLIC
  addListener = function(self, listener, method)
    table.insert(self.listeners, { target = listener, method = method })
  end,
  -- PRIVATE
  receiveChildMessage = function(self, signal, payload)
    
  end,
  -- PUBLIC
  receiveOutsideMessage = function(self, signal, payload)
    
  end,  
  signalAll = function(self, signal, payload)
    for k, v in ipairs(self.children) do
      v:receiveOutsideMessage() -- public
    end
  end,
  signalSpecific = function(self, target, signal, payload)
    -- bla
  end,
  
  
}