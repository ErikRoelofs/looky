function mainview(looky)
  local root = looky:build("root", {direction = "v"})
   
  root:addChild(makeHand(looky))
  root:addChild( looky:build("linear", {direction="h", width="fill", height = "fill", weight = 2} ) )
  root:addChild(makeHand(looky))
  
  local middle = root:getChild(2)
 
  middle:addChild( makeVerticalHand(looky) )
  middle:addChild( looky:build("linear", {direction="v", width="fill", height = "fill", weight = 2} ) )
  middle:addChild( makeVerticalHand(looky) )
 
  root:getChild(2):getChild(2):addChild(makestack(looky))
  
  initialPass(root, looky)
  
  return root
end

function makestack(looky)
  local stack = looky:build("stack", {width = "fill", height = "fill", tiltDirection = { "start", "start" }, tiltAmount = {2,4}, background={0,0,0,0}, gravity = { "center", "center" } } )
  local i = 1
  while i < 53 do
      stack:addChild(makeCard(i, looky))
      i = i + 1
  end
  return stack
end

function makeHand(looky)
  return looky:build("stack", {width = "wrap", height = "wrap", tiltDirection = { "end", "none" }, tiltAmount = {25,0}, background={0,0,0,0} } )
end

function makeVerticalHand(looky)
  return looky:build("stack", {width = "wrap", height = "wrap", tiltDirection = { "none", "end" }, tiltAmount = {0,25}, background={0,0,0,0} } )    
end

function makeCard(i, looky)
  local background = { 0, 0, 255, 255 }
  if i == 0 then
    background = { 255, 0, 0, 255 }
  end
  return looky:build("text", {data={value="C" .. i}, width = 100, height = 100, background=background})
end

function initialPass(root, looky)
  local child = makeCard(0, looky)
  root:getChild(1):addChild(child)
  root:getChild(2):getChild(1):addChild(child)
  root:getChild(2):getChild(3):addChild(child)
  root:getChild(3):addChild(child)
  root:layoutingPass()
  root:getChild(1):removeChild(child)
  root:getChild(2):getChild(1):removeChild(child)
  root:getChild(2):getChild(3):removeChild(child)
  root:getChild(3):removeChild(child)
  
end

local count = 0

return function(looky)
  return {
    root = mainview(looky),
    looky = looky,
    update = function(self, dt)
      
      if love.keyboard.isDown("r") then
        self.root = mainview(self.looky)
      end
      
      count = count+dt
      if(count > 0.05) then
        count = count - 0.05      
        local stack = self.root:getChild(2):getChild(2):getChild(1)
        local target = #self.root:getChild(2):getChild(2):getChild(1).children
        local childToMove = stack:getChild( target )
        if #(stack.children) > 0 then
          stack:removeChild(target)    
          local hand = #(stack.children) % 4
          if hand == 0 then          
            self.root:getChild(1):addChild(childToMove)          
          elseif hand == 1 then
            self.root:getChild(2):getChild(1):addChild(childToMove)          
          elseif hand == 2 then
            self.root:getChild(2):getChild(3):addChild(childToMove)
          elseif hand == 3 then
            self.root:getChild(3):addChild(childToMove)
          end      
          self.root:layoutingPass()
        end
      end
      initialPass(self.root, self.looky)      
    end,
    draw = function(self)
      self.root:render()
    end
  }
end