local _NAME = ...
local _PACKAGE = _NAME:sub(1, -15) -- I should probably clean this up...

local function assertArg(typeToCheck, value, fieldName, extra)
  if extra then
    extra = "(" .. extra .. ") "
  else
    extra = ""
  end
  assert(type(value) == typeToCheck, extra .. fieldName .. " should be a " .. typeToCheck .. ", got a: " .. type(value))  
end

local signalChildren = function(self, signal, payload)  
    for i, c in ipairs(self:getChildren()) do
      c:receiveSignal(signal, payload)
    end
end

local function baseLayout(width, height)
  return {
    children = {},
    width = width,
    height = height,
    outside = {},
    addChild = function(self, child, position)
      assert(child, "No child was passed to addChild")
      local position = position or #self.children+1
      table.insert(self.children, position, child)
      table.insert(child.outside, self)
    end,
    desiredWidth = function(self)
      if self.visibility == "gone" then
        return 0
      end
      if self.width == "fill" then
        return self.width
      elseif self.width == "wrap" then
        return self:contentWidthWithPadding()
      else
        return self.width
      end
    end,
    desiredHeight = function(self)
      if self.visibility == "gone" then
        return 0
      end
      if self.height == "fill" then
        return self.height
      elseif self.height == "wrap" then
        return self:contentHeightWithPadding()
      else        
        return self.height
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
      return self:grantedWidth() - self.padding.left - self.padding.right
    end,
    availableHeight = function(self)
      return self:grantedHeight() - self.padding.top - self.padding.bottom
    end,
    layoutingPass = function(self)
      
    end,
    render = function(self)
      if self.visibility == "visible" then
        self:renderBackground()
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
      local width = self:grantedWidth()
      local height = self:grantedHeight()
      love.graphics.rectangle("fill", 0, 0, width, height)
      self:renderBorder()
    end,
    renderBorder = function(self)
      love.graphics.setColor(self.border.color)
      love.graphics.setLineWidth(self.border.thickness)
      local width = self:grantedWidth()
      local height = self:grantedHeight()
      love.graphics.rectangle("line", self.border.thickness/2, self.border.thickness/2, width - self.border.thickness, height - self.border.thickness)
      love.graphics.setLineWidth(1)
    end,
    startCoordsBasedOnGravity = function(self)
      local locX, locY
      if self.gravity[1] == "start" then
        locX = self.padding.left
      elseif self.gravity[1] == "end" then
        locX = self:grantedWidth() - self:contentWidth() - self.padding.left
      elseif self.gravity[1] == "center" then
        locX = (self:availableWidth() - self:contentWidth()) / 2
      end
      if self.gravity[2] == "start" then
        locY = self.padding.top
      elseif self.gravity[2] == "end" then
        locY = self:grantedHeight() - self:contentHeight() - self.padding.bottom
      elseif self.gravity[2] == "center" then
        locY = (self:availableHeight() - self:contentHeight()) / 2 
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
        local view = self.children[target]
        table.remove(self.children, target)
        return view
      else
        for k, v in ipairs(self.children) do
          if v == target then
            table.remove(self.children, k)
            return target
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
    end,
    signalChildren = signalChildren,
    receiveSignal = function(self, signal, payload)
      local handler = self.signalHandlers[signal]
      if handler then
        if type(handler) == "function" then
          self.signalHandlers[signal](self, signal, payload)
        elseif type(handler) == "string" then
          if handler == "o" then
            self.messageOut(self, signal, payload)
          elseif handler == "c" then
            self.signalChildren(self, signal, payload)
          else
            error( "Only 'o' and 'c' are accepted as string based handler, but got: " .. handler )
          end
        elseif type(handler) == "number" then
          self.getChildren()[handler]:receiveSignal(signal, payload)
        elseif type(handler) == "table" then
          handler:receiveSignal(signal, payload)        
        end
      else
        if self.defaultHandler then
          self.defaultHandler(self, signal, payload)
        end
      end
    end,
    signalHandlers = {},
    defaultHandler = nil,
    messageOut = function(self, signal, payload)
      for i, o in ipairs(self.outside) do
        o:receiveSignal(signal, payload)
      end
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
  
return function()
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
          visibility = { required = false, schemaType = "fromList", list = { "visible", "cloaked", "gone" } },
          signalHandlers = {
            required = false,
            schemaType = "dict",
            keyValidator = { schemaType = "string" },
            valueValidator = { schemaType = "oneOf", possibilities = {
              { schemaType = "function" },
              { schemaType = "fromList", list = { "o", "c" } },
              { schemaType = "number" },
              { schemaType = "table" },
            }},
          }
        }
      }
    },

    fonts = {
      base = love.graphics.newFont()
    },
    validator = require ( _PACKAGE .. "/validation/validator" )(),
    build = function( self, kind, options )
      assert(self.kinds[kind], "Requesting layout " .. kind .. ", but I do not have it")      
      local base = self:makeBaseLayout(options)
      self:validate(kind, options)
      return self.kinds[kind].build(base, options)
    end,
    registerLayout = function( self, name, layoutTable )
      assertArg("string", name, "Name" )
      assertArg("table", layoutTable, "layoutTable", name )
      assertArg("function", layoutTable.build, "layoutTable.build", name )
      assertArg("table", layoutTable.schema, "layoutTable.schema", name )      
      assert(not self.kinds[name], "A layout named " .. name .. " was previously registered")
      
      self.kinds[name] = layoutTable
    end,
    registerFont = function( self, name, font )
      assertArg("string", name, "Name")
      assertArg("userdata", font, "Font", name)
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
    makeBaseLayout = function(self, options)
      local start = baseLayout(options.width, options.height)      
      start.padding = self.padding(options.padding)      
      start.backgroundColor = options.backgroundColor or {0,0,0,0}
      start.border = options.border or { color = { 0, 0, 0, 0 }, thickness = 0 }
      start.layoutGravity = options.layoutGravity or "start"
      start.gravity = options.gravity or {"start","start"}
      start.weight = options.weight or 1
      start.visibility = options.visibility or "visible"
      start.signalHandlers = options.signalHandlers or {}
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
    registerValidator = function(self, name, validator)
      if type(validator) == "function" then
        self.validator:addSchemaType(name, validator)
      else
        self.validator:addPartialSchema(name, validator)
      end
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
    end,
    getSchema = function(self, startWith)
      assert(self.kinds[startWith] and self.kinds[startWith].schema, "Trying to get an unregistered schema: " .. startWith )
      local initial = self.kinds[startWith].schema
      local schema = {}
      for k, v in pairs(initial) do
        schema[k] = v
      end
      return schema
    end,    
  }
end