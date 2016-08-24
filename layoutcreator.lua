local _NAME = ...
local _PACKAGE = _NAME:sub(1, -15) -- I should probably clean this up...

--[[
  assertion function - helps check that you pass the right things to various looky functions, to catch errors earlier
  @param typeTocheck: string; the type of variable that is expected ("string", "number", etc)
  @param value: any; the variable that will be checked against the typeToCheck
  @param fieldName: string; the name of the field in the calling function; to build a proper error message on failure
  @param extra: string; extra information that might be included in the error message, in case the fieldName itself is not clear enough
  
  @return nil
  @errors if value is not of typeToCheck
]]
local function assertArg(typeToCheck, value, fieldName, extra)
  if extra then
    extra = "(" .. extra .. ") "
  else
    extra = ""
  end
  assert(type(value) == typeToCheck, extra .. fieldName .. " should be a " .. typeToCheck .. ", got a: " .. type(value))  
end

--[[
  Default signaling implementation for container type views. 
  Will pass the given signal on to all children, while translating coordinates to their local coordinate system
  
  @param self: the LayoutCreator
  @param signal: string; the signal name
  @param payload: table; the payload passed with the signal
  @param coords: an array table of coordinates {x = number, y = number}; the coordinates that are relevant for this event, local to the view that sent this event
  
  @return nil
]]
local signalookyhildren = function(self, signal, payload, coords)
  for i, c in ipairs(self:getChildren()) do
    if c.visibility == "visible" then
      local newCoords = {}
      if coords then
        for i, v in ipairs(coords) do
          local x,y = self:translateCoordsToChild(c, v.x, v.y)
          table.insert(newCoords, { x = x, y = y })
        end
      end
      c:receiveOutsideSignal(signal, payload, newCoords)
    end
  end
end

--[[
  An image helper to handle some common modifications to images
  Used to layout both backgrounds and the default image view. 
  Do not call these methods repeatedly. Some of them create a canvas, which makes them fairly expensive.
  Can be accessed through looky.imageHelper  
]]
local imageHelper = {
  --[[
    Fit the image. Given a view, will scale the image while retaining the ratio.
    Ensures that the entire image fits in the view; will leave some room in the view if the view/image ratios  differ.
    
    @param view: a View; the view that is used to determine the image's size
    @param image: a Love Drawable; the image that will be drawn
    @return image: a Love Drawable; the image that will be drawn
    @return scale, scale: number; the X, Y scale factor to make the image fit (always the same due to ratio preserving)
  ]]
  fit = function(view, image)
    local scaledX = view:grantedWidth() / image:getWidth()
    local scaledY = view:grantedHeight() / image:getHeight()
    local scale = math.min(scaledX, scaledY)    
    return image, scale, scale
  end,        
  --[[
    Stretch the image. Given a view, will scale the image to fill up the whole view.
    Ensures that the entire view is filled up with the image, even if it means changing the ratio.
    
    @param view: a View; the view that is used to determine the image's size
    @param image: a Love Drawable; the image that will be drawn
    @return image: a Love Drawable; the image that will be drawn
    @return scale, scale: number; the X, Y scale factor to make the image fill the view
  ]]
  stretch = function(view, image)
    local scaleX = view:grantedWidth() / image:getWidth()
    local scaleY = view:grantedHeight() / image:getHeight()                 
    return image, scaleX, scaleY
  end,
  --[[
    Crop the image. Given a view, will scale the image to fill up the whole view without changing the ratio.
    Ensures that the entire view is filled up with the image, even if it means cutting away parts of the image.
    
    @param view: a View; the view that is used to determine the image's size
    @param image: a Love Drawable; the image that will be drawn
    @return canvas: a Canvas; the image that will be drawn
    @return scale, scale: number; the X, Y scale factor to make the image fill the view (always the same because of ratio preservation)
  ]]
  crop = function(view, image)
    love.graphics.setColor(255,255,255,255)
    local scaledX = view:grantedWidth() / image:getWidth()
    local scaledY = view:grantedHeight() / image:getHeight()
    local scale = math.max(scaledX, scaledY)
    local canvas = love.graphics.newCanvas(view:grantedWidth(), view:grantedHeight())
    love.graphics.setCanvas(canvas)
    love.graphics.push()
    love.graphics.origin()
    love.graphics.draw(image, 0, 0, 0, scale, scale)
    love.graphics.setCanvas()
    love.graphics.pop()
    return canvas, scale, scale
  end,
  --[[
    Fill the image. Given a view, will paste copies of the image at its original size until the entire view is filled.
    Ensures that the entire view is filled up copies of the image, even if it means cutting away parts of some.
    
    @param view: a View; the view that is used to determine the image's size
    @param image: a Love Drawable; the image that will be drawn
    @return canvas: a Canvas; many copies of the image that can be drawn    
  ]]
  fill = function(view, image)
    love.graphics.setColor(255,255,255,255)
    local canvas = love.graphics.newCanvas(view:grantedWidth(), view:grantedHeight())
    love.graphics.setCanvas(canvas)
    love.graphics.push()
    love.graphics.origin()
    local x, y = 0, 0
    while x < view:grantedWidth() do
      while y < view:grantedHeight() do
        love.graphics.draw(image, x, y)
        y = y + image:getHeight()
      end
      y = 0
      x = x + image:getWidth()
    end                      
    love.graphics.setCanvas()
    love.graphics.pop()
    return canvas
  end

}

