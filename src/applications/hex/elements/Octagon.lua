local Super = require 'applications.hex.elements.Element'
local Self = Super:clone("Octagon")

Self.quad = love.graphics.newQuad(9*16, 8*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())
function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.color = {1, 1, 0.5}

	return self
end



return Self
