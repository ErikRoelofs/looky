function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  font = love.graphics.newFont()
  
  lc = require "layoutcreator"
  lc:register("linear", require "layout/linear" )
  lc:register("text", require "layout/text" )
  lc:register("image", require "layout/image" )  
  lc:register("caption", require "layout/caption" )
  lc:register("list", require "layout/list" )
  lc:register("root", require "layout/root" )
  
  mainview()
  dialog()
  
end

function mainview()
    root = lc:build("root", {})
  
  layout = lc:build("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, marginRight = 20, marginLeft = 20, direction = "v"})
  root:addChild(layout)
  
  caption = lc:build("caption", {width="wrap", height = "wrap", text = "this is a caption", file="test.png"})
  root:addChild(caption)
  
  list = lc:build("list", {width="wrap", height="fill", texts = { "derp", "merp", "lots of merp" }, textOptions = { paddingTop = 15, backgroundColor = {255,255,255,255}}})
  root:addChild(list)
  
  layout3 = lc:build("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, marginRight = 20, marginLeft = 20, direction = "v"})
  root:addChild(layout3)
  
  
  imageLayout = lc:build("image", {width = "wrap", height = "wrap", backgroundColor = {0, 0, 255, 200}, file = "test.png", marginLeft = 25, marginTop = 30, paddingLeft = 25, paddingTop = 25, paddingRight = 10, paddingBottom = 5 })
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)


  layout4 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {255, 255, 0, 200}, paddingLeft = 50, paddingBottom = 200, paddingTop = 25})
  root:addChild(layout4)

  layout:addChild( lc:build("text", {width = "fill", height = 100, text = "list 1", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
  layout:addChild( lc:build("text", {width = "wrap", height = 100, text = "list 2", textColor = {255,0,0,255}, backgroundColor = {255,255,255,255}, paddingLeft = 5, paddingTop = 5, layoutGravity = "end"}) )
  
  layout:addChild( lc:build("text", {width = "fill", height = 100, text = "list 3", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  layout:addChild( lc:build("text", {width = "fill", height = 100, text = "list 4", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
  subContainer = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {200,250,20,150}, direction = "h"})
  layout:addChild( subContainer )
  
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
  root:layoutingPass()

end

function dialog()
  dialogview = lc:build("root", { backgroundColor = { 100, 100, 100, 100 } } )
  dialogview:addChild( lc:build( "text", { text = "This is a dialog overlay", width = 400, height = 400, backgroundColor = { 255, 255, 255, 255 }, textColor = { 0,0,0,255 }, layoutGravity = "center" } ) )
  
  dialogview:layoutingPass()
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
      dialogview = nil
    end
end

function love.draw()
  root:render()
  if dialogview then
    dialogview:render()
  end
end

