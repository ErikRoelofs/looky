if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

--[[
  layouts to include:
    - numberAsImages
    - numberAsCaption
    - numberAsBar
]]
function love.load()  
  

  test()
  
  local lcF = require "layoutcreator"
  local lc = lcF()
  bargl = lc
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
  lc:registerLayout("numberAsImage", require "layout/numberasimage"(lc) )
  
  lc:registerFont("default", love.graphics.newFont(20))
  
  display = require "samples/second"(lc)
  
end

function love.keypressed(key)
  if key == "1" then
    display = require "samples/first"(bargl)
  elseif key == "2" then
    display = require "samples/second"(bargl)
  elseif key == "3" then
    display = require "samples/third"(bargl)
  elseif key == "4" then
    display = require "samples/fourth"(bargl)
  elseif key == "5" then
    display = require "samples/fifth"(bargl)
  elseif key == "6" then
    display = require "samples/sixth"(bargl)
  elseif key == "7" then
    display = require "samples/seventh"(bargl)  
  elseif key == "8" then
    display = require "samples/eight"(bargl)
  elseif key == "9" then
    display = require "samples/ninth"(bargl)
  end
end

function love.update(dt)
  display:update(dt)
end

function love.draw()
  display:draw()  
end

function test() 
  --require("tests/layoutcreatortest")
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
