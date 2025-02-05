local Super = require 'engine.Prototype'
local Self = Super:clone("Serializationmanager")


function Self:init()
  Super.init(self)

  
  return self
end

function Self:serialize()
  error("Self:serialize() not implemented for " .. self:type())
end

function Self:deserialize(raw)
  error("Self:deserialize(raw) not implemented for " .. self:type())
end


return Self


