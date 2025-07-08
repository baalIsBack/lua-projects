local Super = require 'applications.idle_factory.tiles.StaticTile'
local Self = Super:clone("Empty")


Self.quad = Self.QUADS[9][10]

function Self:init(args)
  Super.init(self, args)

  return self
end


return Self