--[[
  BaseLayout is an empty view that can be used as a scaffold to set up completely new viewtypes.
  NOTE: For the majority of your custom views, it is better to re-use one of the existing views.

  @param width: number or "fill" or "wrap"; the desired width of this view
  @param height: number or "fill" or "wrap"; the desired height of this view
]]
local function baseLayout(width, height)
  return {
    children = {},
    width = width,
    height = height,
    listeners = {},
    --[[
      @PUBLIC
      Allows adding a new listener to this view; any signals sent OUT by this view will reach the listener.
      
      @param listener: table; the table on which a method will be called
      @param method: string; the name of the function that should be called
    ]]
    addListener = function(self, listener, method)
      table.insert(self.listeners, { target = listener, method = method })
    end,
    --[[
      Add a child to this layout. Note that while all views get this method, not all of them do anything with it.
      Upon adding a child, the parent will automatically start listening to the child, using the default signal-handler.
      
      @param child: View; the view to add as a child of this one
      @param position: the position in which to put the child; defaults to "at the end"
      @param mute: boolean; pass true if you don't want to listen to this child's signals.
      
      @return nil
    ]]
    addChild = function(self, child, position, mute)
      assert(child, "No child was passed to addChild")
      position = position or #self.children+1
      table.insert(self.children, position, child)
      if not mute then
        child:addListener(self, "receiveChildSignal")
      end
    end,
    --[[
      Return how wide this view WANTS to be. There is no guarantee it will actually get this size.
      It is allowed to return "fill" if the view just wants as much space as it can get.
      
      @return number of "fill"; the size this view would like to have
    ]]
    desiredWidth = function(self)
      if self.visibility == "gone" then
        return 0
      end
      if self.width == "fill" then
        return "fill"
      elseif self.width == "wrap" then
        return self:contentWidthWithPadding()
      else
        return self.width
      end
    end,
    --[[
      Return how high this view WANTS to be. There is no guarantee it will actually get this size.
      It is allowed to return "fill" if the view just wants as much space as it can get.
      
      @return number of "fill"; the size this view would like to have
    ]]
    desiredHeight = function(self)
      if self.visibility == "gone" then
        return 0
      end
      if self:contentHeight() == "fill" then
        return self.height
      elseif self.height == "wrap" then
        return self:contentHeightWithPadding()
      else        
        return self.height
      end
    end,
    --[[
      Return how much width this view is actually granted. This is the hard limit to how much space the view is allowed to take up.
      
      @return number: the total width of this view
    ]]
    grantedWidth = function(self)
      return self.givenWidth
    end,
    --[[
      Return how much height this view is actually granted. This is the hard limit to how much space the view is allowed to take up.
      
      @return number: the total height of this view
    ]]
    grantedHeight = function(self)
      return self.givenHeight
    end,
    --[[
      Set the view's dimensions. This is used by the parent during a layoutingpass to set how large the view is allowed to be.
      It also resets the background to make sure it fits with the new dimensions
      
      @return nil
    ]]
    setDimensions = function(self, x, y)
      self.givenWidth = x
      self.givenHeight = y
      self:prepareBackground()
    end,
    --[[
      Returns the view's width minus its padding; this is the amount of room you should draw something useful in.
      
      @return number; the number of pixels of width you can draw in.
    ]]
    availableWidth = function(self)
      return self:grantedWidth() - self.padding.left - self.padding.right
    end,
    --[[
      Returns the view's height minus its padding; this is the amount of room you should draw something useful in.
      
      @return number; the number of pixels of height you can draw in.
    ]]
    availableHeight = function(self)
      return self:grantedHeight() - self.padding.top - self.padding.bottom
    end,
    --[[
      @MUST IMPLEMENT
      This method is called when the view is requested to re-layout its contents.
      Before this method is called, the view's dimensions will have been from outside. (ie; by the view's parent)
      In this method, the view should set the dimensions for its children and call this same method on them      
      
      @return nil
    ]]
    layoutingPass = function(self)
      
    end,
    --[[
      The core render function; this will render the view to the screen
      This method handles visibility, background and border and delegates to renderCustom which must be implemented by each view
      
      @return nil
    ]]
    render = function(self)
      if self.visibility == "visible" then
        self:renderBackground()
        self:renderCustom()
      end
    end,
    --[[
      @MUST IMPLEMENT
      This method does all the real work; it must draw the view's content to the screen.
      Never call this method on a child; call it's render function instead.
      
      @return nil
    ]]
    renderCustom = function(self)
      
    end,
    --[[
      @SHOULD IMPLEMENT
      This method is called when the view should update itself.
      Note that if the view contains any children it wants update, it will have to call them here!
      By default, update does not propagate to children, although all of the core views do this      
      
      @param dt: number; the number of seconds that passed since the last time this method was called
      
      @return nil
    ]]
    update = function(self, dt)
      
    end,
    --[[
      @MUST IMPLEMENT
      This method must return the width of the view's content in pixels
      It is used to determine the available drawing area and to figure out what a desired width of "wrap" should mean
      
      @return number; the width of the content that will be shown in this view
    ]]
    contentWidth = function(self)
      return 0
    end,
    --[[
      @MUST IMPLEMENT
      This method must return the height of the view's content in pixels
      It is used to determine the available drawing area and to figure out what a desired height of "wrap" should mean
      
      @return number; the height of the content that will be shown in this view
    ]]
    contentHeight = function(self)
      return 0
    end,
    --[[
      This method returns the total width of this view; content + padding
      
      @return number; total width of this element
    ]]
    contentWidthWithPadding = function(self)
      return self:contentWidth() + self.padding.left + self.padding.right
    end,
    --[[
      This method returns the total height of this view; content + padding
      
      @return number; total height of this element
    ]]
    contentHeightWithPadding = function(self)
      return self:contentHeight() + self.padding.top + self.padding.bottom
    end,
    --[[
      This method will render the background and border for the View.
      It is called before the custom render method so that the background/border are in place for all elements.
      Note that backgrounds are prepareda and redrawn, not recalookyulated on each call
      
      @return nil
    ]]
    renderBackground = function(self)
      if self.realBackground then
        if self.realBackground == "color" then
          love.graphics.setColor(self.background)
          local width = self:grantedWidth()
          local height = self:grantedHeight()
          love.graphics.rectangle("fill", 0, 0, width , height)
        else
          love.graphics.setColor(self.background.colorFilter)
          love.graphics.draw(self.realBackground, 0, 0, 0, self.scaleX, self.scaleY)
        end
      end      
      self:renderBorder()
    end,
    --[[
      This method overrides the currently set background with a new one.
      The background is prepared for rendering if it changed.
      
      @return nil
    ]]
    setBackground = function(self, background)
      if background ~= self.background then
        self.background = background
        self:prepareBackground()
      end
    end,
    --[[
      This method will prepare the background for drawing. 
      It is called automatically whenever the background or size of the view change.
      
      @return nil
    ]]
    prepareBackground = function(self)
      if self.background then
        if self.background.file then
          local helper = imageHelper
          local image = self.background.file
            
          self.realBackground, self.scaleX, self.scaleY = helper[self.background.fill](self, image )
        else
          self.realBackground = "color"
        end
      end
    end,
    --[[
      This method will draw a border around the view if there is one
      
      @return nil
    ]]
    renderBorder = function(self)
      if self.border.thickness > 0 then
        love.graphics.setColor(self.border.color)
        love.graphics.setLineWidth(self.border.thickness)
        local width = self:grantedWidth()
        local height = self:grantedHeight()
        love.graphics.rectangle("line", self.border.thickness/2, self.border.thickness/2, width - self.border.thickness, height - self.border.thickness)
        love.graphics.setLineWidth(1)
      end
    end,
    --[[
      This method determines where in the view the content should be drawn, based on the set gravity.
      This is relevant for views that are larger than their content.
      For example; when rendering some text in a large view, this method calookyulates exactly which x,y you should pass to love.graphics.print()
      
      @return x, y: number; the top-left coorindates where you should start drawing to fit the current content based on the gravity
    ]]
    startCoordsBasedOnGravity = function(self)
      local locX, locY
      if self.gravity[1] == "start" then
        locX = self.padding.left
      elseif self.gravity[1] == "end" then
        locX = self:grantedWidth() - self:contentWidth() - self.padding.left
      elseif self.gravity[1] == "center" then
        locX = (self:availableWidth() - self:contentWidth()) / 2 + self.padding.left
      end
      if self.gravity[2] == "start" then
        locY = self.padding.top
      elseif self.gravity[2] == "end" then
        locY = self:grantedHeight() - self:contentHeight() - self.padding.bottom
      elseif self.gravity[2] == "center" then
        locY = (self:availableHeight() - self:contentHeight()) / 2 + self.padding.top
      end
      return locX, locY
    end,
    --[[
      Get the child with the given order-number
      
      @param number: number; the child you want
      @return View or nil; that child if it exists
    ]]
    getChild = function(self, number)
      return self.children[number]
    end,
    --[[
      Return all the children of this view
      
      @return array of View
    ]]
    getChildren = function(self)
      return self.children
    end,
    --[[
      Remove a child from the view.
      
      @param target: number or View; if a number, the child with that number will be removed. If a View, that View will be removed
      
      @return View: the child that was removed
    ]]
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
    --[[
      Remove all children from the view.
      
      @return nil
    ]]
    removeAllookyhildren = function(self)
      self.children = {}
    end,
    --[[
      docs for signalookyhildren are with the function's definition at the top of this file
    ]]
    signalookyhildren = signalookyhildren,
    --[[
      This method is called by "the outside" when the view receives a signal.
      (Often this is done by the parent; but the view doesn't know it has one, so everything is treated as "the outside")
      This handler has a bunch of convenience options that allows view-implementers to quickly get the proper behavior.
      
      To add a new handler for a signal, it can be put in the externalSignalHandlers table on the view.
      The key will be the name of the signal. The value can be any of the following:
      - a function: that function will be called 
      - the string "o": the signal will be propagated to all outside listeners
      - the string "c": the signal will be propagated to all children
      - a number: the child with that number will receive the signal
      - a table: the receiveOutsideSignal method will be called on that table
      
      @param signal: string; the name of the signal
      @param payload: table; the payload sent with the signal
      @param coords: table of {x = number, y = number}; the coordinates sent with this signal, translated relatively to this view
      
      @return nil
    ]]
    receiveOutsideSignal = function(self, signal, payload, coords)
      local handler = self.externalSignalHandlers[signal]
      if not handler then
        handler = self.defaultExternalHandler
      end
      if handler then
        if type(handler) == "function" then
          self.externalSignalHandlers[signal](self, signal, payload, coords)
        elseif type(handler) == "string" then
          if handler == "o" then
            self.messageOut(self, signal, payload, coords)
          elseif handler == "c" then
            self.signalookyhildren(self, signal, payload, coords)
          else
            error( "Only 'o' and 'c' are accepted as string based handler, but got: " .. handler )
          end
        elseif type(handler) == "number" then
          self.getChildren()[handler]:receiveOutsideSignal(signal, payload, coords)
        elseif type(handler) == "table" then
          handler:receiveOutsideSignal(signal, payload, coords)        
        end    
      end
    end,
    --[[
      This method is called by one of the view's children that has created a signal      
      This handler has a bunch of convenience options that allows view-implementers to quickly get the proper behavior.
      
      To add a new handler for a child signal, it can be put in the childSignalHandlers table on the view.
      The key will be the name of the signal. The value can be any of the following:
      - a function: that function will be called 
      - the string "o": the signal will be propagated to all outside listeners
      - the string "c": the signal will be propagated to all children
      - a number: the child with that number will receive the signal
      - a table: the receiveOutsideSignal method will be called on that table

      
      @param signal: string; the name of the signal
      @param payload: table; the payload sent with the signal
      @param coords: table of {x = number, y = number}; the coordinates sent with this signal, translated relatively to this view
      
      @return nil
    ]]
    receiveChildSignal = function(self, signal, payload, coords)
      local handler = self.childSignalHandlers[signal]
      if not handler then
        handler = self.defaultChildHandler
      end
      if handler then
        if type(handler) == "function" then
          self.childSignalHandlers[signal](self, signal, payload, coords)
        elseif type(handler) == "string" then
          if handler == "o" then
            self.messageOut(self, signal, payload)
          elseif handler == "c" then
            self.signalookyhildren(self, signal, payload, coords)
          else
            error( "Only 'o' and 'c' are accepted as string based handler, but got: " .. handler )
          end
        elseif type(handler) == "number" then
          self.getChildren()[handler]:receiveOutsideSignal(signal, payload, coords)
        elseif type(handler) == "table" then
          handler:receiveOutsideSignal(signal, payload, coords)        
        end
      end      
    end,
    --[[
      This will hold all the external signals that this view handles. See receiveOutsideSignal, above, for what goes in here.
    ]]
    externalSignalHandlers = {},
    --[[
      This will hold all the child signals that this view handles. See receiveChildSignal, above, for what goes in here.
    ]]
    childSignalHandlers = {},
    --[[
      This is the default handler for any external signal that is not explictly handled above.
      Can be set to nil if you want to ignore any unhandled signals.
      Defaults to "pass the external event down to all my children"
    ]]
    defaultExternalHandler = "c",
    --[[
      This is the default handler for any child signal that is not explictly handled above.
      Can be set to nil if you want to ignore any unhandled signals.
      Defaults to "pass on the child event to anyone listening to me"
    ]]    
    defaultChildHandler = "o",
    --[[
      This method allows sending a signal to everything listening to the View
      
      @param signal: string; the name of this signal
      @param payload: table; the payload attached to this signal
      
      @return nil
    ]]
    messageOut = function(self, signal, payload)
      for i, listener in ipairs(self.listeners) do
        if not listener.target[listener.method] then
          print("Could not find method " .. method .. " of listener " )
        end
        listener.target[listener.method](listener.target, signal, payload)
      end
    end,
    --[[
      @MUST IMPLEMENT
      This method translates the given coordinates to the local coordinate system of the given child.
      Each child's local system has it's own top-left corner at 0,0 and its bottom right corner at width,height
      
      @param child: View; the child that these coords should be translated to
      @param x,y: number; the coordinates in question
      
      @return x,y: number; the coordinates in the child-local system
    ]]
    translateCoordsToChild = function(self, child, x, y) 
      return x, y
    end,
    --[[
      @MUST IMPLEMENT
      This method translates the given child-local coordinates to the local coordinate system of this view
            
      param child: View; the child that these coords should be translated from
      param x,y: number; the coordinates in our local system
    ]]
    translateCoordsFromChild = function(self, child, x, y)
      return x, y
    end,
    --[[
      This methods determines whether or not a set of coordinates should be considered as "within me"
      The default implementation assumes that anything within the boundaries of the views counts, but this is not required.
      (For example, a button might call this method to determine if a click hit it; a round button might then override this function to change its hitbox)
      Coordinates are local to the view.
      
      @param x,y: number; the coordinates that are being checked
      
      @return boolean; whether this should be considered "hitting the view"
    ]]
    coordsInMe = function(self, x, y)
       return x > 0 and x < self:grantedWidth() and y > 0 and y < self:grantedHeight()
    end
  }
