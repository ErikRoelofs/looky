-- I think this needs a rework, it stores validators, schemas and partials in one table
local expandSchema = function(schema, validator)
  for k, item in pairs(schema) do
    if type(item) == "table" and type(validator.schemaTypes[item.schemaType]) == "table" then
      for key, value in pairs(validator.schemaTypes[item.schemaType]) do
        schema[k][key] = value
      end
    end
  end  
end

local checkUnfamiliar = function(kind, schema, options, validator)
  for k, v in pairs(options) do
    assert(schema[k] ~= nil and schema[k] ~= false, "Unfamiliar option passed: " .. k .. " is not specified in the schema for " .. kind )
  end  
end

local checkRequired = function(kind, schema, options, validator)
  for k, v in pairs(schema) do
    if v and v.required then
      assert( options[k] ~= nil, "Missing an option: " .. k .. " that is required for kind: " .. kind )
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
  assert(schema.options, "When using a Table schema, you must also provide the table's options.")
  validator:validate( kind .. "." .. field, schema.options, option, schema.allowOther )
end

local checkDictionary = function(kind, field, schema, option, validator)
  typecheck("table", kind, field, option)
  -- todo: implement the rest of this
end

local checkImage = function(kind, field, schema, option, validator)
  typecheck("userdata", kind, field, option)
end

local checkArray = function(kind, field, schema, option,validator)
  typecheck("table", kind, field, option)
  expandSchema(schema.item, validator)
  local fn = validator:tryGetValidatorFunction(kind, schema.item)
  for key, value in ipairs(option) do    
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
    expandSchema(schema.possibilities, validator)
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


return function() 
  local validator = {
    schemaTypes = {},
    addSchemaType = function(self, typename, fn)      
      assert(not self.schemaTypes[typename], "Option type " .. typename .. " already exists; cannot register twice")
      self.schemaTypes[typename] = fn
    end,
    addPartialSchema = function(self, typename, table)
      assert(not self.schemaTypes[typename], "Option type " .. typename .. " already exists; cannot register twice")
      self.schemaTypes[typename] = table
    end,
    tryGetValidatorFunction = function(self, kind, schema)
      if schema and schema.schemaType then
        assert( self.schemaTypes[ schema.schemaType ], "Unknown schema type " .. schema.schemaType .. " from viewtype " .. kind .. ", please register it with the validator." )
        assert( type(self.schemaTypes[ schema.schemaType ]) == "function", "Schema for type " .. schema.schemaType .. " is not a function, but a " .. type(self.schemaTypes[ schema.schemaType ]) )
        return self.schemaTypes[ schema.schemaType ]
      end
    end,
    validate = function(self, kind, schema, options, ignoreUnfamiliar)
      if not ignoreUnfamiliar then
        checkUnfamiliar(kind, schema, options, self)
      end
      checkRequired(kind, schema, options, self)
      expandSchema(schema, self)
      
      for field, schemaDescription in pairs(schema) do
        if schemaDescription ~= false then
          local fn = self:tryGetValidatorFunction(kind, schemaDescription)                
          if options[field] ~= nil and fn then
            fn(kind, field, schemaDescription, options[field], self)
          else
            if not fn then
              error("Could not find the validation function for: " .. field .. ", in layout: " .. kind)
            end
          end
        end
      end
    end
  }

  
  validator:addSchemaType("boolean", checkBoolean)
  validator:addSchemaType("number", checkNumber)
  validator:addSchemaType("string", checkString)
  validator:addSchemaType("function", checkFunction)
  validator:addSchemaType("table", checkTable)
  validator:addSchemaType("image", checkImage)
  validator:addSchemaType("fromList", fromList)
  validator:addSchemaType("oneOf", oneOf)
  validator:addSchemaType("betweenNumbers", betweenNumbers)
  validator:addSchemaType("array", checkArray)
  validator:addSchemaType("dict", checkDictionary)

  validator:addPartialSchema("color", { schemaType = "table", options = {
      { required = true, schemaType = "betweenNumbers", min = 0, max = 255 },
      { required = true, schemaType = "betweenNumbers", min = 0, max = 255 },
      { required = true, schemaType = "betweenNumbers", min = 0, max = 255 },
      { required = true, schemaType = "betweenNumbers", min = 0, max = 255 },
    }
  })

  return validator
end
