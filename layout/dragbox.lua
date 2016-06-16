local renderDragbox = function(self)  
  if self:getChild(1) then
    local offsetX = math.min( self.offset[1], self:grantedWidth() - self:getChild(1):grantedWidth() )
    local offsetY = math.min( self.offset[2], self:grantedHeight() - self:getChild(1):grantedHeight() )
    love.graphics.translate(offsetX, offsetY)
    self:getChild(1):render()
  end
end

local function layout(self, children)
  if self:getChild(1) then
    local giveWidth = math.min( self:grantedWidth(), self:getChild(1):desiredWidth() )
    local giveHeight = math.min( self:grantedHeight(), self:getChild(1):desiredHeight() )
    
    self:getChild(1):setDimensions(giveWidth, giveHeight)
    self:getChild(1):layoutingPass()
  end
end

return function(lc)
  return {
    build = function(base, options)      
      base.renderCustom = renderDragbox
      base.oldAddChild = base.addChild
      base.offset = options.offset or { 0, 0 }      
      base.layoutingPass = layout
      base.addChild = function(self, child)
        if #base:getChildren() >= 1 then
          error( "A dragbox can only have 1 child." )
        end
        base:oldAddChild(child)
      end
      return base
    end,
    schema = lc:extendSchema("base",  {
      offset = { 
        required = false, 
        schemaType = "table",
        options = {
          {
            required = true,
            schemaType = "number"
          },
          {
            required = true,
            schemaType = "number"
          },          
        }
      } 
    })
  }
end