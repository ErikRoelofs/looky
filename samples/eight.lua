function mainview()
  local root = lc:build("root", {margin = lc.margin(100), padding = lc.padding(25), backgroundColor = { 30, 30, 30, 255}, weight = 4.2 })
 
  ext = {value="First"}
 
  root:addChild(lc:build("text", {data=ext, width="fill",height=50}))
  root:addChild(lc:build("text", {data={value="Third"}, width="fill",height=50}))
  root:addChild(lc:build("text", {data={value="Second"}, width="fill",height=50}), 2)
 
  ext2 = root:getChild(2).data
 
  root:layoutingPass()

  return root
end

return {
  root = mainview(),
  update = function(self, dt) 
    self.root:update(dt)
    ext.value = dt
    ext2.value = dt
    self.root:layoutingPass()
  end,
  draw = function(self)
    self.root:render()
  end
}