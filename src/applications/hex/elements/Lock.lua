local Super = require 'applications.hex.elements.Element'
local Self = Super:clone("Lock")

Self.lockLevel = 1
local QUADS = {}
for i = 0, 9 do
  if not (i == 2 or i == 8) then
    table.insert(QUADS, love.graphics.newQuad(i*16, 0*16, 16, 16, Self.img:getWidth(), Self.img:getHeight()))
    
  end
end
--shuffle quads
for i = #QUADS, 2, -1 do
  local j = math.random(i)
  QUADS[i], QUADS[j] = QUADS[j], QUADS[i]
end

Self.quad = love.graphics.newQuad(0*16, 0*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())

function Self:init(args)
  self.hasCallbacks = true
  Super.init(self, args)


  self.color = {1, 1, 1}

  self.lockLevel = Self.lockLevel
  Self.lockLevel = Self.lockLevel + 1

  
  self.quad = QUADS[self.lockLevel]

	return self
end

function Self:reset()
  Self.lockLevel = 1
end

function Self:canSolve(otherElement)
  local result = otherElement:type() == "Key" and self:isOpen()
  
  return result
end

function Self:isOpen()
  return self.grid.locklevel >= self.lockLevel
end

function Self:resolve()
  self.grid.locklevel = self.grid.locklevel + 1
end


function Self:draw()
  Super.draw(self)
  
  love.graphics.setColor(1, 0, 0)
  love.graphics.print(self.lockLevel, self.tween.x-4, self.tween.y-4, 0, 1, 1)

  love.graphics.setColor(1, 1, 1)
end

return Self
