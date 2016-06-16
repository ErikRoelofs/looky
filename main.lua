--[[
  layouts to include:
    - numberAsImages
    - numberAsCaption
    - numberAsBar
]]
function love.load()  
  if arg[#arg] == "-debug" then debug = true else debug = false end
  if debug then require("mobdebug").start() end

  local lc = require "layoutcreator"
  bargl = lc
  lc:register("linear", require "layout/linear"(lc) )
  lc:register("text", require "layout/text"(lc) )
  lc:register("image", require "layout/image"(lc) )  
  lc:register("caption", require "layout/caption"(lc) )
  lc:register("list", require "layout/list"(lc) )
  lc:register("root", require "layout/root"(lc) )
  lc:register("stack", require "layout/stack"(lc) )
  lc:register("freeform", require "layout/freeform"(lc) )
  lc:register("stackroot", require "layout/stackroot"(lc) )
  lc:register("dragbox", require "layout/dragbox"(lc) )
  
  lc:registerFont("default", love.graphics.newFont(20))
  
  display = require "samples/ninth"(lc)
  
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