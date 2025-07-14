local Super = require 'applications.hex.elements.Element'
local Self = Super:clone("TriangleUp")


Self.quad = love.graphics.newQuad(2*16, 6*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())
function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)

  self.color = {1, 1, 1}

	return self
end

function Self:canSolve(otherElement)
  return otherElement:type() == "TriangleDown"
end


return Self
