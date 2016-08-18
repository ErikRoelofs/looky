if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

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
  lc:registerLayout("filler", require "layout/filler"(lc))
  lc:registerLayout("empty", require "layout/empty"(lc))
  lc:registerLayout("aquarium", require "layout/aquarium"(lc))
  lc:registerLayout("grid", require "layout/grid"(lc))
  lc:registerLayout("numberAsBar", require "layout/numberasbar"(lc))
  lc:registerLayout("slotted", require "layout/slotted"(lc))
  
  
  lc:registerFont("default", love.graphics.newFont(20))
  
  lc:registerStyledLayout("filler.right", "filler", { right = "fill" })
  lc:registerStyledLayout("filler.left", "filler", { left = "fill" })
  lc:registerStyledLayout("filler.top", "filler", { top = "fill" })
  lc:registerStyledLayout("filler.bottom", "filler", { bottom = "fill" })
  lc:registerStyledLayout("filler.topright", "filler", { top = "fill", right = "fill" })
  lc:registerStyledLayout("filler.topleft", "filler", { top = "fill", left = "fill" })
  lc:registerStyledLayout("filler.bottomright", "filler", { bottom = "fill", right = "fill" })
  lc:registerStyledLayout("filler.bottomleft", "filler", { bottom = "fill", left = "fill" })
  lc:registerStyledLayout("filler.center", "filler", { top = "fill", bottom = "fill", left = "fill", right = "fill" })
  
  require "samples/shooter"(lc)
end

function test() 
  require("tests/validation/validatortest")
  require("tests/layoutcreatortest")
end