function mainview()
  local root = lc:build("root", {direction = "v"})
 
  root:addChild( lc:build("linear", {direction="h", width="fill", height = "fill", weight = 1 } ) )
  root:addChild( lc:build("linear", {direction="h", width="fill", height = "fill", weight = 2} ) )
  root:addChild( lc:build("linear", {direction="h", width="fill", height = "fill", weight = 1 } ) )
  
  local middle = root:getChild(2)
 
  middle:addChild( lc:build("linear", {direction="v", width="fill", height = "fill", weight = 1} ) )
  middle:addChild( lc:build("linear", {direction="v", width="fill", height = "fill", weight = 2} ) )
  middle:addChild( lc:build("linear", {direction="v", width="fill", height = "fill", weight = 1} ) )
 
  root:getChild(2):getChild(2):addChild(makestack())
  
  root:getChild(1):addChild(makeHand())
  root:getChild(3):addChild(makeHand())

  root:layoutingPass()
  
  
  return root
end

function makestack()
  local stack = lc:build("stack", {width = "wrap", height = "wrap", tiltDirection = { "start", "start" }, tiltAmount = {0.2,0.4}, backgroundColor={0,0,0,0}} )
  local i = 0
  while i < 52 do
      stack:addChild(makeCard())
      i = i + 1
  end
  return stack
end

function makeHand()
  local stack = lc:build("stack", {layoutGravity = "center", width = "wrap", height = "wrap", tiltDirection = { "end", "none" }, tiltAmount = {25,0}, backgroundColor={0,0,0,0} } )
  local i = 0
  return stack  
end

function makeCard()
  return lc:build("text", {text="Derpderp", width = 100, height = 100, backgroundColor={0,0,255,40}})
end

local count = 0

return {
  root = mainview(),
  update = function(self, dt)
    count = count+dt
    if(count > 0.05) then
      count = count - 0.05      
      self.root:getChild(2):getChild(2):getChild(1):removeChild( #self.root:getChild(2):getChild(2):getChild(1).children )
      if #(self.root:getChild(2):getChild(2):getChild(1).children) > 0 then
        if #(self.root:getChild(2):getChild(2):getChild(1).children) % 2 == 0 then
          self.root:getChild(1):getChild(1):addChild(makeCard())
        else
          self.root:getChild(3):getChild(1):addChild(makeCard())
        end
      self.root:layoutingPass()
      end
    end
    self.root:update(dt)
  end,
  draw = function(self)
    self.root:render()
  end
}