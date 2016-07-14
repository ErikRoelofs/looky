lc = require "layoutcreator"

tests = {
  it_should_make_sure_layouts_have_a_name = function(lc)
    v, e = pcall( function() lc:registerLayout(nil, function() end) end )
    assert(v == false, "Registering a nameless layout did not throw an error")
    --assert(e:contains("string") and e:contains("nil"))
  end,
  it_should_make_sure_layouts_have_the_correct_format = function(lc)
    v, e = pcall( function() lc:registerLayout("test", "test") end )
    assert(v == false, "Registering a non-table layout did not throw an error")
    --assert(e:contains("table") and e:contains("string"))
  
    v, e = pcall( function() lc:registerLayout("test", {}) end )
    assert(v == false, "Registering a table layout without the required fields did not throw an error")
    v, e = pcall( function() lc:registerLayout("test", {build = {}, schema={}}) end )
    assert(v == false, "Registering a table layout with a bad build did not throw an error")
    v, e = pcall( function() lc:registerLayout("test", {build = function() end, schema=function() end}) end )
    assert(v == false, "Registering a table layout with a bad schema did not throw an error")
  
  end,
  it_should_allow_registering_layouts = function(lc)
    lc:registerLayout("test", {build = function() end, schema={}})
  end,
  it_should_disallow_registering_layouts_twice = function(lc) 
    lc:registerLayout("test", {build = function() end, schema={}})
    v, e = pcall( function() lc:registerLayout("test", {build = function() end, schema={}}) end )
    assert(v == false, "Registering the same layout twice did not throw an error")
  end,
  it_should_check_fonts_have_a_name = function(lc)
    v, e = pcall( function() lc:registerFont(nil) end)
    assert(v == false, "Registering a font without a name did not throw an error")    
  end,
  it_should_check_fonts_are_resources = function(lc)
    v, e = pcall( function() lc:registerFont("test") end)
    assert(v == false, "Registering a font without a resource did not throw an error")        
  end,
  it_should_allow_registering_fonts = function(lc) 
    lc:registerFont("test", love.graphics.newFont() )
  end,
  it_should_disallow_registering_the_same_font_twice = function(lc) 
    lc:registerFont("test", love.graphics.newFont() )
    v, e = pcall( function() lc:registerFont("test", love.graphics.newFont() ) end )
    assert(v == false, "Registering the same font twice did not throw an error")
  end,
  it_should_allow_getting_fonts = function(lc) 
    local res = love.graphics.newFont()
    lc:registerFont("test", res)
    assert(lc:getFont("test") == res, "Could not retrieve the created font")
  end,
  it_should_disallow_getting_unknown_fonts = function(lc)     
    v, e = pcall( function() lc:getFont("test") end)
    assert(v == false, "Should not be able to get unknown font")    
  end,
  it_should_allow_building_layouts = function(lc) 
    lc:registerLayout("test", { build = function() return "someData" end, schema = {} } )
    local layout = lc:build("test", {})
    assert(layout == "someData")
  end,
  it_should_disallow_building_unknown_layouts = function(lc) 
    v, e = pcall( function() lc:build("test", {}) end)
    assert(v == false, "Should not be able to build unknown layout")        
  end,
  it_should_validate_before_building = function(lc)
    lc:registerLayout("test", { build = function(options) return options.name end, schema = {name = { required = true, schemaType = "string" } } } )
    v, e = pcall( function() local layout = lc:build("test", {}) end )
    assert(v == false, "Should throw an error when building with a missing validation option")    
  
    local layout = lc:build("test", {name = "cookies"})
    assert( layout == "cookies", "Should have returned the passed option" )
  end,
  it_should_extend_schemas = function(lc) 
    lc:registerLayout("test", { build = function(options) return options.name end, schema = {name = { required = true, schemaType = "string" } } } )
    local schema = lc:extendSchema("test", {cookies = { required = true, schemaType = "number"} } )
        
    assert(schema.name.required == true, "Schema should still have a required name option.")
    assert(schema.name.schemaType == "string", "Schema should have a name option that is a string.")
    assert(schema.cookies.required == true, "Schema should have a required cookies option.")
    assert(schema.cookies.schemaType == "number", "Schema should have cookies option that is a number.")
    
  end,
  it_should_not_extend_unknown_schemas = function(lc) 
    v, e = pcall( function() lc:extendSchema("cookies", {} ) end )
    assert(v == false, "Should not be able to extend an unknown schema.")
  end,
  it_should_merge_options = function(lc) 
    local base = {alreadyThere = false, override = false}
    lc.mergeOptions(base,{added = true, override = true})
    
    assert(base.alreadyThere == false, "This value should still be there after merge")
    assert(base.added == true, "This value should have been added after merge")
    assert(base.override == true, "This value should have been overridden by merge")
    
  end,
  it_should_allow_adding_validator_functions = function(lc)
    wasCalledWith = false
    local val = function(kind, field, schema, option, validator)
      wasCalledWith = option
    end
    lc:registerValidator("test", val)
    lc:registerLayout("test", { build = function(options) return options.name end, schema = {name = { required = true, schemaType = "test" } } } )
    
    lc:build("test",{ name = "passedValue" })
    assert(wasCalledWith == "passedValue", "Should have called the validator")
  end,
  it_should_allow_adding_validator_partials = function(lc)
    local configTable = {
      schemaType = "oneOf",
      possibilities = {
        {schemaType = "string"},
        {schemaType = "number"}
      },
    }
    lc:registerValidator("testExpansive", configTable)
    lc:registerLayout("test", { build = function(options) return options.name end, schema = {name = { required = true, schemaType = "testExpansive" } } } )
    
    assert( lc:build("test",{ name = "aString" }) == "aString", "Should be allowed to build with a string and have it as return value")
    assert(lc:build("test",{ name = 123 }) == 123, "Should be allowed to build with a number and have it as return value")
    v, e = pcall(function() lc:build("test", { name = function() end} )end)
    assert(v == false, "Should not have been allowed to call it with a function.")
  end,
  if_should_allow_recursive_validator_partials = function(lc)
    local configTable = {
      schemaType = "oneOf",
      possibilities = {
        {schemaType = "string"},
        {schemaType = "number"}
      },
    }
    local configTable2 = {
      schemaType = "oneOf",
      possibilities = {
        {schemaType = "recursive1"},
        {schemaType = "function"}
      },
    }
    lc:registerValidator("recursive1", configTable)
    lc:registerValidator("recursive2", configTable2)
    
    lc:registerLayout("test", { build = function(options) return options.name end, schema = {name = { required = true, schemaType = "recursive2" } } } )
    
    assert( lc:build("test",{ name = "aString" }) == "aString", "Should be allowed to build with a string and have it as return value")
    assert(lc:build("test",{ name = 123 }) == 123, "Should be allowed to build with a number and have it as return value")
    local f = function() end
    assert(lc:build("test",{ name = f }) == f, "Should be allowed to build with a function and have it as return value")
    v, e = pcall(function() lc:build("test", { name = {}} )end)
    assert(v == false, "Should not have been allowed to call it with a table.")
    
  end,
  it_should_allow_making_styled_views = function(lc)
    lc:registerLayout("test", { build = function(options) return { name = options.name, name2 = options.name2 } end, schema = {name = { required = true, schemaType = "string" }, name2 = { required = true, schemaType = "string" } } } )
    lc:registerStyledLayout("s-test", "test", { name2 = "fixed" })
    
    local view = lc:build("s-test", { name = "set", name2 = "overruled" })
    
    assert(view.name == "set", "The options passed to the view should be there")
    assert(view.name2 == "overruled", "The options passed to the view should be there")
    
    local view = lc:build("s-test", { name = "set" })
    
    assert(view.name == "set", "The options passed to the view should be there")
    assert(view.name2 == "fixed", "The options not passed to the view should go to default (even if required)")
    
    
    
  end,
  
}

for _, test in pairs(tests) do
  test(lc())
end