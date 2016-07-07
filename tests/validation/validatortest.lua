val = require "validation/validator"

local tests = {    
    it_should_accept_schemas = function(val)
      local test = function() end
      val:addSchemaType("test", test)
    end,
    it_should_accept_partial_schemas = function(val)
      local test = {}
      val:addPartialSchema("test", test)
    end,
    it_should_not_accept_duplicate_schemas = function(val)
      local test = {}
      val:addPartialSchema("test", test)
      v, e = pcall(function() val:addPartialSchema("test", test) end)
      assert(v == false, "Should not accept a duplicate partial schema.")
    end,
    it_should_check_for_unknown_properties = function(val)
      local toCheck = {
          unknown = "hi",
          known = "hi"
      }
      local schema = {
          known = { required = true, schemaType = "string" }
      }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Should not be able to validate a schema with unknown values")
    end,
    it_should_check_for_missing_requirements = function(val)
      local toCheck = {}
      local schema = { needed = { required = true, schemaType = "string" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Should not be able to validate a schema with missing required property")      
    end,
    it_should_not_accept_unknown_schemas = function(val)
      local toCheck = {}
      local schema = { needed = { required = true, schemaType = "something_unfamiliar" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Should not be able to validate a schema with an unknown schemaType rule")            
    end,    
    it_should_validate_numbers = function(val)
      local toCheck = {number = "test"}
      local schema = { number = { required = true, schemaType = "number" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Strings should not pass number validation")            
      
      local toCheck = {number = function() end}
      local schema = { number = { required = true, schemaType = "number" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Functions should not pass number validation")            
      
      local toCheck = {number = {12}}
      local schema = { number = { required = true, schemaType = "number" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Tables should not pass number validation")            
      
      local toCheck = {number = false}
      local schema = { number = { required = true, schemaType = "number" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Booleans should not pass number validation")            
      
      local toCheck = {number = 0}
      local schema = { number = { required = true, schemaType = "number" } }
      val:validate("test", schema, toCheck)
      
      local toCheck = {number = 1}
      local schema = { number = { required = true, schemaType = "number" } }
      val:validate("test", schema, toCheck)
      
      local toCheck = {number = 0.5}
      local schema = { number = { required = true, schemaType = "number" } }
      val:validate("test", schema, toCheck)

      local toCheck = {number = 500e10}
      local schema = { number = { required = true, schemaType = "number" } }
      val:validate("test", schema, toCheck)


    end,
    it_should_validate_strings  = function(val)
      local toCheck = {string = 10}
      local schema = { string = { required = true, schemaType = "string" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Numbers should not pass string validation")            
      
      local toCheck = {string = function() end}
      local schema = { string = { required = true, schemaType = "string" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Functions should not pass string validation")            
      
      local toCheck = {string = {12}}
      local schema = { string = { required = true, schemaType = "string" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Tables should not pass string validation")            
      
      local toCheck = {string = false}
      local schema = { string = { required = true, schemaType = "string" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Booleans should not pass string validation")            
      
      local toCheck = {string = ""}
      local schema = { string = { required = true, schemaType = "string" } }
      val:validate("test", schema, toCheck)
      
      local toCheck = {string = "hi"}
      local schema = { string = { required = true, schemaType = "string" } }
      val:validate("test", schema, toCheck)
            
    end,
    it_should_validate_functions = function(val)
      local toCheck = {tFunction = 10}
      local schema = { tFunction = { required = true, schemaType = "function" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Numbers should not pass Function validation")            
      
      local toCheck = {tFunction = false}
      local schema = { tFunction = { required = true, schemaType = "function" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Booleans should not pass function validation")            
      
      local toCheck = {tFunction = {12}}
      local schema = { tFunction = { required = true, schemaType = "function" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Tables should not pass function validation")            
      
      local toCheck = {tFunction = "string"}
      local schema = { tFunction = { required = true, schemaType = "function" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Strings should not pass function validation")            
      
      local toCheck = {tFunction = function() end}
      local schema = { tFunction = { required = true, schemaType = "function" } }
      val:validate("test", schema, toCheck)      
      
    end,
    it_should_validate_booleans = function(val)
      local toCheck = {boolean = 10}
      local schema = { boolean = { required = true, schemaType = "boolean" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Numbers should not pass boolean validation")            
      
      local toCheck = {boolean = function() end}
      local schema = { boolean = { required = true, schemaType = "boolean" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Functions should not pass boolean validation")            
      
      local toCheck = {boolean = {12}}
      local schema = { boolean = { required = true, schemaType = "boolean" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Tables should not pass boolean validation")            
      
      local toCheck = {boolean = "string"}
      local schema = { boolean = { required = true, schemaType = "boolean" } }
      v, e = pcall(function()  val:validate("test", schema, toCheck) end)
      assert(v == false, "Strings should not pass boolean validation")            
      
      local toCheck = {boolean = false}
      local schema = { boolean = { required = true, schemaType = "boolean" } }
      val:validate("test", schema, toCheck)
      
      local toCheck = {boolean = true}
      local schema = { boolean = { required = true, schemaType = "boolean" } }
      val:validate("test", schema, toCheck)
      
    end,
    it_should_validate_from_a_list = function(val)      
      local schema = { item = { required = true, schemaType = "fromList", list = {
        "cookie",
        "different_cookie",
        10
      } } }
      val:validate("test", schema, { item = 10 })
      val:validate("test", schema, { item = "cookie" })
      val:validate("test", schema, { item = "different_cookie" })
      v, e = pcall(function() val:validate("test", schema, { item = false }) end)
      assert(v == false, "This is not acceptable in this list")
      v, e = pcall(function() val:validate("test", schema, { item = "other string" }) end)
      assert(v == false, "This is not acceptable in this list")
      v, e = pcall(function() val:validate("test", schema, { item = 25 }) end)
      assert(v == false, "This is not acceptable in this list")
      
    end,
    it_should_validate_an_array = function(val)
      local schema = { item = { required = true, schemaType = "array", item = {
        schemaType = "string"
      } } }
      
      val:validate("test", schema, {item = {}})      
      val:validate("test", schema, {item = {"test"}})
      val:validate("test", schema, {item = {"test", "test"}})
      val:validate("test", schema, {item = {"test", "other_test"}})
      
      
      v, e = pcall(function() val:validate("test", schema, {item = "test"}) end)
      assert(v == false, "Should be a table, even if the single item passed would work inside the array")
      
      v, e = pcall(function() val:validate("test", schema, {item = {"test", 12, "other_test"}}) end)
      assert(v == false, "Should complain about the one item that does not pass validation")
      
    end,
    it_should_validate_tables = function(val)
      local schema = { t = { required = true, schemaType = "table", options = { 
            string = { required = true, schemaType = "string" },
            number = { required = true, schemaType = "number" },
            optional = { required = false, schemaType = "number" }
      }}}
      val:validate("test", schema, {t = {string = "hi", number = 10, optional = 15}})
      val:validate("test", schema, {t = {string = "hi", number = 10}})
      
      v, e = pcall(function() val:validate("test", schema, {t = "test"}) end)
      assert(v == false, "It should reject non-tables")
        
      v, e = pcall(function() val:validate("test", schema, {string = "hi"}) end)
      assert(v == false, "All required values should be present")
        
      v, e = pcall(function() val:validate("test", schema, {string = "hi", number = 10, unknown = true }) end)
      assert(v == false, "It should not accept unknown properties on tables")
  
    end,
    it_should_validate_oneOf = function(val)
      local schema = { item = { required = true, schemaType = "oneOf", possibilities = {{schemaType = "string"}, {schemaType = "number"}}}}
      
      val:validate("test", schema, {item = 10})
      val:validate("test", schema, {item = "test"})
      
      v,e = pcall(function() val:validate("test", schema, {item=true})end)
      assert(v == false, "It should not accept anything outside of the allowed possibilities")
      
    end,
    it_should_validate_between_numbers = function(val)
      local schema = { item = { required = true, schemaType = "betweenNumbers", min = 5, max = 10}}
      
      val:validate("test", schema, {item = 5})
      val:validate("test", schema, {item = 6})
      val:validate("test", schema, {item = 7})
      val:validate("test", schema, {item = 8})
      val:validate("test", schema, {item = 9})
      val:validate("test", schema, {item = 10})
      
      v,e = pcall(function() val:validate("test", schema, {item = "string"})end)
      assert(v == false, "It should not accept non-numbers")
      
      v,e = pcall(function() val:validate("test", schema, {item = 4})end)
      assert(v == false, "It should not accept numbers below the min")
      
      v,e = pcall(function() val:validate("test", schema, {item = 11})end)
      assert(v == false, "It should not accept numbers above the max")

    end,
    it_should_validate_colors = function(val)
      local schema = { item = { required = true, schemaType = "color"}}
      
      val:validate("test", schema, {item = {255,255,255,255}})
      val:validate("test", schema, {item = {0,0,0,0}})
      val:validate("test", schema, {item = {5,10,20,100}})
      
      v,e = pcall(function() val:validate("test", schema, {item = 255})end)
      assert(v == false, "It should not accept single numbers")
      
      v,e = pcall(function() val:validate("test", schema, {100, 200, 255})end)
      assert(v == false, "It should not accept 3 numbers")
      
      v,e = pcall(function() val:validate("test", schema, {100, 200, 255, 100, 200})end)
      assert(v == false, "It should not accept 5 numbers")
      
      v,e = pcall(function() val:validate("test", schema, {100, 200, 255, -100})end)
      assert(v == false, "It should not accept negative numbers")
      
      v,e = pcall(function() val:validate("test", schema, {100, 200, 255, 300})end)
      assert(v == false, "It should not accept too large numbers")
      
      
    end,
    it_should_validate_images = function(val)
      -- actually it doesn't, it just checks for userdata. need to fix.
    end,
    it_should_validate_complex_schemas = function(val)
      local schema = {
        string = { required = true, schemaType = "string" },
        number = { required = true, schemaType = "number" },
        table = { required = true, schemaType = "table", options = { t_value = { required = true, schemaType = "boolean"            }}}
      }
      
      val:validate("test", schema, {string = "hi", number = 15, table = { t_value = true }})
      
    end,
    it_should_reject_entries_without_schematype = function(val)
      local schema = { item = {} }    
      v, e = pcall(function() val:validate("test", schema, {item = "the_test_case"}) end)
      assert(v == false, "No schematype should be rejected")
      
    end,
}

for _, test in pairs(tests) do
  test(val())
end