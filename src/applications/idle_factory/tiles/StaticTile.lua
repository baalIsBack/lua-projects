local Super = require 'applications.idle_factory.tiles.Tile'
local Self = Super:clone("StaticTile")

Self.img = love.graphics.newImage("submodules/lua-projects-private/gfx/s4m_ur4i_factory-o-pixelart/tileset.png")
Self.QUADS = {}
for x = 0, 10-1 do
  Self.QUADS[x] = {}
  for y = 0, 11-1 do
    Self.QUADS[x][y] = love.graphics.newQuad(x*16, y*16, 16, 16, Self.img:getWidth(), Self.img:getHeight())
  end
end

Self.ox = 8
Self.oy = 8

function Self:init(args)
  assert((args.quad or self.quad) and (args.img or self.img), "StaticTile must be initialized with quad and img ", args.quad, args.img, self.quad, self.img)
  Super.init(self, args)

  self.quad = args.quad
  self.img = args.img

  self.rotation = 0--math.random(0, 3) * math.pi/2 -- Random rotation for the tile
  return self
end

function Self:draw(timestamp)
  local x, y = self.x, self.y
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.img, self.quad, (x)*self.TILE_WIDTH, (y)*self.TILE_HEIGHT, self.rotation, 2, 2, self.ox, self.oy)
  
  
end


return Self