return function(base, options)  
  base.contentWidth = options.contentWidth or function(self) return 0 end
  base.contentHeight = options.contentHeight or function(self) return 0 end
  
  base.update = options.update or function(self, dt) end
  base.render = options.render or function(self, dt) end
  
  return base
end