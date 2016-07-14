return function(lc) 
  return { 
    build = function(options)  
      local base = lc:makeBaseLayout(options)
      base.contentWidth = options.contentWidth or function(self) return 0 end
      base.contentHeight = options.contentHeight or function(self) return 0 end
      
      base.update = options.update or function(self, dt) end
      base.renderCustom = options.render or function(self, dt) end
      
      return base
    end,
    schema = lc:extendSchema("base", { render = { required = false, schemaType = "function" }, update = { required = false, schemaType = "function" }})
  }
end