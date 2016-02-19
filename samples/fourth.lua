function mainview()
  local root = lc:build("root", {})
  
  local p1 = lc:build("stack", {width = "fill", height = "fill", tiltDirection = {"start", "start"}, tiltAmount = { 10, 20 }, backgroundColor = {255,0,0,100}})
  root:addChild(p1)
  local p2 = lc:build("stack", {width = "fill", height = "fill", tiltDirection = {"end", "end"}, tiltAmount = { 10, 20 }, backgroundColor = {0,255,0,100}})
  root:addChild(p2)
  local p3 = lc:build("stack", {width = "fill", height = "fill", tiltDirection = {"start", "end"}, tiltAmount = { 2, 25 }, backgroundColor = {0,0,255,100}})
  root:addChild(p3)

  addtext(p1, "first", {"start", "start"})
  addtext(p1, "second", {"start", "start"})
  addtext(p1, "third", {"start", "start"})
  addtext(p2, "first", {"start", "start"})
  addtext(p2, "second", {"start", "start"})
  addtext(p2, "third", {"start", "start"})
  addtext(p3, "first", {"start", "start"})
  addtext(p3, "second", {"start", "start"})
  addtext(p3, "third", {"start", "start"})


  root:layoutingPass()

  return root
end

function addtext(container, text, gravity)  
  local padding = lc.padding(6, 10, 14, 2)
  local margin = lc.margin(8,5,4,8)

  local width = 200
  local height = 100
  
  container:addChild( lc:build("text", {width = width, height=height, text = text, textColor = {255,255,255,255}, backgroundColor={0,0,0,255}, margin = margin, padding = padding, gravity=gravity, border={color={255,255,255,255}, thickness=2 }} ))
  
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