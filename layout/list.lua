return function(lc)
  return {
    build = function (options)
      local container = lc:build("linear", {direction = "v", width = options.width, height = options.height, background = options.background, childSpacing = options.childSpacing or 5, padding = options.padding or lc.padding(15) })  
      
      local base = {width="fill", height="wrap"}
      local merged = lc.mergeOptions(base, options.textOptions or {})
      
      for k, v in ipairs( options.texts ) do
        local toPass = merged
        toPass.data = v
        container:addChild( lc:build( "text", toPass) )
      end
      return container
    end,
    schema = lc:extendSchema("base", {
        textOptions = { 
          required = false,
          schemaType = "table",
          options = lc:extendSchema("text", {width = false, height = false, data = false})}, 
        texts = { 
          required = true, 
          schemaType = "array", 
          item = {
            required = true,
            schemaType = "table",
            options = {
              value = { 
                required = "true", 
                schemaType = "string" }
            }
          }
        }
      })  
  }
end