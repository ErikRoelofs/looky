local _NAME = ...
  
local lc = require ( _NAME .. "/layoutcreator" )
lc:register("linear", require( _NAME .. "/layout/linear" ))
lc:register("text", require( _NAME .. "/layout/text" ))
lc:register("image", require( _NAME .. "/layout/image" ))
lc:register("caption", require( _NAME .. "/layout/caption" ))
lc:register("list", require( _NAME .. "/layout/list" ))
lc:register("root", require( _NAME .. "/layout/root" ))
lc:register("stack", require( _NAME .. "/layout/stack" ))
lc:register("freeform", require( _NAME .. "/layout/freeform" ))

return lc