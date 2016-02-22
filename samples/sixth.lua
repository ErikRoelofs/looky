function mainview()
  local root = lc:build("root", {direction = "v"})
   
  root:addChild(makeHand())
  root:addChild( lc:build("linear", {direction="h", width="fill", height = "fill", weight = 2} ) )
  root:addChild(makeHand())
 
  
  local middle = root:getChild(2)
 
  middle:addChild( makeVerticalHand() )
  middle:addChild( lc:build("linear", {direction="v", width="fill", height = "fill", weight = 2} ) )
  middle:addChild( makeVerticalHand() )
 
  root:getChild(2):getChild(2):addChild(makestack())
  
  layout(root)
  
  
  return root
end

function makestack()
  local stack = lc:build("stack", {width = "fill", height = "fill", tiltDirection = { "start", "start" }, tiltAmount = {0.2,0.4}, backgroundColor={0,0,0,0}, gravity = { "center", "center" } } )
  local i = 0
  while i < 52 do
      stack:addChild(makeCard())
      i = i + 1
  end
  return stack
end

function makeHand()
  return lc:build("stack", {layoutGravity = "center", width = "wrap", height = "wrap", tiltDirection = { "end", "none" }, tiltAmount = {25,0}, backgroundColor={0,0,0,0} } )
end

function makeVerticalHand()
  return lc:build("stack", {layoutGravity = "center", width = "wrap", height = "wrap", tiltDirection = { "none", "end" }, tiltAmount = {0,25}, backgroundColor={0,0,0,0} } )    
end

function makeCard()
  return lc:build("text", {text="Derpderp", width = 100, height = 100, backgroundColor={0,0,255,40}})
end

function layout(root)
  root:getChild(1):addChild(makeCard())
  root:getChild(2):getChild(1):addChild(makeCard())
  root:getChild(2):getChild(3):addChild(makeCard())
  root:getChild(3):addChild(makeCard())
  root:layoutingPass()
  root:getChild(1):removeChild(1)
  root:getChild(2):getChild(1):removeChild(1)
  root:getChild(2):getChild(3):removeChild(1)
  root:getChild(3):removeChild(1)
  
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
        local hand = #(self.root:getChild(2):getChild(2):getChild(1).children) % 4
        if hand == 0 then          
          self.root:getChild(1):addChild(makeCard())
        elseif hand == 1 then
          self.root:getChild(2):getChild(1):addChild(makeCard())
        elseif hand == 2 then
          self.root:getChild(2):getChild(3):addChild(makeCard())
        elseif hand == 3 then
          self.root:getChild(3):addChild(makeCard())
        end      
      layout(self.root)
      end
    end
    self.root:update(dt)
  end,
  draw = function(self)
    self.root:render()
  end
}