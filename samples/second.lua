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

  local t1 = c1:addChild( lc:build("text", {width = "100", height="100", text = "Some text", textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, marginTop = 20, marginLeft = 40, marginRight = 20, marginBottom = 40, paddingTop = 50, paddingLeft = 30, paddingRight = 70, paddingBottom = 10, gravity={"start", "start"} } ))
  local t2 = c2:addChild( lc:build("text", {width = "100", height="100", text = "Some text", textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, marginTop = 20, marginLeft = 40, marginRight = 20, marginBottom = 40, paddingTop = 50, paddingLeft = 30, paddingRight = 70, paddingBottom = 10, gravity={"start", "center"} } ))
  local t3 = c3:addChild( lc:build("text", {width = "100", height="100", text = "Some text", textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, marginTop = 20, marginLeft = 40, marginRight = 20, marginBottom = 40, paddingTop = 50, paddingLeft = 30, paddingRight = 70, paddingBottom = 10, gravity={"start", "end"} } ))

  local t4 = c4:addChild( lc:build("text", {width = "100", height="100", text = "Some text", textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, marginTop = 20, marginLeft = 40, marginRight = 20, marginBottom = 40, paddingTop = 50, paddingLeft = 30, paddingRight = 70, paddingBottom = 10, gravity={"center", "start"} } ))
  local t5 = c5:addChild( lc:build("text", {width = "100", height="100", text = "Some text", textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, marginTop = 20, marginLeft = 40, marginRight = 20, marginBottom = 40, paddingTop = 50, paddingLeft = 30, paddingRight = 70, paddingBottom = 10, gravity={"center", "center"} } ))
  local t6 = c6:addChild( lc:build("text", {width = "100", height="100", text = "Some text", textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, marginTop = 20, marginLeft = 40, marginRight = 20, marginBottom = 40, paddingTop = 50, paddingLeft = 30, paddingRight = 70, paddingBottom = 10, gravity={"center", "end"} } ))

  local t7 = c7:addChild( lc:build("text", {width = "100", height="100", text = "Some text", textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, marginTop = 20, marginLeft = 40, marginRight = 20, marginBottom = 40, paddingTop = 50, paddingLeft = 30, paddingRight = 70, paddingBottom = 10, gravity={"end", "start"} } ))
  local t8 = c8:addChild( lc:build("text", {width = "100", height="100", text = "Some text", textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, marginTop = 20, marginLeft = 40, marginRight = 20, marginBottom = 40, paddingTop = 50, paddingLeft = 30, paddingRight = 70, paddingBottom = 10, gravity={"end", "center"} } ))
  local t9 = c9:addChild( lc:build("text", {width = "100", height="100", text = "Some text", textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, marginTop = 20, marginLeft = 40, marginRight = 20, marginBottom = 40, paddingTop = 50, paddingLeft = 30, paddingRight = 70, paddingBottom = 10, gravity={"end", "end"} } ))


  root:layoutingPass()

  return root
end

return {
  root = mainview(),
  update = function(self, dt) 
  end,
  draw = function(self)
    self.root:render()
  end
}