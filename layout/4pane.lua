return function(lc)
  return {
    build = function (options)
      local container = lc:build("stack", {width = options.width, height = options.height})
      container:addChild(options.back)
      
      local pane = lc:build("linear", {width="fill", height="fill", direction = "h" })
      
      local column1 = lc:build("linear", {width = "fill", height = "fill", direction = "v" })
      local column2 = lc:build("linear", {width = "fill", height = "fill", direction = "v" })
        
      local topleft
      if not options.topleft then
        topleft = lc:build("empty", {width = "fill", height = "fill"})
      else
        topleft = lc:build("border", {left = 0, right = "fill", top = 0, bottom = "fill" })
        topleft:addChild(options.topleft)
      end
      local bottomleft
      if not options.bottomleft then
        bottomleft = lc:build("empty", {width = "fill", height = "fill"})
      else
        bottomleft = lc:build("border", {left = 0, right = "fill", top = "fill", bottom = 0})
        bottomleft:addChild(options.bottomleft)
      end
      
      column1:addChild(topleft)
      column1:addChild(bottomleft)
        
      local topright
      if not options.topright then
        topright = lc:build("empty", {width = "fill", height = "fill"})
      else
        topright = lc:build("border", {left = "fill", right = 0, top = 0, bottom = "fill", background = { 0, 0, 255, 255 }})
        topright:addChild(options.topright)
      end
      local bottomright
      if not options.bottomright then
        bottomright = lc:build("empty", {width = "fill", height = "fill"})
      else
        bottomright = lc:build("border", {left = "fill", right = 0, top = "fill", bottom = 0})
        bottomright:addChild(options.bottomright)
      end
      
      column2:addChild(topright)
      column2:addChild(bottomright)
        
      pane:addChild( column1 )
      pane:addChild( column2 )
      container:addChild(pane)
      
      return container
    end,
    schema = lc:extendSchema("base", 
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