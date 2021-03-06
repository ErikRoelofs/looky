local renderAquarium = function(self)      
  local canvas = nil
  if self.useCanvas then    
    canvas = love.graphics.newCanvas(self:availableWidth(), self:availableHeight())
    love.graphics.setCanvas(canvas)    
  end

  for k, child in ipairs(self:getChildren()) do
    local offsetX, offsetY = self:getOffset(child)
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    child:render()
    love.graphics.pop()    
  end
  
  if self.useCanvas then
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0)
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

return function(looky)
  return {
    build = function(options)      
      local base = looky:makeBaseLayout(options)
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
        if self.useCanvas then
          return self.offsets[child][1], self.offsets[child][2]
        end
        return math.min( self.offsets[child][1], self:grantedWidth() - child:grantedWidth()), 
               math.min( self.offsets[child][2], self:grantedHeight() - child:grantedHeight())
      end
      base.oldAddChild = base.addChild
      base.addChild = function(self, child, x, y)
        base:oldAddChild(child)
        base:setOffset(child, x, y)
      end
      base.setOffset = function(self, child, x, y) 
        if type(child) == "number" then
          child = self:getChild(child)
        end        
        self.offsets[child] = { x, y }        
      end
      base.useCanvas = options.useCanvas or false
      return base
    end,
    schema = looky:extendSchema("base",  {
      useCanvas = {
        required = false,
        schemaType = "boolean"
      }
    })
  }
end