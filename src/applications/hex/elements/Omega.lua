local Super = require 'applications.hex.elements.Element'
local Self = Super:clone("Omega")

Self.quad = love.graphics.newQuad(4*16, 5*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())
function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.color = {0.6, 0.6, 0.6}

	return self
end

function Self:canResolveItself()
  return true
end


return Self
