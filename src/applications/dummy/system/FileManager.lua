local Super = require 'engine.Prototype'
local Self = Super:clone("Files")



function Self:init(args)
  self.main = args.main
  self.hasContents = true
  self.hasSerialization = true
  Super.init(self)
  
  return self
end

function Self:serialize()
  local t = {}
  return t
end

function Self:deserialize(raw)
  
  return self
end



return Self