return function(lc)
  return {
    build = function (options)
      local container = lc:build("stack", {width = options.width, height = options.height})
      container:addChild(options.back)
      
      local pane = lc:build("linear", {width="fill", height="fill", direction = "h" })
      
      local column1 = lc:build("linear", {width = "fill", height = "fill", direction = "v" })
      local column2 = lc:build("linear", {width = "fill", height = "fill", direction = "v" })
        
      local topleft = lc:build("linear", {width = "fill", height = "fill", direction = "h" })
      if options.topleft then
        topleft:addChild(options.topleft)
      end
      local bottomleft = lc:build("linear", {width = "fill", height = "fill", direction = "h" })
      if options.bottomleft then
        bottomleft:addChild(options.bottomleft)
      end
      column1:addChild(topleft)
      column1:addChild(bottomleft)
        
      local topright = lc:build("linear", {width = "fill", height = "fill", direction = "h" })
      if options.topright then
        topright:addChild(options.topright)
      end
      local bottomright = lc:build("linear", {width = "fill", height = "fill", direction = "h" })
      if options.bottomright then
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