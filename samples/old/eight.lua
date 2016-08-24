function mainview(looky)
  local root = looky:build("root", {padding = looky.padding(25), background = { 30, 30, 30, 255}, weight = 4.2 })
 
  ext = {value="First"}
 
  local container = looky:build("linear", { width = "wrap", height="fill", direction = "v" })
  local container2 = looky:build("linear", { width = "wrap", height="fill", direction = "v" })
 
  root:addChild(container)
  root:addChild(container2)
  container:addChild(looky:build("text", {data=ext, width="fill",height=50}))
  container:addChild(looky:build("text", {data={value="Third"}, width="fill",height=50}))
  container:addChild(looky:build("text", {data={value="Second"}, width="fill",height=50}), 2)
 
  container2:addChild(looky:build("text", {data={value="Visible"}, width="fill",height=50, visibility="visible"}))
  container2:addChild(looky:build("text", {data={value="Cloaked"}, width="fill",height=50, visibility="cloaked"}))
  container2:addChild(looky:build("text", {data={value="Gone"}, width="fill",height=50, visibility="gone"}))
 
  container2:addChild(looky:build("text", {data={value="texxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxt"}, width=50, height=50, background = {255,0,0,255}}))
 
  container2:addChild(looky:build("image", {file="test-large.png", width=50, height="fill", background = {255,0,0,255}, scale="crop"}))
 
 
  ext2 = root:getChild(1):getChild(2).data
 
  root:layoutingPass()

  return root
end

return function(looky)
  return {
    root = mainview(looky),
    update = function(self, dt) 
      self.root:update(dt)
      ext.value = dt .. "dt"
      ext2.value = dt .. "dt"
      self.root:layoutingPass()
    end,
    draw = function(self)
      self.root:render()
    end
  }
end