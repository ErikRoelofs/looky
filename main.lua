function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  root = newRoot()
  
  layout = buildLayout("linear", {width = 150, height = "fill", backgroundColor = {100,200,50,100}, marginRight = 20, marginLeft = 20})
  root:addChild(layout)
  
  layout2 = buildLayout("text", {width = 150, height = "fill", text = "this is a text item", textColor = {255,0,0,255}, paddingLeft = 10, paddingTop = 10})
  root:addChild(layout2)
  
  layout3 = buildLayout("linear", {width = 250, height = "fill", backgroundColor = {0, 255, 0, 200}})
  root:addChild(layout3)

  layout4 = buildLayout("linear", {width = "fill", height = "fill", backgroundColor = {255, 255, 0, 200}, paddingLeft = 50, paddingBottom = 200, paddingTop = 25})
  root:addChild(layout4)


  layout:addChild( buildLayout("text", {width = "fill", height = 100, text = "list 1", textColor = {255,0,0,255}}) )
  layout:addChild( buildLayout("text", {width = "fill", height = 100, text = "list 2", textColor = {255,0,0,255}, backgroundColor = {255,255,255,255}}) )
  --layout:addChild( newLayout( "fill", 120, {200, 50, 50, 200}))
  --layout:addChild( newLayout( "fill", 40, {20, 30, 40, 200}))
  
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
    layoutingPass = function(self)
      verticalLayout(self, self.children)      
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

function newLayout(width, height, color)
  return {
    children = {},
    parent = nil,
    width = width,
    height = height,
    givenWidth = 0,
    givenHeight = 0,
    color = color,
    direction = "v",
    text = "test",
    addChild = function(self, child)
      table.insert(self.children, child)
      child:setParent(self)
    end,
    setParent = function(self, parent)
      self.parent = parent
    end,
    desiredWidth = function(self)      
      return self.width
    end,
    desiredHeight = function(self)
      return self.height
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
    layoutingPass = function(self)
      
    end,
    render = function(self)
      renderText(self)     
    end
  }
end

renderText = function(self)
  love.graphics.setColor(self.backgroundColor)
  local width = self:grantedWidth() - (self.paddingLeft + self.paddingRight)
  local height = self:grantedHeight() - (self.paddingTop + self.paddingBottom)
  love.graphics.rectangle("fill", self.paddingLeft, self.paddingTop, width, height)  
  
  love.graphics.setColor(self.textColor or {255,255,255,255})
  love.graphics.print(self.text,self.paddingLeft,self.paddingTop)

end

renderImage = function(self)
  
end

renderChildren = function(self) 
  love.graphics.setColor(self.backgroundColor)
  local width = self:grantedWidth() - (self.paddingLeft + self.paddingRight)
  local height = self:grantedHeight() - (self.paddingTop + self.paddingBottom)
  love.graphics.rectangle("fill", self.paddingLeft, self.paddingTop, width, height)

  local offset = 0
  
  for k, v in ipairs(self.children) do
    love.graphics.push()
    if self.direction == "v" then 
      love.graphics.translate(0, offset)
      offset = offset + v:grantedHeight()
    else
      love.graphics.translate(offset, 0)
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
  
  if kind == "linear" then
    start.render = renderChildren
    start.layoutingPass = function(self) verticalLayout(self, self.children) end
    start.backgroundColor = options.backgroundColor or {0,0,0,0}
    start.text = "linear"
    start.textColor = {255,255,255,255}
  elseif kind == "text" then
    start.render = renderText
    start.backgroundColor = options.backgroundColor or {0,0,0,0}
    start.text = options.text
    start.textColor = options.textColor or {255,255,255,255}
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
      else
        return self.width + self.marginLeft + self.marginRight
      end
    end,
    desiredHeight = function(self)
      if self.height == "fill" then
        return self.height 
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
    layoutingPass = function(self)
      
    end,
    render = function(self)
    
    end
  }
end

verticalLayout = function(parent, children)
  local availableSize = parent:grantedWidth();      
  local fills = {}
  for k, v in ipairs(children) do
    if v:desiredWidth() == "fill" then
      table.insert(fills, v)
    else
      local height = v:desiredHeight()
      if height == "fill" then
        height = parent:grantedHeight()
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