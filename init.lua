local _NAME = ...
  
local lc = require ( _NAME .. "/layoutcreator" )
lc:register("linear", require( _NAME .. "/layout/linear" )(lc))
lc:register("text", require( _NAME .. "/layout/text" )(lc))
lc:register("image", require( _NAME .. "/layout/image" )(lc))
lc:register("caption", require( _NAME .. "/layout/caption" )(lc))
lc:register("list", require( _NAME .. "/layout/list" )(lc))
lc:register("root", require( _NAME .. "/layout/root" )(lc))
lc:register("stack", require( _NAME .. "/layout/stack" )(lc))
lc:register("freeform", require( _NAME .. "/layout/freeform" )(lc))
lc:register("stackroot", require( _NAME .. "/layout/stackroot" )(lc))
lc:register("dragbox", require( _NAME .. "/layout/dragbox" )(lc))

return lc