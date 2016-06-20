local _NAME = ...
local _PACKAGE = _NAME:sub(1, -15) -- I should probably clean this up...

local  function baseLayout(width, height)
  return {
    children = {},
    parent = nil,
    width = width,
    height = height,    
    addChild = function(self, child, position)
      assert(child, "No child was passed to addChild")
      local position = position or #self.children+1
      table.insert(self.children, position, child)
      child:setParent(self)
    end,
    setParent = function(self, parent)
      self.parent = parent
    end,
    desiredWidth = function(self)
      if self.visibility == "gone" then
        return 0
      end
      if self.width == "fill" then
        return self.width
      elseif self.width == "wrap" then
        local content = self:contentWidthWithPadding()
        if content == "fill" then
          return content
        else
          return content + self.margin.left + self.margin.right
        end
      else
        return self.width + self.margin.left + self.margin.right
      end
    end,
    desiredHeight = function(self)
      if self.visibility == "gone" then
        return 0
      end
      if self.height == "fill" then
        return self.height
      elseif self.height == "wrap" then
        local content = self:contentHeightWithPadding()
        if content == "fill" then
          return content
        else
          return content + self.margin.top + self.margin.bottom
        end
      else        
        return self.height + self.margin.top + self.margin.bottom
      end
    end,
    grantedWidth = function(self)
      return self.givenWidth
    end,
    grantedHeight = function(self)
      return self.givenHeight
    end,
    setDimensions = function(self, x, y)
      self.givenWidth = x
      self.givenHeight = y
    end,
    availableWidth = function(self)
      return self:grantedWidth() - self.margin.left - self.margin.right
    end,
    availableHeight = function(self)
      return self:grantedHeight() - self.margin.top - self.margin.bottom
    end,
    layoutingPass = function(self)
      
    end,
    render = function(self)
      if self.visibility == "visible" then
        self:renderCustom()
      end
    end,
    renderCustom = function(self)
      
    end,
    update = function(self, dt)
      
    end,
    contentWidth = function(self)
      return 0
    end,
    contentHeight = function(self)
      return 0
    end,
    contentWidthWithPadding = function(self)
      if self:contentWidth() == "fill" then
        return self:contentWidth()
      end
      return self:contentWidth() + self.padding.left + self.padding.right
    end,
    contentHeightWithPadding = function(self)
      if self:contentHeight() == "fill" then
        return self:contentHeight()
      end
      return self:contentHeight() + self.padding.top + self.padding.bottom
    end,
    renderBackground = function(self)
      love.graphics.setColor(self.backgroundColor)
      local width = self:availableWidth()
      local height = self:availableHeight()
      love.graphics.rectangle("fill", 0, 0, width, height)
      self:renderBorder()
    end,
    renderBorder = function(self)
      love.graphics.setColor(self.border.color)
      love.graphics.setLineWidth(self.border.thickness)
      local width = self:availableWidth()
      local height = self:availableHeight()
      love.graphics.rectangle("line", self.border.thickness/2, self.border.thickness/2, width - self.border.thickness, height - self.border.thickness)
      love.graphics.setLineWidth(1)
    end,
    startCoordsBasedOnGravity = function(self)
      local locX, locY
      if self.gravity[1] == "start" then
        locX = self.padding.left
      elseif self.gravity[1] == "end" then
        locX = self:availableWidth() - self:contentWidth() - self.padding.left
      elseif self.gravity[1] == "center" then
        locX = (self:availableWidth() - self:contentWidth() - self.padding.left - self.padding.right) / 2
      end
      if self.gravity[2] == "start" then
        locY = self.padding.top
      elseif self.gravity[2] == "end" then
        locY = self:availableHeight() - self:contentHeight() - self.padding.bottom
      elseif self.gravity[2] == "center" then
        locY = (self:availableHeight() - self:contentHeight() - self.padding.bottom - self.padding.top) / 2 
      end
      return locX, locY
    end,
    getChild = function(self, number)
      return self.children[number]
    end,
    getChildren = function(self)
      return self.children
    end,
    removeChild = function(self,target)
      if type(target) == "number" then
        table.remove(self.children, target)
        return target
      else
        for k, v in ipairs(self.children) do
          if v == target then
            table.remove(self.children, k)
            return k
          end
        end
      end
    end,
    removeAllChildren = function(self)
      self.children = {}
    end,
    clickedViews = function(self, x, y)
      if x > 0 and x < self:grantedWidth() and
        y > 0 and y < self:grantedHeight() then
         return { self } 
      end
      return {}
    end
  }
end

