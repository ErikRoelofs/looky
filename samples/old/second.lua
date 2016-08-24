function mainview(looky)
  totalookylicked = 0
  
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

  addtext(c1, {"start", "start"}, looky)
  addtext(c2, {"start", "center"}, looky)
  addtext(c3, {"start", "end"}, looky)
  addtext(c4, {"center", "start"}, looky)
  addtext(c5, {"center", "center"}, looky)
  addtext(c6, {"center", "end"}, looky)
  addtext(c7, {"end", "start"}, looky)
  addtext(c8, {"end", "center"}, looky)
  c9:addChild(looky:build("numberAsImage",{ padding = looky.padding(10), width = "wrap", height = "wrap", image = love.graphics.newImage( "images/heart.png" ), emptyImage = "images/emptyheart.png", maxValue = 5, value = function() return totalookylicked end }))


  root:layoutingPass()

  return root
end

function addtext(container, gravity, looky)
  local width = 200
  local height = 100
  local text = "Some text"
  local f = function() return "hovered: "  end
  
  local padding = looky.padding(6, 10, 14, 2)  
  
  container:addChild( looky:build("text", {width = width, height=height, data = f, textColor = {255,255,255,255}, background={0,0,0,255}, padding = padding, gravity=gravity, font = "default" } ))
  
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