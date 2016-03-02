function love.load()  
  if arg[#arg] == "-debug" then debug = true else debug = false end
  if debug then require("mobdebug").start() end

  font = love.graphics.newFont()
  
  lc = require "layoutcreator"
  lc:register("linear", require "layout/linear" )
  lc:register("text", require "layout/text" )
  lc:register("image", require "layout/image" )  
  lc:register("caption", require "layout/caption" )
  lc:register("list", require "layout/list" )
  lc:register("root", require "layout/root" )
  lc:register("stack", require "layout/stack" )
  lc:register("freeform", require "layout/freeform" )
  
  display = require "samples/eight"
  
end

function love.keypressed(key)
  if key == "1" then
    display = require "samples/first"
  elseif key == "2" then
    display = require "samples/second"
  elseif key == "3" then
    display = require "samples/third"
  elseif key == "4" then
    display = require "samples/fourth"
  elseif key == "5" then
    display = require "samples/fifth"
  elseif key == "6" then
    display = require "samples/sixth"  
  elseif key == "7" then
    display = require "samples/seventh"  
  end
end

function love.update(dt)
  display:update(dt)
end

function love.draw()
  display:draw()
end
