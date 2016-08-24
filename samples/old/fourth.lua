function mainview(looky)
  local root = looky:build("root", {})
  
  local p1 = looky:build("stack", {width = "fill", height = "fill", tiltDirection = {"start", "start"}, tiltAmount = { 10, 20 }, background = {255,0,0,100}})
  root:addChild(p1)
  local p2 = looky:build("stack", {width = "fill", height = "fill", tiltDirection = {"end", "end"}, tiltAmount = { 10, 20 }, background = {0,255,0,100}})
  root:addChild(p2)
  local p3 = looky:build("stack", {width = "fill", height = "fill", tiltDirection = {"start", "end"}, tiltAmount = { 2, 25 }, background = {0,0,255,100}})
  root:addChild(p3)

  addtext(p1, "first", {"start", "start"}, looky)
  addtext(p1, "second", {"start", "start"}, looky)
  addtext(p1, "third", {"start", "start"}, looky)
  addtext(p2, "first", {"start", "start"}, looky)
  addtext(p2, "second", {"start", "start"}, looky)
  addtext(p2, "third", {"start", "start"}, looky)
  addtext(p3, "first", {"start", "start"}, looky)
  addtext(p3, "second", {"start", "start"}, looky)
  addtext(p3, "third", {"start", "start"}, looky)


  root:layoutingPass()

  return root
end

function addtext(container, text, gravity, looky)  
  local padding = looky.padding(6, 10, 14, 2)

  local width = 200
  local height = 100
  
  container:addChild( looky:build("text", {width = width, height=height, data = {value=text}, textColor = {255,255,255,255}, background={0,0,0,255}, padding = padding, gravity=gravity, border={color={255,255,255,255}, thickness=2 }} ))
  
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