end

--[[
  This function allows a number of shortcuts for defining paddings on views. (It is here because it is self-referential)
  It can be passed up to 4 arguments, whose meaning and type differs based on how many there are
  Options supported:
  
  - a single table: will copy the fields "left", "top", "right", "bottom" into their respective paddings and sets the rest to 0
    EX: paddingHelper({ top = 50, bottom = 20}) -> { top = 50, bottom = 20, left = 0, right = 0 }
  - a single number: will use that number for all paddings
    EX: paddingHelper(5) -> { top = 5, bottom = 5, left = 5, right = 5 }
  - two numbers: will use the first number for left/right and the second for top/bottom
    EX: paddingHelper(5, 10) -> { top = 10, bottom = 10, left = 5, right = 5 }
  - four numbers: will assign the numbers in order: left, top, right, bottom
    EX: paddingHelper(5, 10, 15, 20) -> { left = 5, top = 10, right = 15, bottom = 20 }

  @return table: { left = number, top = number, right = number, bottom = number }
]]
paddingHelper = function(left, top, right, bottom)
  assert( not (type(left) == "table" and top ~= nil), "Cannot pass both a table and other values to padding/margin. Did you accidentally call it as a method (ie looky:padding(10)) ?" )
  if left == nil and top == nil and right == nil and bottom == nil then
    return paddingHelper(0,0,0,0)
  elseif top == nil and right == nil and bottom == nil then
    if type(left) == "table" then
      return paddingHelper(left.left or 0, left.top or 0, left.right or 0, left.bottom or 0)
    else
      return paddingHelper(left,left,left,left)
    end
  elseif right == nil and bottom == nil then
    return paddingHelper(left,top,left,top)  
  else
    return {
      left = left,
      top = top,
      right = right,
      bottom = bottom
    }
  end
