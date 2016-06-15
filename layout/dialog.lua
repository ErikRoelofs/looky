return function(lc)
  return {
    build = function (base, options)
      local container = lc:build("linear", {direction = "v", width = options.width, height = options.height, backgroundColor = {0,0,255,255}})  
      container:addChild( lc:build( "image", {file = options.file, width="wrap", height="wrap", layoutGravity = "center" } ))
      container:addChild( lc:build( "text", {data = options.textdata, width="wrap", height="wrap", backgroundColor = {255,0,0,255}, textColor={0,255,0,255}, padding = lc.padding(5) }) )
      return container
    end,
    schema = lc:extendSchema("base", 
      { 
        file = { required = true, schemaType = "string" },       
        textdata = { 
          required = true, 
          schemaType = "table", 
          options = {
            value = { required = true, schemaType = "string" }
          } 
        }
      })
  }
end