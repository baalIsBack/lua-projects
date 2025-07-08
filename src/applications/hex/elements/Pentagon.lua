local Super = require 'applications.hex.elements.Element'
local Self = Super:clone("Pentagon")

Self.quad = love.graphics.newQuad(5*16, 10*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())
function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.color = {0.5, 1, 0.5}

	return self
end


return Self
