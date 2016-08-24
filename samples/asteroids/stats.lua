return function(looky)
  return {
    build = function (options)
        local shipView = looky:build("linear", { width = 250, height = "wrap", direction = "v", padding = looky.padding( 15 ) })    
        shipView:addChild(looky:build("bar", { img = "images/asteroids/speedicn.png", value = function() return math.abs(player.spd) end, maxValue = player.maxSpd }))
        shipView:addChild(looky:build("bar", { img = "images/asteroids/firepowericn.png", value = function() return player.power end, maxValue = player.maxPower }))
      return shipView
    end,
    schema = {}
  }
end