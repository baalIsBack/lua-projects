local Super = require 'applications.hex.elements.Element'
local Self = Super:clone("TriangleDown")

Self.quad = love.graphics.newQuad(8*16, 6*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())
function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.color = {0.8, 0.7, 0.7}

	return self
end

function Self:canSolve(otherElement)
  return otherElement:type() == "TriangleUp"
end


return Self
