return function(looky)
  return {
    build = function (options)
      local toUpdate = {options.back}
      
      local container = looky:build("stack", {width = options.width, height = options.height})
      container:addChild(options.back)
      
      local pane = looky:build("linear", {width="fill", height="fill", direction = "h" })
      
      local column1 = looky:build("linear", {width = "fill", height = "fill", direction = "v" })
      local column2 = looky:build("linear", {width = "fill", height = "fill", direction = "v" })
        
      local topleft
      if not options.topleft then
        topleft = looky:build("empty", {width = "fill", height = "fill"})
      else
        topleft = looky:build("filler", { right = "fill", bottom = "fill" })
        topleft:addChild(options.topleft)
        table.insert(toUpdate, options.topleft)
      end
      local bottomleft
      if not options.bottomleft then
        bottomleft = looky:build("empty", {width = "fill", height = "fill"})
      else
        bottomleft = looky:build("filler", {right = "fill", top = "fill"})
        bottomleft:addChild(options.bottomleft)
        table.insert(toUpdate, options.bottomleft)
      end
      
      column1:addChild(topleft)
      column1:addChild(bottomleft)
        
      local topright
      if not options.topright then
        topright = looky:build("empty", {width = "fill", height = "fill"})
      else
        topright = looky:build("filler", {left = "fill", bottom = "fill"})
        topright:addChild(options.topright)
        table.insert(toUpdate, options.topright)
      end
      local bottomright
      if not options.bottomright then
        bottomright = looky:build("empty", {width = "fill", height = "fill"})
      else
        bottomright = looky:build("filler", {left = "fill", top = "fill" })
        bottomright:addChild(options.bottomright)
        table.insert(toUpdate, options.bottomright)
      end
      
      column2:addChild(topright)
      column2:addChild(bottomright)
        
      pane:addChild( column1 )
      pane:addChild( column2 )
      container:addChild(pane)
      
      container.update = function(self, dt)
        for _, view in ipairs(toUpdate) do
          view:update(dt)
        end
      end
      
      return container
    end,
    schema = looky:extendSchema("base", 
      { 
        back = {
          required = true,
          schemaType = "table",
          allowOther = true,
          options = {},
        },
        topleft = {
          required = false,
          schemaType = "table",
          allowOther = true,
          options = {},
          
        },  
        topright = {
          required = false,
          schemaType = "table",
          allowOther = true,
          options = {},
        },
        bottomleft = {
          required = false,
          schemaType = "table",
          allowOther = true,
          options = {},
        },
        bottomright = {
          required = false,
          schemaType = "table",
          allowOther = true,
          options = {},
        }        
      })
  }
end