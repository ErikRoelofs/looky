function mainview(lc)
  totalClicked = 0
  
  local root = lc:build("root", {})
  
  local p1 = lc:build("linear", {width = "fill", height = "fill", background = {255,0,0,100}, direction = "v"})
  root:addChild(p1)
  local p2 = lc:build("linear", {width = "fill", height = "fill", background = {0,255,0,100}, direction = "v"})
  root:addChild(p2)
  local p3 = lc:build("linear", {width = "fill", height = "fill", background = {0,255,0,100}, direction = "v"})
  root:addChild(p3)
  
  local c1 = lc:build("linear", {width = "fill", height = "fill", background = {255,0,0,100}, direction = "h"})
  p1:addChild(c1)
  local c2 = lc:build("linear", {width = "fill", height = "fill", background = {0,255,0,100}, direction = "h"})
  p1:addChild(c2)
  local c3 = lc:build("linear", {width = "fill", height = "fill", background = {0,0,255,100}, direction = "h"})
  p1:addChild(c3)
  
  local c4 = lc:build("linear", {width = "fill", height = "fill", background = {0,255,0,100}, direction = "h"})
  p2:addChild(c4)
  local c5 = lc:build("linear", {width = "fill", height = "fill", background = {255,0,0,100}, direction = "h"})
  p2:addChild(c5)
  local c6 = lc:build("linear", {width = "fill", height = "fill", background = {0,0,255,100}, direction = "h"})
  p2:addChild(c6)
  
  local c7 = lc:build("linear", {width = "fill", height = "fill", background = {0,0,255, 100}, direction = "h"})
  p3:addChild(c7)
  local c8 = lc:build("linear", {width = "fill", height = "fill", background = {0,255,0,100}, direction = "h"})
  p3:addChild(c8)
  local c9 = lc:build("linear", {width = "fill", height = "fill", background = {255,0,0,100}, direction = "h"})
  p3:addChild(c9)

  addtext(c1, {"start", "start"}, lc)
  addtext(c2, {"start", "center"}, lc)
  addtext(c3, {"start", "end"}, lc)
  addtext(c4, {"center", "start"}, lc)
  addtext(c5, {"center", "center"}, lc)
  addtext(c6, {"center", "end"}, lc)
  addtext(c7, {"end", "start"}, lc)
  addtext(c8, {"end", "center"}, lc)
  c9:addChild(lc:build("numberAsImage",{ padding = lc.padding(10), width = "wrap", height = "wrap", image = love.graphics.newImage( "images/heart.png" ), emptyImage = "images/emptyheart.png", maxValue = 5, value = function() return totalClicked end }))


  root:layoutingPass()

  return root
end

function addtext(container, gravity, lc)
  local width = 200
  local height = 100
  local text = "Some text"
  local f = function() return "hovered: "  end
  
  local padding = lc.padding(6, 10, 14, 2)  
  
  container:addChild( lc:build("text", {width = width, height=height, data = f, textColor = {255,255,255,255}, background={0,0,0,255}, padding = padding, gravity=gravity, font = "default" } ))
  
end

return function(lc)
  return {
    root = mainview(lc),
    update = function(self, dt)       
      self.root:update(dt)
    end,
    draw = function(self)
      self.root:render()
    end
  }
end