end
  
--[[
  Factory function to create a new, empty LayoutCreator
  Will not contain any type of views except for 'base' and no fonts except for 'base'
  
  @return LayoutCreator
]]
return function()
  --[[
    The main object for this library. You use this to register and build your Views.
  ]]
  local looky = {
    --[[
      Kinds holds all the different Views registered to the system.
      By default, only contains "base" which cannot be built, but can be intantiated using the special *createBaseLayout* function.
    ]]
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
          background = { required = false, schemaType = "oneOf", possibilities = {
            { schemaType = "color" },
            { schemaType = "table", options = {
                file = { required = true, schemaType = "oneOf" , possibilities = {
                    { schemaType = "string" },
                    { schemaType = "image" }
                }},
                fill = { required = true, schemaType = "fromList", list = { "fit", "stretch", "crop", "fill" }},
                colorFilter = { required = false, schemaType = "color" }
              }
            }
          }},
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
          externalSignalHandlers = {
            required = false,
            schemaType = "table",
            options = {},
            allowOther = true
          },
          childSignalHandlers = {
            required = false,
            schemaType = "table",
            options = {},
            allowOther = true
          }          
        }
      }
    },
    --[[
      Fonts contains all the fonts registered to the looky. 
      By default, contains only "base", which is löve's default font
    ]]
    fonts = {
      base = love.graphics.newFont()
    },
    --[[
      Initializes a Validator to check schemas. 
      You will not interact with this directly.
      By default, Validator will contain all the basic validation rules.
      You can register more through looky's own registerValidator function.
    ]]      
    validator = require ( _PACKAGE .. "/validation/validator" )(),
    --[[
      Requests looky to build a new view. Will validate the options passed before building.
      
      @param kind: string; the name of the view you want built.
      @param options: table; the options that should be passed to the view. These will be checked against the Schema defined for the view.
      
      @return View; the requested view
      @throws if the kind is unknown or the options do not pass schema validation
    ]]
    build = function( self, kind, options )
      options = options or {}
      assert(self.kinds[kind], "Requesting layout " .. kind .. ", but I do not have it")            
      self:validate(kind, options)
      return self.kinds[kind].build(options)
    end,
    --[[
      Register a new type of buildable layout. After registering, you can build() it.
      
      @param name: string; the name of this kind of view that needs to be passed to build to create it
      @param layoutTable: table; a table that contains at least a build method (that will build a new instance of the view) and a schema table that defines the View's schema
      
      @return nil
    ]]
    registerLayout = function( self, name, layoutTable )
      assertArg("string", name, "Name" )
      assertArg("table", layoutTable, "layoutTable", name )
      assertArg("function", layoutTable.build, "layoutTable.build", name )
      assertArg("table", layoutTable.schema, "layoutTable.schema", name )      
      assert(not self.kinds[name], "A layout named " .. name .. " was previously registered")
      
      self.kinds[name] = layoutTable
    end,
    --[[
      Registers a new type of font that can be used by views.
      
      @param name: string; the name of this font
      @param font: Font; a font created by love.graphics.newFont or similar method
      
      @return nil
    ]]
    registerFont = function( self, name, font )
      assertArg("string", name, "Name")
      assertArg("userdata", font, "Font", name)
      assert(not self.fonts[name], "A font named " .. name .. " was previously registered")
      self.fonts[name] = font
    end,
    --[[
      Recovers a font that was previously registered.
      
      @param name: string; the name of the font you want
      
      @return Font; the requested Font
    ]]
    getFont = function( self, name )
      assert(self.fonts[name], "Requesting font " ..  name .. ", but I do not have it")
      return self.fonts[name]
    end,
    --[[
      see documentation for paddingHelper function, above
    ]]
    padding = function(left, top, right, bottom)
      return paddingHelper(left, top, right, bottom)
    end,
    --[[
      see documentation for imageHelper function, above
    ]]
    imageHelper = imageHelper,
    --[[
      Special function that can be used by views to create an empty stub of a view.
      This is the starting point for any View that cannot be based on a working, existing view.
      You probably won't need it.
      
      @param options: Table; the default options for this new view. Follows the Base schema.
      
      @return View; a View stub
    ]]
    makeBaseLayout = function(self, options)
      local start = baseLayout(options.width, options.height)      
      start.padding = self.padding(options.padding)      
      start.background = options.background
      start.border = options.border or { color = { 0, 0, 0, 0 }, thickness = 0 }
      start.gravity = options.gravity or {"start","start"}
      start.weight = options.weight or 1
      start.visibility = options.visibility or "visible"
      start.signalHandlers = options.signalHandlers or {}
      
      -- if background is a filename, load it now
      if start.background and start.background.file and type(start.background.file) == "string" then
        start.background.file = love.graphics.newImage(start.background.file)
      end
      if start.background and start.background.file and not start.background.colorFilter then
        start.background.colorFilter = { 255, 255, 255, 255 }
      end
      return start
    end,
    --[[
      Helper function. Merges two sets of options, with the second param taking precedence over the first.
      
      @param baseOptions: Table; the first set of options
      @param options: Table; the second set of options
      
      @return Table; the merged options, added to the baseOptions table
    ]]
    mergeOptions = function (baseOptions, options)
      for k, v in pairs(options) do
        baseOptions[k] = v
      end
      return baseOptions   
    end,
    --[[
      Validates the given options against the schema of the given kind.
      Throws an error if the options do not pass the validation.
      
      @param kind: string; the name of the schema to validate against
      @param options: table; the options you wish to validate
      
      @return nil
      @throws if the options do not fit the required schema
    ]]
    validate = function(self, kind, options)
      self.validator:validate(kind, self.kinds[kind].schema, options)
    end,    
    --[[
      Registers a new validator.
      If you pass a function, it will register a new validation function that will be called when you use that name.
      If you pass a table (which is a schema itself), then when you use the name it will as a type, it will replace it with the schema.
      
      @param name: string; the name you will reference this by in your schemas
      @param validator: function or table; what should be checked when you use this schemaType
      
      @return nil
    ]]
    registerValidator = function(self, name, validator)
      if type(validator) == "function" then
        self.validator:addSchemaType(name, validator)
      else
        self.validator:addPartialSchema(name, validator)
      end
    end,
    --[[
      Extend a schema, by taking all the options of the first and then adding the modification options to them.
      Does not register the schema; only returns it.
      SPECIAL: if you pass an option from the base schema with the value FALSE, it will be removed from the baseSchema
      
      @param startWith: string; the name of the schema to use as a base
      @param andModifyWith: table; the entries that need to be modified. Will overwrite any matching keys in base.
    ]]
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
    --[[
      Get a copy of an existing schema
      
      @param name: string; the schema you want
      
      @return Table; a copy of the requested schema
    ]]
    getSchema = function(self, name)
      assert(self.kinds[name] and self.kinds[name].schema, "Trying to get an unregistered schema: " .. name )
      local initial = self.kinds[name].schema
      local schema = {}
      for k, v in pairs(initial) do
        schema[k] = v
      end
      return schema
    end,
    --[[
      @Deprecated
      Helper method. Removes any keys from the passed t that aren't in the schema.
      Only operates on top-level; doesn't validate values.
      
      @param schema: string; the name of the schema you want to conform to
      @param t: Table; a table that you want to conform to the schema
      
      @return Table; a new table containing only keys from t that exist in the schema
    ]]
    conformToSchema = function( self, schema, t )
      local schema = self:getSchema(schema)
      local output = {}
      for k, v in pairs(schema) do
        output[k] = t[k]
      end
      return output
    end,
  }
  --[[
    Register a new layout that is simply an existing layout with some options prefilled.
    Used to generate your own styles, and to make extending views easier.
    
    @param newName: string; the name by which the styled layout will be known
    @param oldName: string; the old view you're using as a base
    @param defaultOptions: Table; the options that are passed to the old view to style it
  ]]
  looky.registerStyledLayout = function( self, newName, oldName, defaultOptions  )
    local schema = looky:extendSchema(oldName, {})
    for key, value in pairs(schema) do
      if defaultOptions[key] ~= nil then
        schema[key].required = false
      end
    end    
    local layout = {
      build = function(options)
        -- need to merge defaultOptions and options before building.
        for k, v in pairs(defaultOptions) do
          if options[k] == nil then
            options[k] = v
          end
        end
        
        return looky:build(oldName, options)
      end,
      schema = schema
    }
    looky:registerLayout(newName, layout)
  end  
  --[[
    Wrap a bunch of views into each other. 
    Useful if you have views that extend a single view with some extra decoration.
    (For example, when wrapping a content view in a dragbox or filler)
    
    @param ..., Tables; a list of views that need to be wrapped. 
    @return the Nth View passed, which will contain the N-1th View as a child, which will contain the N-2th View as a child, etc.
  ]]
  looky.wrap = function( self, ... )        
    args = {...}
    local prev = nil
    for _, view in ipairs(args) do
      if prev then
        view:addChild(prev)
      end
      prev = view
    end
    return prev -- view is not in scope anymore
  end
  return looky
end