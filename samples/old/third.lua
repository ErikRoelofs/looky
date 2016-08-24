function mainview(looky)
  local root = looky:build("root", {})
  
  local p1 = looky:build("linear", {width = "fill", height = "fill", background = {255,0,0,100}, direction = "v"})
  root:addChild(p1)
  local p2 = looky:build("linear", {width = "fill", height = "fill", background = {0,255,0,100}, direction = "v"})
  root:addChild(p2)
  local p3 = looky:build("linear", {width = "fill", height = "fill", background = {0,255,0,100}, direction = "v"})
  root:addChild(p3)
  
  local c1 = looky:build("linear", {width = "fill", height = "fill", background = {255,0,0,100}, direction = "h"})
  p1:addChild(c1)
  local c2 = looky:build("linear", {width = "fill", height = "fill", background = {0,255,0,100}, direction = "h"})
  p1:addChild(c2)
  local c3 = looky:build("linear", {width = "fill", height = "fill", background = {0,0,255,100}, direction = "h"})
  p1:addChild(c3)
  
  local c4 = looky:build("linear", {width = "fill", height = "fill", background = {0,255,0,100}, direction = "h"})
  p2:addChild(c4)
  local c5 = looky:build("linear", {width = "fill", height = "fill", background = {255,0,0,100}, direction = "h"})
  p2:addChild(c5)
  local c6 = looky:build("linear", {width = "fill", height = "fill", background = {0,0,255,100}, direction = "h"})
  p2:addChild(c6)
  
  local c7 = looky:build("linear", {width = "fill", height = "fill", background = {0,0,255, 100}, direction = "h"})
  p3:addChild(c7)
  local c8 = looky:build("linear", {width = "fill", height = "fill", background = {0,255,0,100}, direction = "h"})
  p3:addChild(c8)
  local c9 = looky:build("linear", {width = "fill", height = "fill", background = {255,0,0,100}, direction = "h"})
  p3:addChild(c9)

  addimage(c1, {"start", "start"}, looky)
  addimage(c2, {"start", "center"}, looky)
  addimage(c3, {"start", "end"}, looky)
  addimage(c4, {"center", "start"}, looky)
  addimage(c5, {"center", "center"}, looky)
  addimage(c6, {"center", "end"}, looky)
  addimage(c7, {"end", "start"}, looky)
  addimage(c8, {"end", "center"}, looky)
  addimage(c9, {"end", "end"}, looky)


  root:layoutingPass()

  return root
end

function addimage(container, gravity, looky)
  local padding = looky.padding(6, 10, 14, 2)
  
  local width = 200
  local height = 100
  local image = "test.png"
  
  container:addChild( looky:build("image", {width = width, height=height, file=image, background={0,0,0,255}, padding = padding, gravity=gravity } ))
  
end

return function(looky)
  return {
    root = mainview(looky),
    update = function(self, dt) 
      self.root:update(dt)
    end,
    draw = function(self)
      self.root:render()
    end
  }
end