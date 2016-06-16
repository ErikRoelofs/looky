local renderDragbox = function(self)  
  if self:getChild(1) then
    love.graphics.translate(self.offset[1], self.offset[2])
    self:getChild(1):render()
  end
end

local function layout(self, children)
  if self:getChild(1) then
    self:getChild(1):setDimensions(self:getChild(1):desiredWidth(), self:getChild(1):desiredHeight())
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