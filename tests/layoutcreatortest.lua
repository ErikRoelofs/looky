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
    assert(lc:getFont("test") == res, "Should not be able to get unknown font")
    
    
  end,
  it_should_allow_building_layouts = function(lc) end,
  it_should_disallow_building_unknown_layouts = function(lc) end,
  it_should_extend_schemas = function(lc) end,
  it_should_not_extend_unknown_schemas = function(lc) end,
  it_should_merge_options = function(lc) end,
  
  
  
}

for _, test in pairs(tests) do
  test(lc())
end