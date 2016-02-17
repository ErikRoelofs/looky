function mainview()
  local root = lc:build("root", {})
  
  local p1 = lc:build("stack", {width = "fill", height = "fill", backgroundColor = {255,0,0,100}})
  root:addChild(p1)
  local p2 = lc:build("stack", {width = "fill", height = "fill", backgroundColor = {0,255,0,100}})
  root:addChild(p2)
  local p3 = lc:build("stack", {width = "fill", height = "fill", backgroundColor = {0,255,0,100}})
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

  addtext(c1, {"start", "start"})
  addtext(c2, {"start", "center"})
  addtext(c3, {"start", "end"})
  addtext(c4, {"center", "start"})
  addtext(c5, {"center", "center"})
  addtext(c6, {"center", "end"})
  addtext(c7, {"end", "start"})
  addtext(c8, {"end", "center"})
  addtext(c9, {"end", "end"})


  root:layoutingPass()

  return root
end

function addtext(container, gravity)
  local useMT = 5
  local useML = 8
  local useMR = 4
  local useMB = 8
  local usePT = 10
  local usePL = 6
  local usePR = 14
  local usePB = 2
  local width = 200
  local height = 100
  local text = "Some text"
  
  container:addChild( lc:build("text", {width = width, height=height, text = text, textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, marginTop = useMT, marginLeft = useML, marginRight = useMR, marginBottom = useMB, paddingTop = usePT, paddingLeft = usePL, paddingRight = usePR, paddingBottom = usePB, gravity=gravity } ))
  
end

return {
  root = mainview(),
  update = function(self, dt) 
  end,
  draw = function(self)
    self.root:render()
  end
}