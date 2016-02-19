function mainview()
  local root = lc:build("root", {})
  
  local p1 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {255,0,0,100}, direction = "v"})
  root:addChild(p1)
  local p2 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {0,255,0,100}, direction = "v"})
  root:addChild(p2)
  local p3 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {0,255,0,100}, direction = "v"})
  root:addChild(p3)
  
  local c1 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {255,0,0,100}, direction = "h"})
  p1:addChild(c1)
  local c2 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {0,255,0,100}, direction = "h"})
  p1:addChild(c2)
  local c3 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {0,0,255,100}, direction = "h"})
  p1:addChild(c3)
  
  local c4 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {0,255,0,100}, direction = "h"})
  p2:addChild(c4)
  local c5 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {255,0,0,100}, direction = "h"})
  p2:addChild(c5)
  local c6 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {0,0,255,100}, direction = "h"})
  p2:addChild(c6)
  
  local c7 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {0,0,255, 100}, direction = "h"})
  p3:addChild(c7)
  local c8 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {0,255,0,100}, direction = "h"})
  p3:addChild(c8)
  local c9 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {255,0,0,100}, direction = "h"})
  p3:addChild(c9)

  addimage(c1, {"start", "start"})
  addimage(c2, {"start", "center"})
  addimage(c3, {"start", "end"})
  addimage(c4, {"center", "start"})
  addimage(c5, {"center", "center"})
  addimage(c6, {"center", "end"})
  addimage(c7, {"end", "start"})
  addimage(c8, {"end", "center"})
  addimage(c9, {"end", "end"})


  root:layoutingPass()

  return root
end

function addimage(container, gravity)
  local padding = lc.padding(6, 10, 14, 2)
  local margin = lc.margin(8,5,4,8)

  local width = 200
  local height = 100
  local image = "test.png"
  
  container:addChild( lc:build("image", {width = width, height=height, file=image, backgroundColor={0,0,0,255}, padding = padding, margin = margin, gravity=gravity } ))
  
end

return {
  root = mainview(),
  update = function(self, dt) 
    self.root:update(dt)
  end,
  draw = function(self)
    self.root:render()
  end
}