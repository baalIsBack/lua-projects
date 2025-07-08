local Super = require 'applications.hex.elements.Element'
local Self = Super:clone("Square")

Self.quad = love.graphics.newQuad(6*16, 11*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())
function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.color = {0.5, 1, 1}
	return self
end

return Self
