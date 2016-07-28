if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

--[[
  layouts to include:
    - numberAsImages
    - numberAsCaption
    - numberAsBar
    - aquarium
    - scroll-something
    - canvas
]]
function love.load()  
  
  test()
  
  local lcF = require "layoutcreator"
  local lc = lcF()
  lc:registerLayout("linear", require "layout/linear"(lc) )
  lc:registerLayout("text", require "layout/text"(lc) )
  lc:registerLayout("image", require "layout/image"(lc) )  
  lc:registerLayout("caption", require "layout/caption"(lc) )
  lc:registerLayout("list", require "layout/list"(lc) )
  lc:registerLayout("root", require "layout/root"(lc) )
  lc:registerLayout("stack", require "layout/stack"(lc) )
  lc:registerLayout("freeform", require "layout/freeform"(lc) )
  lc:registerLayout("stackroot", require "layout/stackroot"(lc) )
  lc:registerLayout("dragbox", require "layout/dragbox"(lc) )
  lc:registerLayout("4pane", require "layout/4pane"(lc) )
  lc:registerLayout("numberAsImage", require "layout/numberasimage"(lc) )
  lc:registerLayout("border", require "layout/border"(lc))
  lc:registerLayout("empty", require "layout/empty"(lc))
  lc:registerLayout("aquarium", require "layout/aquarium"(lc))
  lc:registerLayout("grid", require "layout/grid"(lc))
  lc:registerFont("default", love.graphics.newFont(20))
  
  display = require "samples/old/grid"(lc)
  root = display.root

  require "signals"
  
end

function love.draw()
  display:draw()  
end

function test() 
  require("tests/validation/validatortest")
  require("tests/layoutcreatortest")
end

expandSchema = function(schema, validator)
  for k, item in pairs(schema) do
    if type(item) == "table" and type(validator.schemaTypes[item.schemaType]) == "table" then
      for key, value in pairs(validator.schemaTypes[item.schemaType]) do
        schema[k][key] = value
      end
    end
  end  
end
