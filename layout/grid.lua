return function(lc)
  return {
    build = function (options)
      local container = lc:build("linear", {width = options.width, height = options.height, direction="h"})
      local i = 0
      while i < options.columns do
        -- add the column
        local column = lc:build("linear", { width = "fill", height = "fill", direction="v" })      
        local j = 0
        while j < options.rows do
          column:addChild( lc:build( "border", { left = "fill", right = "fill", top = "fill", bottom = "fill" } ))
          j = j +1
        end
        container:addChild(column)
        i = i +1
      end
      
      container.setChild = function(self, child, x, y)
        self:getChild(x):getChild(y):removeAllChildren()
        self:getChild(x):getChild(y):addChild(child)
      end
      container.removeChild = function(self, x, y) 
        self:getChild(x):getChild(y):removeAllChildren()
      end
    
    
      
      return container
    end,
    schema = lc:extendSchema("base", {
      rows = {
        required = true,
        schemaType = "number"
      },
      columns = {
        required = true,
        schemaType = "number"
      }
    })
  }
end