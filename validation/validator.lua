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

local checkTable = function(kind, field, schema, option, validator)
  typecheck("table", kind, field, option)
  validator:validate( kind .. "." .. field, schema.options, option )
end


local validator = {
    schemaTypes = {},
    addSchemaType = function(self, typename, fn)
      assert(not self.schemaTypes[typename], "Option type" .. typename .. " already exists; cannot register twice")
      self.schemaTypes[typename] = fn
    end,
    validate = function(self, kind, schema, options)
      checkUnfamiliar(kind, schema, options, self)
      checkRequired(kind, schema, options, self)
      
      for field, schemaDescription in pairs(schema) do
        if schemaDescription and schemaDescription.schematype then
          assert( self.schemaTypes[ schemaDescription.schematype ], "Unknown schema type " .. schemaDescription.schematype .. " from viewtype " .. kind .. ", please register it with the validator." )
          for typename, fn in pairs(self.schemaTypes) do
            if options[field] ~= nil and schemaDescription and schemaDescription.schematype == typename then
              fn(kind, field, schemaDescription, options[field], self)
            end
          end
        end
      end
    end
}

validator:addSchemaType("boolean", checkBoolean)
validator:addSchemaType("number", checkNumber)
validator:addSchemaType("string", checkString)
validator:addSchemaType("table", checkTable)

return validator