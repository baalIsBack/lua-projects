local Super = require 'engine.Prototype'
local Self = Super:clone("Hex")

require 'lib.hexgrid'

function Self:init(args)
  self.main = args.main
  Super.init(self, args)



  return self
end


return Self