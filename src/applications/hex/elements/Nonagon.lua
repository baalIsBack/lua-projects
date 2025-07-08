local Super = require 'applications.hex.elements.Element'
local Self = Super:clone("Nonagon")

Self.quad = love.graphics.newQuad(3*16, 7*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())

function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.color = {1, 0.5, 1}

	return self
end



return Self
