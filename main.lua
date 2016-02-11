function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  font = love.graphics.newFont()
  
  root = newRoot()
  
  lc = layoutCreator()
  lc:register("linear", linearLayout)
  lc:register("text", textLayout)
  lc:register("image", imageLayout)  
  lc:register("caption", captionLayout )
  lc:register("list", listLayout )
  
  layout = lc:build("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, marginRight = 20, marginLeft = 20, direction = "v"})
  root:addChild(layout)
  
  caption = lc:build("caption", {width="wrap", height = "wrap", text = "this is a caption", file="test.png"})
  root:addChild(caption)
  
  list = lc:build("list", {width="wrap", height="fill", texts = { "derp", "merp", "lots of merp" }, textOptions = { paddingTop = 15, backgroundColor = {255,255,255,255}}})
  root:addChild(list)
  
  layout3 = lc:build("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, marginRight = 20, marginLeft = 20, direction = "v"})
  root:addChild(layout3)
  
  
  imageLayout = lc:build("image", {width = "wrap", height = "wrap", backgroundColor = {0, 0, 255, 200}, file = "test.png", marginLeft = 25, marginTop = 30, paddingLeft = 25, paddingTop = 25, paddingRight = 10, paddingBottom = 5 })
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)


  layout4 = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {255, 255, 0, 200}, paddingLeft = 50, paddingBottom = 200, paddingTop = 25})
  root:addChild(layout4)

  layout:addChild( lc:build("text", {width = "fill", height = 100, text = "list 1", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
  layout:addChild( lc:build("text", {width = "wrap", height = 100, text = "list 2", textColor = {255,0,0,255}, backgroundColor = {255,255,255,255}, paddingLeft = 5, paddingTop = 5, layoutGravity = "right"}) )
  
  layout:addChild( lc:build("text", {width = "fill", height = 100, text = "list 3", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  layout:addChild( lc:build("text", {width = "fill", height = 100, text = "list 4", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
  subContainer = lc:build("linear", {width = "fill", height = "fill", backgroundColor = {200,250,20,150}, direction = "h"})
  layout:addChild( subContainer )
  
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( lc:build("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
  root:layoutingPass()
end

function love.update(dt)
  
end

function love.draw()
  root:render()
end

function newRoot()
  return {
    children = {},
    addChild = function(self, child)
      table.insert(self.children, child)
      child:setParent(self)
    end,
    desiredWidth = function(self)
      return love.graphics.getWidth()
    end,
    desiredHeight = function(self)
      return love.graphics.getHeight()
    end,
    grantedWidth = function(self)
      return love.graphics.getWidth()
    end,
    grantedHeight = function(self)
      return love.graphics.getHeight()
    end,
    availableWidth = function(self)
      return love.graphics.getWidth()
    end,
    availableHeight = function(self)
      return love.graphics.getHeight()
    end,
    layoutingPass = function(self)
      horizontalLayout(self, self.children)      
    end,
    render = function(self)
      local offset = 0
      
      for k, v in ipairs(self.children) do
        love.graphics.push()
        love.graphics.translate(offset, 0)
        offset = offset + v:grantedWidth()
          
        v:render()
        
        love.graphics.pop()
      end      
    end  
  }
end

renderBackground = function(self)
  love.graphics.setColor(self.backgroundColor)
  local width = self:grantedWidth() - (self.marginLeft + self.marginRight)
  local height = self:grantedHeight() - (self.marginTop + self.marginBottom)
  love.graphics.rectangle("fill", self.marginLeft, self.marginTop, width, height)    
end

renderText = function(self)
  renderBackground(self)
  
  love.graphics.setColor(self.textColor or {255,255,255,255})
  love.graphics.print(self.text,self.paddingLeft,self.paddingTop)

end

renderImage = function(self)
  renderBackground(self)
  
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.image, self.marginLeft + self.paddingLeft, self.marginTop + self.paddingTop)
end

renderChildren = function(self) 
  renderBackground(self)

  local offset = 0
  if self.direction == "h" then
    offset = self.marginTop
  else
    offset = self.marginLeft
  end
  
  for k, v in ipairs(self.children) do
    love.graphics.push()
    if self.direction == "v" then 
      love.graphics.translate(self.marginLeft, offset)
      offset = offset + v:grantedHeight()
      if v.layoutGravity == "right" then
        love.graphics.translate( self:availableWidth() - v:grantedWidth() , 0 )
      elseif v.layoutGravity == "center" then
        love.graphics.translate( (self:availableWidth() - v:grantedWidth()) /2 , 0 )
      end
    else
      love.graphics.translate(offset, self.marginTop)
      offset = offset + v:grantedWidth()
    end
    
    
    v:render()
    
    love.graphics.pop()
  end
end

function layoutCreator()
  return {
    kinds = {},
    build = function( self, kind, options )      
      assert(self.kinds[kind], "Requesting layout " .. kind .. ", but I do not have it")
      local base = self:makeBaseLayout(options)
      return self.kinds[kind](base, options)
    end,
    register = function( self, name, fn )
      assert(not self.kinds[name], "A layout named " .. name .. " was previously registered")
      self.kinds[name] = fn
    end,
    makeBaseLayout = function(self, options)
      local start = baseLayout(options.width, options.height)
      start.paddingLeft = options.paddingLeft or 0
      start.paddingTop = options.paddingTop or 0
      start.paddingRight = options.paddingRight or 0
      start.paddingBottom = options.paddingBottom or 0
      start.marginLeft = options.marginLeft or 0
      start.marginTop = options.marginTop or 0
      start.marginRight = options.marginRight or 0
      start.marginBottom = options.marginBottom or 0
      start.backgroundColor = options.backgroundColor or {0,0,0,0}
      start.layoutGravity = options.layoutGravity or "left"
      start.gravity = options.gravity or "left"
      return start
    end
  }
end

function linearLayout(base, options)
  base.render = renderChildren
  base.direction = options.direction or "v"
  if base.direction == "v" then
    base.layoutingPass = function(self) verticalLayout(self, self.children) end  
  else
    base.layoutingPass = function(self) horizontalLayout(self, self.children) end  
  end
  base.contentWidth = containerWidth
  base.contentHeight = containerHeight
  return base
end

function textLayout(base, options)  
  base.render = renderText
  base.text = options.text
  base.textColor = options.textColor or {255,255,255,255}
  base.contentWidth = textWidth
  base.contentHeight = textHeight  
  return base
end

function imageLayout(base, options)
  base.render = renderImage
  base.image = love.graphics.newImage(options.file)
  base.contentWidth = imageWidth
  base.contentHeight = imageHeight  
  return base
end

function captionLayout(base, options)
  local container = lc:build("linear", {direction = "v", width = options.width, height = options.height, backgroundColor = {0,0,255,255}})  
  container:addChild( lc:build( "image", {file = options.file, width="wrap", height="wrap", layoutGravity = "center" } ))
  container:addChild( lc:build( "text", {text = options.text, width="wrap", height="wrap", backgroundColor = {255,0,0,255}, textColor={0,255,0,255}, paddingLeft = 5, paddingRight = 5, paddingTop = 5, paddingBottom = 5}) )
  return container
end

function listLayout(base, options)
  local container = lc:build("linear", {direction = "v", width = options.width, height = options.height, backgroundColor = {0,0,255,255}})  
  
  local base = {width="wrap", height="wrap", backgroundColor = {255,0,0,255}, textColor={0,255,0,255}}
  local merged = mergeOptions(base, options.textOptions or {})
  
  for k, v in ipairs( options.texts ) do
    local toPass = merged
    toPass.text = v
    container:addChild( lc:build( "text", toPass) )
  end
  return container
end

function mergeOptions(baseOptions, options)
  for k, v in pairs(options) do
    baseOptions[k] = v
  end
  return baseOptions
end

function baseLayout(width, height)
  return {
    children = {},
    parent = nil,
    width = width,
    height = height,
    givenWidth = 0,
    givenHeight = 0,
    paddingLeft = 0,
    paddingRight = 0,
    paddingTop = 0,
    paddingBottom = 0,
    marginLeft = 0,
    marginRight = 0,
    marginTop = 0,
    marginBottom = 0,
    layoutGravity = "left",
    gravity = "left",
    addChild = function(self, child)
      table.insert(self.children, child)
      child:setParent(self)
    end,
    setParent = function(self, parent)
      self.parent = parent
    end,
    desiredWidth = function(self)
      if self.width == "fill" then
        return self.width
      elseif self.width == "wrap" then
        local content = self:contentWidth()
        if content == "fill" then
          return content
        else
          return content + self.marginLeft + self.marginRight
        end
      else
        return self.width + self.marginLeft + self.marginRight
      end
    end,
    desiredHeight = function(self)
      if self.height == "fill" then
        return self.height
      elseif self.height == "wrap" then
        local content = self:contentHeight()
        if content == "fill" then
          return content
        else
          return content + self.marginTop + self.marginBottom
        end
      else        
        return self.height + self.marginTop + self.marginBottom
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
      return self:grantedWidth() - self.marginLeft - self.marginRight
    end,
    availableHeight = function(self)
      return self:grantedHeight() - self.marginTop - self.marginBottom
    end,
    layoutingPass = function(self)
      
    end,
    render = function(self)
    
    end,
    contentWidth = function(self)
      return 0
    end,
    contentHeight = function(self)
      return 0
    end
  }
end

horizontalLayout = function(parent, children)
  local availableSize = parent:availableWidth()
  local fills = {}
  for k, v in ipairs(children) do
    if v:desiredWidth() == "fill" then
      table.insert(fills, v)
    else
      local height = v:desiredHeight()
      if height == "fill" then
        height = parent:availableHeight()
      end
      if v:desiredWidth() < availableSize then
        availableSize = availableSize - v:desiredWidth()            
        v:setDimensions(v:desiredWidth(), height)
      else
        v:setDimensions(availableSize, height)
        availableSize = 0
      end
    end
  end
  if availableSize > 0 then
    for k, v in ipairs(fills) do
      local height = v:desiredHeight()
      if height == "fill" then
        height = parent:grantedHeight()
      end
      v:setDimensions(availableSize / #fills, height)
    end
  end
  
  for k, v in ipairs(children) do    
    v:layoutingPass()
  end
end

verticalLayout = function(parent, children)
  local availableSize = parent:availableHeight()
  local fills = {}
  for k, v in ipairs(children) do
    if v:desiredHeight() == "fill" then
      table.insert(fills, v)
    else
      local width = v:desiredWidth()
      if width == "fill" then
        width = parent:availableWidth()
      end
      if v:desiredHeight() < availableSize then
        availableSize = availableSize - v:desiredHeight()            
        v:setDimensions(width, v:desiredHeight())
      else
        v:setDimensions(width, availableSize)
        availableSize = 0
      end
    end
  end
  if availableSize > 0 then
    for k, v in ipairs(fills) do
      local width = v:desiredWidth()
      if width == "fill" then
        width = parent:availableWidth()
      end
      v:setDimensions(width, availableSize / #fills)
    end
  end
  
  for k, v in ipairs(children) do    
    v:layoutingPass()
  end
end

function textWidth(self)
  return font:getWidth(self.text) + self.paddingLeft + self.paddingRight
end

function textHeight(self)
  return font:getHeight() + self.paddingTop + self.paddingBottom
end

function imageWidth(self)
  return self.image:getWidth() + self.paddingLeft + self.paddingRight
end

function imageHeight(self)
  return self.image:getHeight() + self.paddingTop + self.paddingBottom
end

function containerWidth(self)  
  -- todo: either max or sum based on direction
  local width = 0
  for k, v in ipairs(self.children) do
    if v:desiredWidth() == "fill" then
      return "fill"
    else
      if self.direction == "v" then
        if v:desiredWidth() > width then
          width = v:desiredWidth()
        end
      else
        width = width + v:desiredWidth()
      end
    end
  end
  return width
end

function containerHeight(self)
  -- todo: either max or sum based on direction
  local height = 0
  for k, v in ipairs(self.children) do
    if v:desiredHeight() == "fill" then
      return "fill"
    else
      if self.direction == "v" then
        height = height + v:desiredHeight()
      else
        if v:desiredHeight() > height then
          height = v:desiredHeight()
        end
      end
    end
  end
  return height
end