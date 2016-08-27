return function(looky)
  return {
    build = function (options)
      local container = looky:build("linear", {width = options.width, height = options.height, direction="h"})
      local i = 0
      while i < options.columns do
        -- add the column
        local column = looky:build("linear", { width = "fill", height = "fill", direction="v" })      
        local j = 0
        while j < options.rows do
          column:addChild( looky:build( "filler", { left = "fill", right = "fill", top = "fill", bottom = "fill" } ))
          j = j +1
        end
        container:addChild(column)
        i = i +1
      end
      
      container.setChild = function(self, child, x, y)
        self:getChild(x):getChild(y):removeAllchildren()
        self:getChild(x):getChild(y):addChild(child)
      end
      container.removeChild = function(self, x, y) 
        self:getChild(x):getChild(y):removeAllchildren()
      end
    
    
      
      return container
    end,
    schema = looky:extendSchema("base", {
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