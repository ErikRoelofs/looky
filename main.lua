function love.load()
  --mobdebug = require("mobdebug") mobdebug.start()
  root = newRoot()
  
  layout = newLayout(150,"fill",{100,200,50,100})
  root:addChild(layout)
  
  layout2 = newLayout("fill","fill",{255,0,0,200})
  root:addChild(layout2)
  
  layout3 = newLayout(250,"fill",{0,255,0,200})
  root:addChild(layout3)

  layout4 = newLayout("fill","fill",{255,0,0,200})
  root:addChild(layout4)

  layout:addChild( newLayout( "fill", 120, {200, 50, 50, 200}))
  layout:addChild( newLayout( "fill", 40, {20, 30, 40, 200}))
  
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
      -- allocate all fills leftover size divided equally over all fill items
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
      love.graphics.setColor(color)
      love.graphics.rectangle("fill", 0, 0, self:grantedWidth(), self:grantedHeight())
      
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
  }
end

verticalLayout = function(parent, children)
  local availableSize = parent:desiredWidth();      
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
end