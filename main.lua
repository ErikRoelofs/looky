function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  root = newRoot()
  
  layout = buildLayout("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, marginRight = 20, marginLeft = 20, direction = "v"})
  root:addChild(layout)
  
  layout2 = buildLayout("text", {width = 150, height = "fill", text = "this is a text item", textColor = {255,0,0,255}, paddingLeft = 10, paddingTop = 10})
  root:addChild(layout2)
  
  layout3 = buildLayout("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, marginRight = 20, marginLeft = 20, direction = "v"})
  root:addChild(layout3)
  
  
  imageLayout = buildLayout("image", {width = "wrap", height = "wrap", backgroundColor = {0, 0, 255, 200}, file = "test.png", marginLeft = 25, marginTop = 30, paddingLeft = 25, paddingTop = 25 })
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)
  layout3:addChild(imageLayout)


  layout4 = buildLayout("linear", {width = "fill", height = "fill", backgroundColor = {255, 255, 0, 200}, paddingLeft = 50, paddingBottom = 200, paddingTop = 25})
  root:addChild(layout4)

  layout:addChild( buildLayout("text", {width = "fill", height = 100, text = "list 1", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  layout:addChild( buildLayout("text", {width = "fill", height = 100, text = "list 2", textColor = {255,0,0,255}, backgroundColor = {255,255,255,255}, paddingLeft = 5, paddingTop = 5}) )
  layout:addChild( buildLayout("text", {width = "fill", height = 100, text = "list 3", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  layout:addChild( buildLayout("text", {width = "fill", height = 100, text = "list 4", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
  subContainer = buildLayout("linear", {width = "fill", height = "fill", backgroundColor = {200,250,20,150}, direction = "h"})
  layout:addChild( subContainer )
  
  subContainer:addChild( buildLayout("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( buildLayout("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( buildLayout("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  subContainer:addChild( buildLayout("text", {width = "fill", height = 100, text = "check", textColor = {255,0,0,255}, paddingLeft = 5, paddingTop = 5}) )
  
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
    else
      love.graphics.translate(offset, self.marginTop)
      offset = offset + v:grantedWidth()
    end
      
    v:render()
    
    love.graphics.pop()
  end
end

function buildLayout(kind, options)
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
  
  if kind == "linear" then
    start.render = renderChildren
    start.direction = options.direction or "v"
    if start.direction == "v" then
      start.layoutingPass = function(self) verticalLayout(self, self.children) end  
    else
      start.layoutingPass = function(self) horizontalLayout(self, self.children) end  
    end
    
  elseif kind == "text" then
    start.render = renderText
    start.text = options.text
    start.textColor = options.textColor or {255,255,255,255}
  elseif kind == "image" then
    start.render = renderImage
    start.image = love.graphics.newImage(options.file)
    start.contentWidth = imageWidth
    start.contentHeight = imageHeight
  end
  return start
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
        return self:contentWidth() + self.marginLeft + self.marginRight
      else
        return self.width + self.marginLeft + self.marginRight
      end
    end,
    desiredHeight = function(self)
      if self.height == "fill" then
        return self.height
      elseif self.height == "wrap" then
        return self:contentHeight() + self.marginTop + self.marginBottom
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

function imageWidth(self)
  return self.image:getWidth() + self.paddingLeft + self.paddingRight
end

function imageHeight(self)
  return self.image:getHeight() + self.paddingTop + self.paddingBottom
end