paddingMarginHelper = function(left, top, right, bottom)
  assert( not (type(left) == "table" and top ~= nil), "Cannot pass both a table and other values to padding/margin. Did you accidentally call it as a method (ie lc:padding(10)) ?" )
  if left == nil and top == nil and right == nil and bottom == nil then
    return paddingMarginHelper(0,0,0,0)
  elseif top == nil and right == nil and bottom == nil then
    if type(left) == "table" then
      return paddingMarginHelper(left.left or 0, left.top or 0, left.right or 0, left.bottom or 0)
    else
      return paddingMarginHelper(left,left,left,left)
    end
  elseif right == nil and bottom == nil then
    return paddingMarginHelper(left,top,left,top)  
  else
    return {
      left = left,
      top = top,
      right = right,
      bottom = bottom
    }
  end
end
  
  return {
    kinds = {
      base = { 
        build = function() assert(false, "Base cannot be instantiated") end,
        schema = {
          width = { required = true, schemaType = "oneOf", possibilities = {
            { schemaType = "fromList", list = {"wrap", "fill"} },
            { schemaType = "number" }            
          }},
          height = { required = true, schemaType = "oneOf", possibilities = {
            { schemaType = "fromList", list = {"wrap", "fill"} },
            { schemaType = "number" }            
          }},
          padding = { required = false, schemaType = "table", options = {
            left = { required = true, schemaType = "number" },
            right = { required = true, schemaType = "number" },
            bottom = { required = true, schemaType = "number" },
            top = { required = true, schemaType = "number" },
          }},
          margin = { required = false, schemaType = "table", options = {
            left = { required = true, schemaType = "number" },
            right = { required = true, schemaType = "number" },
            bottom = { required = true, schemaType = "number" },
            top = { required = true, schemaType = "number" },          
          }},          
          backgroundColor = { required = false, schemaType = "color" },
          layoutGravity = { required = false, schemaType = "fromList", list = { "start", "center", "end"}  },
          gravity = { required = false, schemaType = "table", options = {
            { schemaType = "fromList", list = { "start", "center", "end" } },
            { schemaType = "fromList", list = { "start", "center", "end" } },
          }},
          border = { required = false, schemaType = "table", options = {
            color = { required = true, schemaType = "color" },
            thickness = { required = true, schemaType = "number" }
          }},
          weight = { required = false, schemaType = "number" },
          visibility = { required = false, schemaType = "fromList", list = { "visible", "cloaked", "gone" } }
        }
      }
    },

    fonts = {
      base = love.graphics.newFont()
    },
    validator = require ( _PACKAGE .. "/validation/validator" ),
    build = function( self, kind, options )
      assert(self.kinds[kind], "Requesting layout " .. kind .. ", but I do not have it")      
      local base = self:makeBaseLayout(options)
      self:validate(kind, options)
      return self.kinds[kind].build(base, options)
    end,
    register = function( self, name, fn )
      assert(not self.kinds[name], "A layout named " .. name .. " was previously registered")
      self.kinds[name] = fn
    end,
    registerFont = function( self, name, font )
      assert(not self.fonts[name], "A font named " .. name .. " was previously registered")
      self.fonts[name] = font
    end,
    getFont = function( self, name )
      assert(self.fonts[name], "Requesting font " ..  name .. ", but I do not have it")
      return self.fonts[name]
    end,
    padding = function(left, top, right, bottom)
      return paddingMarginHelper(left, top, right, bottom)
    end,
    margin =  function(left, top, right, bottom)
      return paddingMarginHelper(left, top, right, bottom)
    end,
    makeBaseLayout = function(self, options)
      local start = baseLayout(options.width, options.height)      
      start.padding = self.padding(options.padding)
      start.margin = self.margin(options.margin)      
      start.backgroundColor = options.backgroundColor or {0,0,0,0}
      start.border = options.border or { color = { 0, 0, 0, 0 }, thickness = 0 }
      start.layoutGravity = options.layoutGravity or "start"
      start.gravity = options.gravity or {"start","start"}
      start.weight = options.weight or 1
      start.visibility = options.visibility or "visible"
      return start
    end,
    mergeOptions = function (baseOptions, options)
      for k, v in pairs(options) do
        baseOptions[k] = v
      end
      return baseOptions   
    end,
    validate = function(self, kind, options)
      self.validator:validate(kind, self.kinds[kind].schema, options)
    end,
    extendSchema = function( self, startWith, andModifyWith )
      assert(self.kinds[startWith] and self.kinds[startWith].schema, "Trying to extend an unregistered schema: " .. startWith )
      local initial = self.kinds[startWith].schema
      local schema = {}
      for k, v in pairs(initial) do
        schema[k] = v
      end
      for k, v in pairs(andModifyWith) do
        schema[k] = v
      end
      return schema
    end

  }

