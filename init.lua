local _NAME = ...
  
local lc = require ( _NAME .. "/layoutcreator" )()
lc:registerLayout("linear", require( _NAME .. "/layout/linear" )(lc))
lc:registerLayout("text", require( _NAME .. "/layout/text" )(lc))
lc:registerLayout("image", require( _NAME .. "/layout/image" )(lc))
lc:registerLayout("caption", require( _NAME .. "/layout/caption" )(lc))
lc:registerLayout("list", require( _NAME .. "/layout/list" )(lc))
lc:registerLayout("root", require( _NAME .. "/layout/root" )(lc))
lc:registerLayout("stack", require( _NAME .. "/layout/stack" )(lc))
lc:registerLayout("freeform", require( _NAME .. "/layout/freeform" )(lc))
lc:registerLayout("stackroot", require( _NAME .. "/layout/stackroot" )(lc))
lc:registerLayout("dragbox", require( _NAME .. "/layout/dragbox" )(lc))
lc:registerLayout("numberasimage", require( _NAME .. "/layout/numberasimage" )(lc))

return lc