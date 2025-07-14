local Super = require 'applications.idle_factory.tiles.AnimatedTile'
local Self = Super:clone("Belt")

Self.img = love.graphics.newImage("submodules/lua-projects-private/gfx/s4m_ur4i_factory-o-pixelart/conveyor_idle.png")
Self.quads = {}
Self.ox = Self.TILE_WIDTH/4
Self.oy = Self.TILE_HEIGHT/4
for i=0, 15 do
  table.insert(Self.quads, love.graphics.newQuad(i*16, 0*16, 16, 16, Self.img:getWidth(), Self.img:getHeight()))
end

function Self:init(args)
  Super.init(self, args)

  return self
end


return Self