local renderText = function(self)
  self:renderBackground()
  
  local locX, locY = self:startCoordsBasedOnGravity()
  love.graphics.setColor(self.textColor or {255,255,255,255})
  if self:contentWidth() > self:grantedWidth() then
    local toPrint = self.data.value
    while self:contentWidth(toPrint) > self:grantedWidth() do
      toPrint = toPrint:sub(0,-2)
    end
    love.graphics.print(toPrint,locX,locY)
  else
    love.graphics.print(self.data.value,locX,locY)
  end

end

local textWidth = function (self, str)
  str = str or self.data.value
  return font:getWidth(str)
end

local textHeight = function (self)
  return font:getHeight()
end

return function(lc)
  return {
    build = function(base, options)
      base.renderCustom = renderText
      base.data = options.data
      base.textColor = options.textColor or {255,255,255,255}
      base.contentWidth = textWidth
      base.contentHeight = textHeight  
      return base
    end,
    schema = lc:extendSchema("base", {data = { required = true, schemaType = "table", options = { value = { required = true, schemaType ="string" } } }, textColor = { required = false, schemaType = "color" } })
  }
end