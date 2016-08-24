function mainview(looky)
  
  looky:registerStyledLayout("my_text", "text", { width = "wrap", height = "fill", data = {value = "list 2"}, textColor = {255,0,0,255}, background = {255,255,255,255}, padding = looky.padding(5,5,0,0) })
  
  
  
  local root = looky:build("root", {})
  
  local layout = looky:build("linear", {width = 150, height = 500,padding = looky.padding(15), background = {100,200,50,100}, direction = "v", childSpacing = 40})
  root:addChild(layout)
  layout:addChild( looky:build("my_text", {height = 100, data = {value="list 1"}, textColor = {255,255,0,255}, padding = looky.padding(5,5,0,0)}) )
  
  layout:addChild( looky:build("my_text", {}) )
  
  
  local layout2 = looky:build("linear", {width = 150, height = 150,padding = looky.padding(15), background = {100,200,50,100}, direction = "v", childSpacing = 40})
  root:addChild(layout2)
  layout2:addChild( looky:build("text", {width = "fill", height = 50, data = {value="list 1"}, textColor = {255,0,0,255}, padding = looky.padding(5,5,0,0)}) )
  
  layout2:addChild( looky:build("text", {width = "wrap", height = "fill", data = {value = "list 2"}, textColor = {255,0,0,255}, background = {255,255,255,255}, padding = looky.padding(5,5,0,0)}) )
  
  layout2:addChild( looky:build("text", {width = "fill", height = "fill", data = {value="list 1"}, textColor = {255,0,0,255}, padding = looky.padding(5,5,0,0)}) )
  
  layout2:addChild( looky:build("text", {width = "fill", height = "fill", data = {value="list 1"}, textColor = {255,0,0,255}, padding = looky.padding(5,5,0,0)}) )
  
  layout2:addChild( looky:build("text", {width = "fill", height = "fill", data = {value="list 1"}, textColor = {255,0,0,255}, padding = looky.padding(5,5,0,0)}) )
  
  
  root:layoutingPass()

  return root
end

function dialog(looky)
  local dialogview = looky:build("root", { direction = "v", background = { 100, 100, 100, 100 } } )
  
  dialogview:addChild( looky:build( "text", { data = {value= "Close"}, width = 400, height = "wrap", background = { 0, 0, 255, 255 }, textColor = { 255,255,255,255 }, gravity = {"center","center"}, padding = looky.padding(0,5,0,5)} ) )
  
  dialogview:addChild( looky:build( "text", { data = {value= "This is a dialog overlay"}, width = 400, height = 400, background = { 255, 255, 255, 255 }, textColor = { 0,0,0,255 }, gravity = {"center", "center"} } ) )
  
  dialogview:layoutingPass()
  
  return dialogview
end

return function(looky)
  return {
    dialogview = dialog(looky),
    root = mainview(looky),
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