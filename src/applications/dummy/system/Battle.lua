local Super = require 'engine.Prototype'
local Self = Super:clone("Battle")




function Self:init(args)--mail_prototype_id, id, read, reply)
  self.main = args.main
  self.hasCallbacks = true
  Super.init(self, args)
  
  

  return self
end





return Self