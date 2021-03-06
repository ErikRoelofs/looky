local determineOffsetX = function(self, child)
  if self.left ~= "fill" then
    return self.left
  elseif self.right ~= "fill" then
    return self:grantedWidth() - self.right - child:grantedWidth()
  else
    local spareWidth = self:grantedWidth() - child:grantedWidth()
    local totalookyhunks = (self.leftWeight or 1) + (self.rightWeight or 1)
    return spareWidth / totalookyhunks * (self.leftWeight or 1)
  end
end

local determineOffsetY = function(self, child)
  if self.top ~= "fill" then
    return self.top
  elseif self.bottom ~= "fill" then
    return self:grantedHeight() - self.bottom - child:grantedHeight()
  else
    local spareHeight = self:grantedHeight() - child:grantedHeight()
    local totalookyhunks = (self.topWeight or 1) + (self.bottomWeight or 1)
    return spareHeight / totalookyhunks * (self.topWeight or 1)
  end
end

local renderBordered = function(self)  
  local child = self:getChild(1)
  if child then
    love.graphics.translate(determineOffsetX(self,child), determineOffsetY(self,child))
    self:getChild(1):render()
  end
end

local function layout(self, children)
  local child = self:getChild(1)  
  if child then
    local giveWidth = 0
    local giveHeight = 0
    
    local availableWidth = self:grantedWidth()
    if self.left ~= "fill" then
      availableWidth = availableWidth - self.left
    end
    if self.right ~= "fill" then
      availableWidth = availableWidth - self.right
    end
    if child:desiredWidth() == "fill" then 
      giveWidth = availableWidth
    else
      giveWidth = math.min(child:desiredWidth(), availableWidth)
    end
    
    local availableHeight = self:grantedHeight()
    if self.top ~= "fill" then
      availableHeight = availableHeight - self.top
    end
    if self.bottom ~= "fill" then
      availableHeight = availableHeight - self.bottom
    end
    if child:desiredHeight() == "fill" then 
      giveHeight = availableHeight
    else
      giveHeight = math.min(child:desiredHeight(), availableHeight)
    end
    
    
    self:getChild(1):setDimensions(giveWidth, giveHeight)
    self:getChild(1):layoutingPass()
  end
end

return function(looky)
  return {
    build = function(options)      
      local base = looky:makeBaseLayout(options)
      -- set sizes and weights
      base.left = options.left or 0
      base.right = options.right or 0
      base.bottom = options.bottom or 0
      base.top = options.top or 0
      
      base.leftWeight = options.leftWeight or 1
      base.rightWeight = options.rightWeight or 1
      base.bottomWeight = options.bottomWeight or 1
      base.topWeight = options.topWeight or 1
      
      base.addListener = function(self, listener, method)
        table.insert(self.listeners, { target = listener, method = method })
      end
      base.renderCustom = renderBordered
      base.oldAddChild = base.addChild
      base.offset = options.offset or { 0, 0 }      
      base.layoutingPass = layout
      base.contentWidth = function(self)
        if self.left == "fill" or self.right == "fill" then
          return "fill"
        end        
        if self:getChild(1) then
          if self:getChild(1):desiredWidth() == "fill" then
            return "fill"
          else
            return self:getChild(1):desiredWidth() + self.left + self.right
          end
        end
        return self.left + self.right
      end
      base.contentHeight = function(self)
        if self.top == "fill" or self.bottom == "fill" then
          return "fill"
        end        
        if self:getChild(1) then
          if self:getChild(1):desiredHeight() == "fill" then
            return "fill"
          else
            return self:getChild(1):desiredHeight() + self.top + self.bottom
          end
        end
        return self.top + self.bottom
      end

      base.desiredWidth = function(self)
        if self.visibility == "gone" then
          return 0
        end
        return self:contentWidth()
      end
      base.desiredHeight = function(self)
        if self.visibility == "gone" then
          return 0
        end
        return self:contentHeight()
      end

      base.addChild = function(self, child)        
        if #base:getChildren() >= 1 then
          error( "A borderer layout can only have 1 child." )
        end
        base:oldAddChild(child)
      end        
      
      base.translateCoordsToChild = function(self, child, x, y) 
        return x - determineOffsetX(self,child), y - determineOffsetY(self,child)
      end
      base.translateCoordsFromChild = function(self, child, x, y)
        return x + determineOffsetX(self,child), y + determineOffsetY(self,child)
      end

      
      return base
    end,
    
    schema = looky:extendSchema("base", {
      width = false,
      height = false,
      left = { required = false, schemaType = "oneOf", possibilities = {
            { schemaType = "fromList", list = {"fill"} },
            { schemaType = "number" }            
          }},
      leftWeight = { required = false, schemaType = "number" },
      right = { required = false, schemaType = "oneOf", possibilities = {
            { schemaType = "fromList", list = {"fill"} },
            { schemaType = "number" }            
          }},
      rightWeight = { required = false, schemaType = "number" },
      top = { required = false, schemaType = "oneOf", possibilities = {
            { schemaType = "fromList", list = {"fill"} },
            { schemaType = "number" }            
          }},
      topWeight = { required = false, schemaType = "number" },
      bottom = { required = false, schemaType = "oneOf", possibilities = {
            { schemaType = "fromList", list = {"fill"} },
            { schemaType = "number" }            
          }},
      bottomWeight = { required = false, schemaType = "number" }
    })
  }
end