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
  
  display = require "samples/third"
  
  
end

function love.keypressed(key)
  if key == "1" then
    display = require "samples/first"
  elseif key == "2" then
    display = require "samples/second"
  elseif key == "3" then
    display = require "samples/third"
  end
end

function love.update(dt)
  display:update(dt)
end

function love.draw()
  display:draw()
end
