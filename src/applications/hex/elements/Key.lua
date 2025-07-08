local Super = require 'applications.hex.elements.Element'
local Self = Super:clone("Key")

Self.quad = love.graphics.newQuad(10*16, 0*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())

function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)
  
  self.color = {1, 1, 1}

	return self
end

function Self:canSolve(otherElement)
  if otherElement:type() == "Lock" then
    return otherElement:canSolve(self)
  end
  return false
end


return Self
