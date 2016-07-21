local renderAquarium = function(self)  
  for k, child in ipairs(self:getChildren()) do
    local offsetX, offsetY = self:getOffset(child)
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    child:render()
    love.graphics.pop()    
  end
end

local function layout(self, children)
  for k, child in ipairs(self:getChildren()) do
    local giveWidth = math.min( self:grantedWidth(), child:desiredWidth() )
    local giveHeight = math.min( self:grantedHeight(), child:desiredHeight() )
    
    child:setDimensions(giveWidth, giveHeight)
    child:layoutingPass()
  end
end

return function(lc)
  return {
    build = function(options)      
      local base = lc:makeBaseLayout(options)
      base.offsets = {}
      base.renderCustom = renderAquarium            
      base.layoutingPass = layout
      base.getOffset = function(self, child) 
        if type(child) == "number" then
          child = self:getChild(child)
        end
        if not self.offsets[child] then
          self.offsets[child] = {0,0}
        end
        return math.min( self.offsets[child][1], self:grantedWidth() - child:grantedWidth()), 
               math.min( self.offsets[child][2], self:grantedHeight() - child:grantedHeight())
      end
      base.setOffset = function(self, child, x, y) 
        if type(child) == "number" then
          child = self:getChild(child)
        end        
        self.offsets[child] = { x, y }        
      end
      return base
    end,
    schema = lc:extendSchema("base",  {})
  }
end