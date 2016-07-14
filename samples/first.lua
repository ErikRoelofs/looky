function mainview(lc)
  
  lc:registerStyledLayout("my_text", "text", { width = "wrap", height = "fill", data = {value = "list 2"}, textColor = {255,0,0,255}, backgroundColor = {255,255,255,255}, padding = lc.padding(5,5,0,0), layoutGravity = "end" })
  
  
  
  local root = lc:build("root", {})
  
  local layout = lc:build("linear", {width = 150, height = 500,padding = lc.padding(15), backgroundColor = {100,200,50,100}, direction = "v", childSpacing = 40})
  root:addChild(layout)
  layout:addChild( lc:build("my_text", {height = 100, data = {value="list 1"}, textColor = {255,255,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  layout:addChild( lc:build("my_text", {}) )
  
  
  local layout2 = lc:build("linear", {width = 150, height = 150,padding = lc.padding(15), backgroundColor = {100,200,50,100}, direction = "v", childSpacing = 40})
  root:addChild(layout2)
  layout2:addChild( lc:build("text", {width = "fill", height = 50, data = {value="list 1"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  layout2:addChild( lc:build("text", {width = "wrap", height = "fill", data = {value = "list 2"}, textColor = {255,0,0,255}, backgroundColor = {255,255,255,255}, padding = lc.padding(5,5,0,0), layoutGravity = "end"}) )
  
  layout2:addChild( lc:build("text", {width = "fill", height = "fill", data = {value="list 1"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  layout2:addChild( lc:build("text", {width = "fill", height = "fill", data = {value="list 1"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  layout2:addChild( lc:build("text", {width = "fill", height = "fill", data = {value="list 1"}, textColor = {255,0,0,255}, padding = lc.padding(5,5,0,0)}) )
  
  
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