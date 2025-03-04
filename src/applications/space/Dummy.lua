local Super = require 'applications.space.GameObject'
local Self = Super:clone("Dummy")



function Self:init()
  Super.init(self)
  self:setVal("type", "Dummy")

  --self.serialized = self.serialization.vals
  self:setVal("x", 0)
  self:setVal("y", 0)
  self.radius = 3
  return self
end

function Self:draw()
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", self:getVal("x"), self:getVal("y"), self.radius)
end

function Self:update(dt)
  self.serialization:update(dt)
  self:setVal("x", self:getVal("x") + 50*dt)

  --if self == main.player then
  
  --end
 
end

return Self