local Super = require 'applications.idle_factory.tiles.AnimatedTile'
local Self = Super:clone("Compactor")

Self.img = love.graphics.newImage("submodules/lua-projects-private/gfx/s4m_ur4i_factory-o-pixelart/compactor_idle.png")
Self.quads = {}
Self.ox = Self.TILE_WIDTH/4
Self.oy = 3*Self.TILE_HEIGHT/4

for i=1-1, 20-1 do
  table.insert(Self.quads, love.graphics.newQuad(i*16, 0*16, 16, 32, Self.img:getWidth(), Self.img:getHeight()))
end

function Self:init(args)
  Super.init(self, args)

  return self
end


return Self