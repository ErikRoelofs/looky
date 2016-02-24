local lc = require "layoutcreator"
lc:register("linear", require "layout/linear" )
lc:register("text", require "layout/text" )
lc:register("image", require "layout/image" )  
lc:register("caption", require "layout/caption" )
lc:register("list", require "layout/list" )
lc:register("root", require "layout/root" )
lc:register("stack", require "layout/stack" )
lc:register("freeform", require "layout/freeform" )

return lc