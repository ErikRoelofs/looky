function newObj(id)  
  return {
    id = id,    
    children = {},
    outside = {},
    addChild = function(self, child)
      table.insert(self.children, child)
      table.insert(child.outside, self)
    end,
    signalChildren = function(self, signal, payload)
      for i, c in ipairs(self.children) do
        c:receiveSignal(signal, payload)
      end
    end,
    receiveSignal = function(self, signal, payload)
      self:signalChildren(signal, payload)
    end,
    messageOut = function(self, signal, payload)
      for i, o in ipairs(self.outside) do
        o:receiveSignal(signal, payload)
      end
    end
  }
end

function newItem(id)
  local obj = newObj(id)
  obj.active = false
  obj.isActive = function(self)
    return self.active
  end
  obj.isInactive = function(self)
    return not self.active
  end
  obj.receiveSignal = function(self, signal, payload)
    if signal == "leftclick" or signal == "select" then
      self.active = true
      self:messageOut("I_am_selected", {child = self})
    end
    if signal == "unselect" then
      self.active = false
    end
  end
  return obj
end

function addChannel() end

root = newObj("root")
list = newObj("list")
item1 = newItem("item1")
item2 = newItem("item2")
item3 = newItem("item3")

root:addChild(list)
list:addChild(item1)
list:addChild(item2)
list:addChild(item3)

root.leftClick = function(self, x,y)
  self:signalChildren("leftclick", {x = x, y = y})
end

list.receiveSignal = function(self, signal, payload)
  if signal == "leftclick" and payload.y == 100 then
    self.children[1]:receiveSignal(signal, payload)
  end
  if signal == "leftclick" and payload.y == 150 then
    self.children[2]:receiveSignal(signal, payload)
  end
  if signal == "leftclick" and payload.y == 200 then
    self.children[3]:receiveSignal(signal, payload)
  end
  if signal == "I_am_selected" then
    for i, c in ipairs(self.children) do
      if payload.child ~= c then
        c:receiveSignal("unselect", {})
      end
    end
  end
end

root:leftClick(100, 100)
assert(item1:isActive(), "item 1 is not active!")
assert(item2:isInactive(), "item 2 should not be active!")
assert(item3:isInactive(), "item 3 should not be active!")

root:leftClick(100, 150)
assert(item2:isActive(), "item 2 is not active!")
assert(item1:isInactive(), "item 1 should not be active!")
assert(item3:isInactive(), "item 3 should not be active!")

item3:receiveSignal("select", {})
assert(item3:isActive(), "item 3 is not active!")
assert(item1:isInactive(), "item 1 should not be active!")
assert(item2:isInactive(), "item 2 should not be active!")


error("Actually, all is well.")