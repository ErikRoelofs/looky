return function(looky)
  return {
    build = function (options)
      local container = looky:build("linear", {direction = "h", width = "fill", height = 25 })
      container:addChild( looky:build("image", { width = "wrap", height = "wrap", file = options.img }))
      container:addChild( looky:build("ast.numberAsBar", { 
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