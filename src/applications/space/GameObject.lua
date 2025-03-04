local Super = require 'engine.Prototype'
local Self = Super:clone("GameObject")



function Self:init()
  self.hasNetserialization = true
  Super.init(self)

  --self.serialized = self.serialization.vals
  --self:setClientControlled()
  --self:setVal("x", 0)
  --self:setVal("y", 0)
  self:setVal("type", "GameObject")

  return self
end

function Self:setOwner(owner)
  local owner = owner or main.multiplayer.clientID
  self:setVal("owner", owner)
end

function Self:setClientControlled()
  self:setVal("clientControlled", main.multiplayer.clientID)
end

function Self:isClientControlled()
  return self.serialization.vals.clientControlled == main.multiplayer.clientID
end

function Self:isOwned()
  return self:getVal("owner") == main.multiplayer.clientID
end

function Self:draw()
  --love.graphics.setColor(1, 1, 1)
  --love.graphics.circle("fill", self:getVal("x"), self:getVal("y"), 10)
end

function Self:update(dt)
  self.serialization:update(dt)
  --[[
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
  end
  ]]
end

return Self