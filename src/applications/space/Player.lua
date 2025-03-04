local Super = require 'applications.space.GameObject'
local Self = Super:clone("Player")



function Self:init()
  Super.init(self)
  self:setVal("type", "Player")

  --self.serialized = self.serialization.vals
  self:setClientControlled()
  self:setVal("x", 0)
  self:setVal("y", 0)
  self.cooldown = 0
  self.cooldownMax = 0.5
  return self
end

function Self:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", self:getVal("x"), self:getVal("y"), 10)
end

function Self:update(dt)
  self.serialization:update(dt)
  --if self == main.player then
  if self:isClientControlled() then
    if love.keyboard.isDown("a") then
      self:setVal("x", self:getVal("x") - 100*dt)
    end
    if love.keyboard.isDown("d") then
      self:setVal("x", self:getVal("x") + 100*dt)
    end
    if love.keyboard.isDown("w") then
      self:setVal("y", self:getVal("y") - 100*dt)
    end
    if love.keyboard.isDown("s") then
      self:setVal("y", self:getVal("y") + 100*dt)
    end
    if love.keyboard.isDown("space") and self.cooldown <= 0 then
      local dummy = require 'applications.space.Dummy':new{}
      dummy:setVal("x", self:getVal("x"))
      dummy:setVal("y", self:getVal("y"))
      dummy:setOwner()
      main.multiplayer:send({
        dummy.serialization:serialize()
      })

      self.cooldown = self.cooldownMax
    end
  end

  self.cooldown = self.cooldown - dt
  --end
 
end

return Self