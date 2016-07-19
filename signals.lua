-- a view should be able to send signals to its children

-- a view should be able to receive signals from the outside

-- a view should be able to send signals to the outside

-- a view should be able to pass on external signals to its children

-- a view should be able to pass on child signals to its outside

-- should there be two signal tables?

-- use cases:

-- a proxy (like bordered) should act like it isn't even there
  --> any child event goes to outside
  --> any outside event goes to child

-- a general event (like a keypress or drag/drop) should be distributed to all children
  --> outside event goes to all children

-- a targeted event (like a mouseclick) should be distributed to the proper child(ren)
  --> outside event goes to targeted child
  
-- a child being selected should signal its parent (or other listeners)
  --> child signal the outside
  
-- a parent receiving a selection event should signal its other children
  --> upon receiving a selection event from a child, signal other children