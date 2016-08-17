return function(lc)
  return {
    build = function (options)
      local container = lc:build("linear", {direction = "h", width = "fill", height = 25 })
      container:addChild( lc:build("image", { width = "wrap", height = "wrap", file = options.img }))
      container:addChild( lc:build("ast.numberAsBar", { 
        value = options.value,
        maxValue = options.maxValue
      }))
      return container
    end,
    schema = {
      img = {
        required = true,
        schemaType = "string"
      },
      value = {
        required = true,
        schemaType = "function"
      },
      maxValue = {
        required = true,
        schemaType = "number"
      },
    }
  }
end