function mainview(lc)
  local root = lc:build("root", {})
  
  local layout = lc:build("linear", {width = 150, height = "fill",padding = lc.padding(15), backgroundColor = {100,200,50,100}, direction = "v", childSpacing = 40})
  root:addChild(layout)
  layout:addChild( lc:build("text", {width = "fill", height = 100, data = {value="list 1"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  layout:addChild( lc:build("text", {width = "wrap", height = 100, data = {value = "list 2"}, textColor = {255,0,0,255}, backgroundColor = {255,255,255,255}, padding = lc.padding(5,5,0,0), layoutGravity = "end"}) )
  
  layout:addChild( lc:build("text", {width = "fill", height = 100, data = {value="list 1"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  layout:addChild( lc:build("text", {width = "fill", height = 100, data = {value="list 1"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  layout:addChild( lc:build("text", {width = "fill", height = 100, data = {value="list 1"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  --[[
  local layout = lc:build("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, direction = "v"})
  root:addChild(layout)
  
  local caption = lc:build("caption", {width="wrap", height = "wrap", textdata = {value= "this is a caption"}, file="test.png"})
  root:addChild(caption)
  
  local list = lc:build("list", {width="wrap", height="fill", texts = { {value ="derp"}, {value="merp"}, {value="lots of merp"} }, textOptions = { padding = lc.padding(0,15,0,0), backgroundColor = {255,255,255,255}}})
  root:addChild(list)
  
  local layout3 = lc:build("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, direction = "v"})
  root:addChild(layout3)
  
  
  local imageLayout = lc:build("image", {width = "wrap", height = "wrap", backgroundColor = {0, 0, 255, 200}, file = "test.png", padding = lc.padding(25,25,10,5)})
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)


  local layout4 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {255, 255, 0, 200}, padding = lc.padding(50, 200, 0, 25) })
  root:addChild(layout4)

  layout:addChild( lc:build("text", {width = "fill", height = 100, data = {value="list 1"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  layout:addChild( lc:build("text", {width = "wrap", height = 100, data = {value = "list 2"}, textColor = {255,0,0,255}, backgroundColor = {255,255,255,255}, padding = lc.padding(5,5,0,0), layoutGravity = "end"}) )
  
  layout:addChild( lc:build("text", {width = "fill", height = 100, data = {value= "list 3"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  layout:addChild( lc:build("text", {width = "fill", height = 100, data = {value= "list 4"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  local subContainer = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {200,250,20,150}, direction = "h"})
  layout:addChild( subContainer )
  
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, data = {value = "check"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, data = {value= "check"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, data = {value="check"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, data = {value="check"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  --]]
  root:layoutingPass()

  return root
end

function dialog(lc)
  local dialogview = lc:build("root", { direction = "v", backgroundColor = { 100, 100, 100, 100 } } )
  
  dialogview:addChild( lc:build( "text", { data = {value= "Close"}, width = 400, height = "wrap", backgroundColor = { 0, 0, 255, 255 }, textColor = { 255,255,255,255 }, layoutGravity = "center", gravity = {"center","center"}, padding = lc.padding(0,5,0,5)} ) )
  
  dialogview:addChild( lc:build( "text", { data = {value= "This is a dialog overlay"}, width = 400, height = 400, backgroundColor = { 255, 255, 255, 255 }, textColor = { 0,0,0,255 }, layoutGravity = "center", gravity = {"center", "center"} } ) )
  
  dialogview:layoutingPass()
  
  return dialogview
end

return function(lc)
  return {
    dialogview = dialog(lc),
    root = mainview(lc),
    update = function(self, dt) 
      if love.keyboard.isDown("escape") then
        self.dialogview = nil
      end
      self.root:update(dt)
    end,
    draw = function(self)
      self.root:render()
      if self.dialogview then
        self.dialogview:render()
      end
    end
  }
end