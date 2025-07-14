local Super = require 'applications.hex.elements.Element'
local Self = Super:clone("Heptagon")

Self.quad = love.graphics.newQuad(0*16, 4*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())


function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.color = {1, 1, 0.3}

	return self
end



return Self
