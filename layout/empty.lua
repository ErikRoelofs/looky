local render = function(self) end

return function(looky)
  return {
    build = function(options)
      local base = looky:makeBaseLayout(options)
      base.renderCustom = render      
      base.contentWidth = function(self)
        return self.width
      end
      base.contentHeight = function(self)
        return self.height
      end
      return base
    end,
    schema = {
            width = { required = true, schemaType = "oneOf", possibilities = {
        { schemaType = "fromList", list = {"fill"} },
        { schemaType = "number" }            
      }},
      height = { required = true, schemaType = "oneOf", possibilities = {
        { schemaType = "fromList", list = {"fill"} },
        { schemaType = "number" }            
      }},
    }
  }
end