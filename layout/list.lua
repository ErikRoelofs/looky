return function (base, options)
  local container = lc:build("linear", {direction = "v", width = options.width, height = options.height, backgroundColor = {0,0,255,255}})  
  
  local base = {width="wrap", height="wrap", backgroundColor = {255,0,0,255}, textColor={0,255,0,255}}
  local merged = lc:mergeOptions(base, options.textOptions or {})
  
  for k, v in ipairs( options.texts ) do
    local toPass = merged
    toPass.text = v
    container:addChild( lc:build( "text", toPass) )
  end
  return container
end