if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

function love.load()  
  
  test()
  
  local lookyF = require "layoutcreator"
  local looky = lookyF()
  looky:registerLayout("linear", require "layout/linear"(looky) )
  looky:registerLayout("text", require "layout/text"(looky) )
  looky:registerLayout("image", require "layout/image"(looky) )  
  looky:registerLayout("list", require "layout/list"(looky) )
  looky:registerLayout("root", require "layout/root"(looky) )
  looky:registerLayout("stack", require "layout/stack"(looky) )
  looky:registerLayout("freeform", require "layout/freeform"(looky) )
  looky:registerLayout("stackroot", require "layout/stackroot"(looky) )
  looky:registerLayout("dragbox", require "layout/dragbox"(looky) )
  looky:registerLayout("4pane", require "layout/4pane"(looky) )
  looky:registerLayout("numberAsImage", require "layout/numberasimage"(looky) )
  looky:registerLayout("filler", require "layout/filler"(looky))
  looky:registerLayout("empty", require "layout/empty"(looky))
  looky:registerLayout("aquarium", require "layout/aquarium"(looky))
  looky:registerLayout("grid", require "layout/grid"(looky))
  looky:registerLayout("numberAsBar", require "layout/numberasbar"(looky))
  looky:registerLayout("slotted", require "layout/slotted"(looky))
  
  
  looky:registerFont("default", love.graphics.newFont(20))
  
  looky:registerStyledLayout("filler.right", "filler", { right = "fill" })
  looky:registerStyledLayout("filler.left", "filler", { left = "fill" })
  looky:registerStyledLayout("filler.top", "filler", { top = "fill" })
  looky:registerStyledLayout("filler.bottom", "filler", { bottom = "fill" })
  looky:registerStyledLayout("filler.topright", "filler", { top = "fill", right = "fill" })
  looky:registerStyledLayout("filler.topleft", "filler", { top = "fill", left = "fill" })
  looky:registerStyledLayout("filler.bottomright", "filler", { bottom = "fill", right = "fill" })
  looky:registerStyledLayout("filler.bottomleft", "filler", { bottom = "fill", left = "fill" })
  looky:registerStyledLayout("filler.center", "filler", { top = "fill", bottom = "fill", left = "fill", right = "fill" })
  
  require "samples/tutorial"(looky)
end

function test() 
  require("tests/validation/validatortest")
  require("tests/layoutcreatortest")
end