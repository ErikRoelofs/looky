local function renderSlotted(self)
  for _, slot in pairs(self.slots) do
    if slot.view then
      love.graphics.translate(slot.x, slot.y)
      slot.view:render()
      love.graphics.translate(-slot.x, -slot.y)
    end    
  end
end

local function layout(self, children)
  for _, slot in pairs(self.slots) do
    if slot.view then
      slot.view:setDimensions(slot.width, slot.height)
      slot.view:layoutingPass()
    end
  end
end

return function(looky)
  return {
    build = function(options)      
      local base = looky:makeBaseLayout(options)
      base.slots = options.slots
      base.renderCustom = renderSlotted
      base.layoutingPass = layout
      base.addChildToSlot = function(self, child, slot)
        assert(self.slots[slot], "No such slot: " .. slot )
        self.slots[slot].view = child
      end        
      return base
    end,
    schema = looky:extendSchema("base",  {
      slots = {
        required = true,
        schemaType = "array",
        item = {
          schemaType = "table",
          options = {
            x = { required = true, schemaType = "number" },
            y = { required = true, schemaType = "number" },
            width = { required = true, schemaType = "number" },
            height = { required = true, schemaType = "number" },
          }
        }
      }
    })
  }
end