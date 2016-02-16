function mainview()
  local root = lc:build("root", {})
  
  local layout = lc:build("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, marginRight = 20, marginLeft = 20, direction = "v"})
  root:addChild(layout)
  
  local caption = lc:build("caption", {width="wrap", height = "wrap", text = "this is a caption", file="test.png"})
  root:addChild(caption)
  
  local list = lc:build("list", {width="wrap", height="fill", texts = { "derp", "merp", "lots of merp" }, textOptions = { paddingTop = 15, backgroundColor = {255,255,255,255}}})
  root:addChild(list)
  
  local layout3 = lc:build("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, marginRight = 20, marginLeft = 20, direction = "v"})
  root:addChild(layout3)
  
  
  local imageLayout = lc:build("image", {width = "wrap", height = "wrap", backgroundColor = {0, 0, 255, 200}, file = "test.png", marginLeft = 25, marginTop = 30, paddingLeft = 25, paddingTop = 25, paddingRight = 10, paddingBottom = 5 })
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)


  local layout4 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {255, 255, 0, 200}, paddingLeft = 50, paddingBottom = 200, paddingTop = 25})
  root:addChild(layout4)

  layout:addChild( lc:build("text", {width = "fill", height = 100, text = "list 1", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
  layout:addChild( lc:build("text", {width = "wrap", height = 100, text = "list 2", textColor = {255,0,0,255}, backgroundColor = {255,255,255,255}, paddingLeft = 5, paddingTop = 5, layoutGravity = "end"}) )
  
  layout:addChild( lc:build("text", {width = "fill", height = 100, text = "list 3", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  layout:addChild( lc:build("text", {width = "fill", height = 100, text = "list 4", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
  local subContainer = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {200,250,20,150}, direction = "h"})
  layout:addChild( subContainer )
  
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
  root:layoutingPass()

  return root
end

function dialog()
  local dialogview = lc:build("root", { direction = "v", backgroundColor = { 100, 100, 100, 100 } } )
  
  dialogview:addChild( lc:build( "text", { text = "Close", width = 400, height = "wrap", backgroundColor = { 0, 0, 255, 255 }, textColor = { 255,255,255,255 }, layoutGravity = "center", gravity = {"center","center"}, paddingTop = 5, paddingBottom = 5 } ) )
  
  dialogview:addChild( lc:build( "text", { text = "This is a dialog overlay", width = 400, height = 400, backgroundColor = { 255, 255, 255, 255 }, textColor = { 0,0,0,255 }, layoutGravity = "center", gravity = {"center", "center"} } ) )
  
  dialogview:layoutingPass()
  
  return dialogview
end

return {
  dialogview = dialog(),
  root = mainview(),
  update = function(self, dt) 
    if love.keyboard.isDown("escape") then
      self.dialogview = nil
    end
  end,
  draw = function(self)
    self.root:render()
    if self.dialogview then
      self.dialogview:render()
    end
  end
}