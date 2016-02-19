function mainview()
  local root = lc:build("root", {direction = "v"})
 
  root:addChild( lc:build("linear", {direction="h", width="fill", height = "fill", weight = 1} ) )
  root:addChild( lc:build("linear", {direction="h", width="fill", height = "fill", weight = 2} ) )
  root:addChild( lc:build("linear", {direction="h", width="fill", height = "fill", weight = 1} ) )
  
  local middle = root:getChild(2)
 
  middle:addChild( lc:build("linear", {direction="v", width="fill", height = "fill", weight = 1} ) )
  middle:addChild( lc:build("linear", {direction="v", width="fill", height = "fill", weight = 2} ) )
  middle:addChild( lc:build("linear", {direction="v", width="fill", height = "fill", weight = 1} ) )
 
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