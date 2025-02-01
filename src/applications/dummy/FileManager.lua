local Super = require 'engine.Prototype'
local Self = Super:clone("FileManager")


function Self:init(args)
  self.hasSerialization = true
  Super.init(self)
  self.main = args.main
  
  

  return self
end

function Self:serialize()
  local t = {
    
  }
  return t
end

function Self:deserialize(raw)
  
  return self
end



return Self