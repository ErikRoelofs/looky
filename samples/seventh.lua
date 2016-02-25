function mainview()
  local root = lc:build("root", {})
 
  root:addChild(lc:build("text", {text="First", width="fill",height=50}))
  root:addChild(lc:build("text", {text="Third", width="fill",height=50}))
  root:addChild(lc:build("text", {text="Second", width="fill",height=50}), 2)
 
  root:layoutingPass()

  return root
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