function mainview(looky)
  local root = looky:build("root", {padding = looky.padding(25), background = { 30, 30, 30, 255}})
 
  ext = {value="First"}
 
  root:addChild(looky:build("text", {data=ext, width="fill",height=50}))
  root:addChild(looky:build("text", {data={value="Third"}, width="fill",height=50}))
  root:addChild(looky:build("text", {data={value="Second"}, width="fill",height=50}), 2)
 
  ext2 = root:getChild(2).data
 
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