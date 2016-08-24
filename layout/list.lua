return function(looky)
  return {
    build = function (options)
      local container = looky:build("linear", {direction = "v", width = options.width, height = options.height, background = options.background, childSpacing = options.childSpacing or 5, padding = options.padding or looky.padding(15) })  
      
      local base = {width="fill", height="wrap"}
      local merged = looky.mergeOptions(base, options.textOptions or {})
      
      for k, v in ipairs( options.texts ) do
        local toPass = merged
        toPass.data = v
        container:addChild( looky:build( "text", toPass) )
      end
      return container
    end,
    schema = looky:extendSchema("base", {
        textOptions = { 
          required = false,
          schemaType = "table",
          options = looky:extendSchema("text", {width = false, height = false, data = false})}, 
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