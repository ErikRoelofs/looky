local checkUnfamiliar = function(kind, schema, options, validator)
  for k, v in pairs(options) do
    assert(schema[k] ~= nil and schema[k] ~= false, "Unfamiliar option passed: " .. k .. " is not specified in the schema for " .. kind )
  end  
end

local checkRequired = function(kind, schema, options, validator)
  for k, v in pairs(schema) do
    if v and v.required then
      assert( options[k], "Missing an option: " .. k .. " that is required for kind: " .. kind )
    end
  end  
end

local typecheck = function(typeToCheck, kind, field, option)
  assert( type(option) == typeToCheck, "Was expecting a " .. typeToCheck .. " for field " .. field .. " in view " .. kind .. ", but got a " .. type(option) )
end

local checkBoolean = function(kind, field, schema, option, validator)
  typecheck("boolean", kind, field, option)
end

local checkString = function(kind, field, schema, option, validator)
  typecheck("string", kind, field, option)
end

local checkNumber = function(kind, field, schema, option, validator)
  typecheck("number", kind, field, option)
end

local checkFunction = function(kind, field, schema, option, validator)
  typecheck("function", kind, field, option)
end

local checkTable = function(kind, field, schema, option, validator)
  typecheck("table", kind, field, option)
  validator:validate( kind .. "." .. field, schema.options, option )
end

local checkArray = function(kind, field, schema, option,validator)
  typecheck("table", kind, field, option)
  local fn = validator:tryGetValidatorFunction(kind, schema.item)
  for key, value in ipairs(option) do
    --validator:validate( kind .. "[" .. key .. "]", schema.item, value )
    fn(kind, field .. "[" .. key .. "]", schema.item, value, validator )
  end
end

local fromList = function(kind, field, schema, option, validator)
  for key, value in ipairs(schema.list) do
    if value == option then
      return
    end
  end
  error( "Did not find " .. option .. " for field " .. field .. " of " .. kind .. " in list of allowed options: " .. table.concat(schema.list, ", "))
end

local oneOf = function(kind, field, schema, option, validator)
  for key, possibility in ipairs(schema.possibilities) do
    local fn = validator:tryGetValidatorFunction(kind, possibility)
    if pcall(fn, kind, field, possibility, option, validator) then
      return
    end
  end
  local triedOptions = {}
  for key, possibility in ipairs(schema.possibilities) do
    table.insert(triedOptions, possibility.schemaType)
  end
  error( "OneOf condition not met for field " .. field .. " of " .. kind .. ". I tried these, but none matched: " .. table.concat( triedOptions, ", " ) )
end

local betweenNumbers = function(kind, field, schema, option, validator)
  typecheck("number", kind, field, option)
  if option < schema.min or option > schema.max then
    error("Value " .. option .. " for " .. field .. " of " .. kind .. " should be between " .. schema.min .. " and " .. schema.max)
  end
end

local color = function(kind, field, schema, option, validator)
  local useSchema = {required = "true", schemaType="betweenNumbers", min = 0, max = 255}
  local fn = validator:tryGetValidatorFunction(kind, { schemaType = "betweenNumbers" } )
  fn(kind, field .. "[1]", useSchema, option[1], self)
  fn(kind, field .. "[2]", useSchema, option[2], self)
  fn(kind, field .. "[3]", useSchema, option[3], self)
  fn(kind, field .. "[4]", useSchema, option[4], self)
end

local validator = {
    schemaTypes = {},
    addschemaType = function(self, typename, fn)
      assert(not self.schemaTypes[typename], "Option type" .. typename .. " already exists; cannot register twice")
      self.schemaTypes[typename] = fn
    end,
    tryGetValidatorFunction = function(self, kind, schema)
      if schema and schema.schemaType then
        assert( self.schemaTypes[ schema.schemaType ], "Unknown schema type " .. schema.schemaType .. " from viewtype " .. kind .. ", please register it with the validator." )
        return self.schemaTypes[ schema.schemaType ]
      end
    end,
    validate = function(self, kind, schema, options)
      checkUnfamiliar(kind, schema, options, self)
      checkRequired(kind, schema, options, self)
      
      for field, schemaDescription in pairs(schema) do                
        local fn = self:tryGetValidatorFunction(kind, schemaDescription)
        if options[field] ~= nil and fn then
          fn(kind, field, schemaDescription, options[field], self)
        end
      end
    end
}

validator:addschemaType("boolean", checkBoolean)
validator:addschemaType("number", checkNumber)
validator:addschemaType("string", checkString)
validator:addschemaType("function", checkFunction)
validator:addschemaType("table", checkTable)
validator:addschemaType("fromList", fromList)
validator:addschemaType("oneOf", oneOf)
validator:addschemaType("betweenNumbers", betweenNumbers)
validator:addschemaType("color", color)
validator:addschemaType("array", checkArray)

return validator
