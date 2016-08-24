return function(looky)
  return {
    build = function (options)
      local container = looky:build("linear", {direction = "v", width = options.width, height = options.height, background = {0,0,255,255}})  
      container:addChild( looky:build( "image", {file = options.file, width="wrap", height="wrap" } ))
      container:addChild( looky:build( "text", {data = options.textdata, width="wrap", height="wrap", background = {255,0,0,255}, textColor={0,255,0,255}, padding = looky.padding(5) }) )
      return container
    end,
    schema = looky:extendSchema("base", 
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